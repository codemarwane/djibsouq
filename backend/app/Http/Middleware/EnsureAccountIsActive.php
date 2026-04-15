<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureAccountIsActive
{
    public function handle(Request $request, Closure $next): Response
    {
        if ($request->is('api/auth/logout')) {
            return $next($request);
        }

        $user = $request->user();
        if ($user !== null && ! $user->is_active) {
            $user->currentAccessToken()?->delete();

            return response()->json([
                'message' => 'Ce compte est désactivé.',
            ], Response::HTTP_FORBIDDEN);
        }

        return $next($request);
    }
}
