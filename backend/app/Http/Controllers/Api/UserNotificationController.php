<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserNotificationResource;
use App\Models\UserNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class UserNotificationController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $notifications = $request->user()
            ->userNotifications()
            ->orderByDesc('id')
            ->paginate(min((int) $request->input('per_page', 20), 100));

        return UserNotificationResource::collection($notifications);
    }

    public function markRead(Request $request, UserNotification $notification): JsonResponse
    {
        $this->authorizeNotification($request, $notification);

        $notification->update(['read_at' => now()]);

        return response()->json(['message' => 'Notification lue.']);
    }

    public function markAllRead(Request $request): JsonResponse
    {
        $request->user()
            ->userNotifications()
            ->whereNull('read_at')
            ->update(['read_at' => now()]);

        return response()->json(['message' => 'Toutes les notifications sont marquées comme lues.']);
    }

    private function authorizeNotification(Request $request, UserNotification $notification): void
    {
        if ((int) $notification->user_id !== (int) $request->user()->id) {
            abort(403);
        }
    }
}
