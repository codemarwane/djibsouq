<?php

namespace Tests\Feature\Api;

use App\Http\Controllers\Api\AuthController;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class AccountSecurityTest extends TestCase
{
    use RefreshDatabase;

    public function test_login_locks_after_five_failed_attempts(): void
    {
        $user = User::factory()->create(['password' => 'password']);

        for ($i = 0; $i < AuthController::MAX_LOGIN_FAILURES; $i++) {
            $response = $this->postJson('/api/auth/login', [
                'email' => $user->email,
                'password' => 'wrong-password',
            ]);
            $response->assertStatus(422);
        }

        $user->refresh();
        $this->assertFalse($user->is_active);
        $this->assertSame('max_login_attempts', $user->inactive_reason);
        $this->assertSame(AuthController::MAX_LOGIN_FAILURES, $user->failed_login_attempts);
    }

    public function test_login_rejected_when_account_disabled_by_admin(): void
    {
        $user = User::factory()->create([
            'password' => 'password',
            'is_active' => false,
            'inactive_reason' => 'admin',
        ]);

        $response = $this->postJson('/api/auth/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);

        $response->assertStatus(422);
        $response->assertJsonValidationErrors(['email']);
    }

    public function test_inactive_user_with_token_receives_403_on_protected_route(): void
    {
        $user = User::factory()->create([
            'is_active' => false,
            'inactive_reason' => 'admin',
        ]);

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/user');

        $response->assertStatus(403);
    }

    public function test_admin_can_reactivate_and_response_includes_last_login_at(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $customer = User::factory()->create([
            'is_active' => false,
            'inactive_reason' => 'admin',
            'failed_login_attempts' => 3,
            'last_login_at' => now()->subDay(),
        ]);

        $expectedLastLogin = $customer->last_login_at?->toIso8601String();

        Sanctum::actingAs($admin);

        $response = $this->patchJson("/api/admin/users/{$customer->id}", [
            'is_active' => true,
        ]);

        $response->assertOk();
        $response->assertJsonPath('data.lastLoginAt', $expectedLastLogin);

        $customer->refresh();
        $this->assertTrue($customer->is_active);
        $this->assertNull($customer->inactive_reason);
        $this->assertSame(0, $customer->failed_login_attempts);
    }

    public function test_successful_login_updates_last_login_at_and_resets_failed_attempts(): void
    {
        $user = User::factory()->create([
            'password' => 'password',
            'failed_login_attempts' => 2,
            'last_login_at' => null,
        ]);

        $this->travelTo(now()->startOfSecond());

        $response = $this->postJson('/api/auth/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);

        $response->assertOk();

        $user->refresh();
        $this->assertSame(0, $user->failed_login_attempts);
        $this->assertNotNull($user->last_login_at);
    }
}
