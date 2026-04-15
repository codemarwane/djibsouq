<?php

namespace Tests\Feature\Api;

use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;

class AdminUserManagementTest extends TestCase
{
    use DatabaseTransactions;

    private function adminHeaders(): array
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $token = $admin->createToken('test')->plainTextToken;

        return [
            'Authorization' => 'Bearer '.$token,
            'Accept' => 'application/json',
        ];
    }

    public function test_admin_can_create_user(): void
    {
        $response = $this->postJson('/api/admin/users', [
            'name' => 'Nouveau',
            'email' => 'nouveau@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'role' => 'customer',
        ], $this->adminHeaders());

        $response->assertCreated()
            ->assertJsonPath('data.email', 'nouveau@example.com');

        $this->assertDatabaseHas('users', ['email' => 'nouveau@example.com', 'role' => 'customer']);
    }

    public function test_admin_can_delete_user_without_orders(): void
    {
        $headers = $this->adminHeaders();
        $admin = User::query()->where('role', 'admin')->first();

        $target = User::factory()->create(['email' => 'cible@example.com']);

        $response = $this->deleteJson('/api/admin/users/'.$target->id, [], $headers);

        $response->assertOk();
        $this->assertDatabaseMissing('users', ['id' => $target->id]);
    }

    public function test_admin_cannot_delete_self(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $token = $admin->createToken('test')->plainTextToken;

        $response = $this->deleteJson('/api/admin/users/'.$admin->id, [], [
            'Authorization' => 'Bearer '.$token,
            'Accept' => 'application/json',
        ]);

        $response->assertStatus(422);
        $this->assertDatabaseHas('users', ['id' => $admin->id]);
    }

    public function test_non_admin_cannot_access_admin_users(): void
    {
        $user = User::factory()->create(['role' => 'customer']);
        $token = $user->createToken('test')->plainTextToken;

        $this->getJson('/api/admin/users', [
            'Authorization' => 'Bearer '.$token,
            'Accept' => 'application/json',
        ])->assertForbidden();
    }
}
