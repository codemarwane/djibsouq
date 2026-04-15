<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class UserResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $avatar = $this->avatar_path;

        $isAdminContext = $request->user()?->role === 'admin'
            && str_contains($request->path(), 'admin/users');

        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'phone' => $this->phone,
            'avatarPath' => $avatar,
            'avatarUrl' => $avatar
                ? (str_starts_with($avatar, 'http://') || str_starts_with($avatar, 'https://')
                    ? $avatar
                    : Storage::disk('public')->url($avatar))
                : null,
            'locale' => $this->locale,
            'role' => $this->role,
            'isActive' => (bool) $this->is_active,
            'inactiveReason' => $this->when(
                ! $this->is_active,
                $this->inactive_reason
            ),
            'emailVerifiedAt' => $this->email_verified_at?->toIso8601String(),
            'createdAt' => $this->created_at?->toIso8601String(),
            'lastLoginAt' => $this->when($isAdminContext, $this->last_login_at?->toIso8601String()),
            'failedLoginAttempts' => $this->when($isAdminContext, (int) $this->failed_login_attempts),
        ];
    }
}
