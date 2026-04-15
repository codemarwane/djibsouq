<?php

namespace App\Services;

use App\Models\Cart;
use App\Models\CartItem;
use App\Models\User;
use Illuminate\Support\Str;

class CartService
{
    /**
     * @return array{0: Cart, 1: string|null} Cart et éventuel nouveau jeton invité
     */
    public function resolveCart(?User $user, ?string $guestToken): array
    {
        if ($user !== null) {
            $cart = Cart::query()->firstOrCreate(
                ['user_id' => $user->id],
                [],
            );

            return [$cart, null];
        }

        if ($guestToken !== null && $guestToken !== '') {
            $cart = Cart::query()->firstOrCreate(
                ['guest_token' => $guestToken],
                ['guest_token' => $guestToken],
            );

            return [$cart, null];
        }

        $token = Str::uuid()->toString();
        $cart = Cart::query()->create(['guest_token' => $token]);

        return [$cart, $token];
    }

    public function mergeGuestCartIntoUser(User $user, string $guestToken): void
    {
        $guestCart = Cart::query()
            ->where('guest_token', $guestToken)
            ->whereNull('user_id')
            ->first();

        if ($guestCart === null) {
            return;
        }

        $userCart = Cart::query()->firstOrCreate(
            ['user_id' => $user->id],
            [],
        );

        foreach ($guestCart->items as $item) {
            $existing = $userCart->items()->where('product_id', $item->product_id)->first();
            if ($existing !== null) {
                $existing->update([
                    'quantity' => $existing->quantity + $item->quantity,
                ]);
            } else {
                CartItem::query()->create([
                    'cart_id' => $userCart->id,
                    'product_id' => $item->product_id,
                    'quantity' => $item->quantity,
                    'unit_price_snapshot' => $item->unit_price_snapshot,
                ]);
            }
        }

        $guestCart->delete();
    }
}
