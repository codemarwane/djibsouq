<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CartResource;
use App\Models\CartItem;
use App\Models\Product;
use App\Services\CartService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CartController extends Controller
{
    public function __construct(
        private CartService $cartService
    ) {}

    public function show(Request $request): JsonResponse
    {
        $guestHeader = $request->header('X-Guest-Token') ?? $request->query('guest_token');
        [$cart, $newToken] = $this->cartService->resolveCart(
            $request->user(),
            $guestHeader
        );

        $cart->load(['items.product.category', 'items.product.images']);

        return response()->json([
            'data' => new CartResource($cart),
            'guestToken' => $newToken,
        ]);
    }

    public function addItem(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'product_id' => 'required|integer|exists:products,id',
            'quantity' => 'required|integer|min:1|max:999',
            'guest_token' => 'nullable|string|max:64',
        ]);

        $guestHeader = $request->header('X-Guest-Token') ?? $request->input('guest_token');
        [$cart, $newToken] = $this->cartService->resolveCart(
            $request->user(),
            $guestHeader
        );

        $product = Product::query()->published()->findOrFail($validated['product_id']);

        if ($product->track_stock && $product->stock_quantity < $validated['quantity']) {
            return response()->json([
                'message' => 'Stock insuffisant pour ce produit.',
            ], 422);
        }

        $price = (float) $product->price;

        $item = $cart->items()->where('product_id', $product->id)->first();
        if ($item) {
            $newQty = $item->quantity + $validated['quantity'];
            if ($product->track_stock && $product->stock_quantity < $newQty) {
                return response()->json(['message' => 'Stock insuffisant pour cette quantité.'], 422);
            }
            $item->update([
                'quantity' => $newQty,
                'unit_price_snapshot' => $price,
            ]);
        } else {
            CartItem::query()->create([
                'cart_id' => $cart->id,
                'product_id' => $product->id,
                'quantity' => $validated['quantity'],
                'unit_price_snapshot' => $price,
            ]);
        }

        $cart->load(['items.product.category', 'items.product.images']);

        return response()->json([
            'data' => new CartResource($cart),
            'guestToken' => $newToken,
        ], 201);
    }

    public function updateItem(Request $request, CartItem $cartItem): JsonResponse
    {
        $this->authorizeCartItem($request, $cartItem);

        $validated = $request->validate([
            'quantity' => 'required|integer|min:1|max:999',
        ]);

        $cartItem->load('product');
        $product = $cartItem->product;
        if ($product && $product->track_stock && $product->stock_quantity < $validated['quantity']) {
            return response()->json(['message' => 'Stock insuffisant.'], 422);
        }

        $cartItem->update(['quantity' => $validated['quantity']]);

        $cart = $cartItem->cart->load(['items.product.category', 'items.product.images']);

        return response()->json(['data' => new CartResource($cart)]);
    }

    public function removeItem(Request $request, CartItem $cartItem): JsonResponse
    {
        $this->authorizeCartItem($request, $cartItem);

        $cart = $cartItem->cart;
        $cartItem->delete();

        $cart->load(['items.product.category', 'items.product.images']);

        return response()->json(['data' => new CartResource($cart)]);
    }

    public function clear(Request $request): JsonResponse
    {
        $guestHeader = $request->header('X-Guest-Token') ?? $request->query('guest_token');
        [$cart] = $this->cartService->resolveCart($request->user(), $guestHeader);

        $cart->items()->delete();

        return response()->json(['message' => 'Panier vidé.']);
    }

    private function authorizeCartItem(Request $request, CartItem $cartItem): void
    {
        if (! $request->user()) {
            $guestHeader = $request->header('X-Guest-Token') ?? $request->input('guest_token');
            if ($guestHeader === null || $guestHeader === '') {
                abort(422, 'En-tête X-Guest-Token ou paramètre guest_token requis pour un panier invité.');
            }
        }

        $guestHeader = $request->header('X-Guest-Token') ?? $request->input('guest_token');
        [$cart] = $this->cartService->resolveCart($request->user(), $guestHeader);

        if ((int) $cartItem->cart_id !== (int) $cart->id) {
            abort(403, 'Cet article ne fait pas partie de votre panier.');
        }
    }
}
