<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class UserManagementController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = User::query()->orderByDesc('id');

        if ($request->filled('role')) {
            $query->where('role', $request->string('role'));
        }

        if ($request->filled('search')) {
            $s = '%'.$request->string('search').'%';
            $query->where(function ($q) use ($s) {
                $q->where('name', 'like', $s)
                    ->orWhere('email', 'like', $s);
            });
        }

        return UserResource::collection(
            $query->paginate(min((int) $request->input('per_page', 20), 100))
        );
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255|unique:users,email',
            'password' => 'required|string|min:8|confirmed',
            'phone' => 'nullable|string|max:32',
            'locale' => 'nullable|string|max:10',
            'role' => 'nullable|string|in:customer,admin,staff',
            'avatar_path' => 'nullable|string|max:2048',
        ]);

        $user = User::query()->create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => $validated['password'],
            'phone' => $validated['phone'] ?? null,
            'locale' => $validated['locale'] ?? 'fr',
            'role' => $validated['role'] ?? 'customer',
            'avatar_path' => $validated['avatar_path'] ?? null,
            'is_active' => true,
            'failed_login_attempts' => 0,
        ]);

        return response()->json(['data' => new UserResource($user)], 201);
    }

    public function show(User $user): UserResource
    {
        return new UserResource($user);
    }

    public function update(Request $request, User $user): UserResource
    {
        $validated = $request->validate([
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|unique:users,email,'.$user->id,
            'password' => 'sometimes|string|min:8|confirmed',
            'phone' => 'nullable|string|max:32',
            'locale' => 'sometimes|string|max:10',
            'role' => 'sometimes|string|in:customer,admin,staff',
            'avatar_path' => 'nullable|string|max:2048',
            'is_active' => 'sometimes|boolean',
            'inactive_reason' => 'nullable|string|max:64|in:admin,max_login_attempts',
        ]);

        if (array_key_exists('password', $validated)) {
            $user->password = $validated['password'];
            unset($validated['password']);
        }

        if (array_key_exists('is_active', $validated)) {
            if ($validated['is_active']) {
                $validated['inactive_reason'] = null;
                $validated['failed_login_attempts'] = 0;
            } else {
                $validated['inactive_reason'] = $validated['inactive_reason'] ?? 'admin';
            }
        }

        $user->fill($validated);
        $user->save();

        return new UserResource($user->fresh());
    }

    public function destroy(Request $request, User $user): JsonResponse
    {
        if ((int) $user->id === (int) $request->user()->id) {
            return response()->json([
                'message' => 'Vous ne pouvez pas supprimer votre propre compte.',
            ], 422);
        }

        if ($user->orders()->exists()) {
            return response()->json([
                'message' => 'Impossible de supprimer : cet utilisateur a des commandes.',
            ], 422);
        }

        $user->tokens()->delete();
        $user->delete();

        return response()->json(['message' => 'Utilisateur supprimé.']);
    }
}
