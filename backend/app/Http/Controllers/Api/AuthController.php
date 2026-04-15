<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Services\CartService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public const MAX_LOGIN_FAILURES = 5;

    public function __construct(
        private CartService $cartService
    ) {}

    public function register(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email',
            'password' => 'required|string|min:8|confirmed',
            'phone' => 'nullable|string|max:32',
            'guest_token' => 'nullable|string|max:64',
        ]);

        $user = User::query()->create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => $validated['password'],
            'phone' => $validated['phone'] ?? null,
            'locale' => $request->input('locale', 'fr'),
            'role' => 'customer',
            'is_active' => true,
            'failed_login_attempts' => 0,
            'last_login_at' => now(),
        ]);

        if (! empty($validated['guest_token'])) {
            $this->cartService->mergeGuestCartIntoUser($user, $validated['guest_token']);
        }

        $token = $user->createToken('mobile')->plainTextToken;

        return response()->json([
            'user' => new UserResource($user),
            'token' => $token,
            'tokenType' => 'Bearer',
        ], 201);
    }

    public function login(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required|string',
            'guest_token' => 'nullable|string|max:64',
        ]);

        $user = User::query()->where('email', $validated['email'])->first();

        if ($user !== null && ! $user->is_active) {
            throw ValidationException::withMessages([
                'email' => [$this->inactiveMessage($user)],
            ]);
        }

        if (! Auth::attempt($request->only('email', 'password'))) {
            if ($user !== null) {
                $user->increment('failed_login_attempts');
                $user->refresh();
                if ($user->failed_login_attempts >= self::MAX_LOGIN_FAILURES) {
                    $user->forceFill([
                        'is_active' => false,
                        'inactive_reason' => 'max_login_attempts',
                    ])->save();
                }
            }

            throw ValidationException::withMessages([
                'email' => [__('auth.failed')],
            ]);
        }

        /** @var User $authenticated */
        $authenticated = Auth::user();
        $authenticated->forceFill([
            'failed_login_attempts' => 0,
            'last_login_at' => now(),
        ])->save();

        if (! empty($validated['guest_token'])) {
            $this->cartService->mergeGuestCartIntoUser($authenticated, $validated['guest_token']);
        }

        $authenticated->tokens()->delete();
        $token = $authenticated->createToken('mobile')->plainTextToken;

        return response()->json([
            'user' => new UserResource($authenticated->fresh()),
            'token' => $token,
            'tokenType' => 'Bearer',
        ]);
    }

    public function logout(Request $request): JsonResponse
    {
        $request->user()?->currentAccessToken()?->delete();

        return response()->json(['message' => 'Déconnecté.']);
    }

    private function inactiveMessage(User $user): string
    {
        return match ($user->inactive_reason) {
            'admin' => 'Ce compte a été désactivé par un administrateur.',
            'max_login_attempts' => 'Compte désactivé après trop de tentatives de connexion.',
            default => 'Ce compte est désactivé.',
        };
    }
}
