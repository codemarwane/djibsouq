<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\OrderResource;
use App\Models\Address;
use App\Models\Cart;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use App\Models\UserNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class OrderController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $orders = $request->user()
            ->orders()
            ->with('items')
            ->orderByDesc('id')
            ->paginate(min((int) $request->input('per_page', 15), 100));

        return OrderResource::collection($orders);
    }

    public function show(Request $request, Order $order): OrderResource
    {
        $this->authorizeOrder($request, $order);
        $order->load('items');

        return new OrderResource($order);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'address_id' => 'required|integer|exists:addresses,id',
            'payment_method' => 'nullable|string|max:32',
            'notes' => 'nullable|string|max:2000',
            'shipping_amount' => 'nullable|numeric|min:0',
            'discount_amount' => 'nullable|numeric|min:0',
            'currency' => 'nullable|string|size:3',
        ]);

        /** @var \App\Models\User $user */
        $user = $request->user();

        $address = Address::query()
            ->where('user_id', $user->id)
            ->whereKey($validated['address_id'])
            ->firstOrFail();

        $cart = Cart::query()
            ->where('user_id', $user->id)
            ->with(['items.product'])
            ->first();

        if ($cart === null || $cart->items->isEmpty()) {
            return response()->json(['message' => 'Le panier est vide.'], 422);
        }

        foreach ($cart->items as $item) {
            $product = $item->product;
            if ($product === null) {
                return response()->json(['message' => 'Un produit du panier n\'est plus disponible.'], 422);
            }
            if ($product->track_stock && $product->stock_quantity < $item->quantity) {
                return response()->json([
                    'message' => 'Stock insuffisant pour : '.$product->title,
                ], 422);
            }
        }

        $shipping = (float) ($validated['shipping_amount'] ?? 0);
        $discount = (float) ($validated['discount_amount'] ?? 0);
        $currency = $validated['currency'] ?? 'DJF';

        $order = DB::transaction(function () use ($user, $cart, $address, $validated, $shipping, $discount, $currency) {
            $subtotal = round($cart->items->sum(fn ($i) => $i->quantity * (float) $i->unit_price_snapshot), 2);
            $total = round($subtotal + $shipping - $discount, 2);

            $snapshot = [
                'label' => $address->label,
                'full_name' => $address->full_name,
                'phone' => $address->phone,
                'line1' => $address->line1,
                'line2' => $address->line2,
                'city' => $address->city,
                'region' => $address->region,
                'postal_code' => $address->postal_code,
                'country_code' => $address->country_code,
            ];

            $order = Order::query()->create([
                'user_id' => $user->id,
                'order_number' => 'DJ-'.now()->format('Ymd').'-'.strtoupper(Str::random(6)),
                'status' => 'pending',
                'payment_status' => 'pending',
                'payment_method' => $validated['payment_method'] ?? null,
                'subtotal' => $subtotal,
                'shipping_amount' => $shipping,
                'discount_amount' => $discount,
                'total' => $total,
                'currency' => $currency,
                'shipping_address_snapshot' => $snapshot,
                'billing_address_snapshot' => null,
                'notes' => $validated['notes'] ?? null,
            ]);

            foreach ($cart->items as $item) {
                /** @var \App\Models\Product $product */
                $product = $item->product;

                OrderItem::query()->create([
                    'order_id' => $order->id,
                    'product_id' => $product->id,
                    'product_title_snapshot' => $product->title,
                    'unit_price' => $item->unit_price_snapshot,
                    'quantity' => $item->quantity,
                ]);

                if ($product->track_stock) {
                    $product->decrement('stock_quantity', $item->quantity);
                }
            }

            $cart->items()->delete();
            $cart->delete();

            return $order->load('items');
        });

        UserNotification::query()->create([
            'user_id' => $user->id,
            'title' => 'Commande confirmée',
            'body' => 'Votre commande '.$order->order_number.' a bien été enregistrée.',
            'data' => ['order_id' => $order->id],
        ]);

        return response()->json(['data' => new OrderResource($order)], 201);
    }

    private function authorizeOrder(Request $request, Order $order): void
    {
        if ((int) $order->user_id !== (int) $request->user()->id) {
            abort(403);
        }
    }
}
