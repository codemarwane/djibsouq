<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use App\Models\WishlistItem;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class WishlistController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $ids = $request->user()->wishlistItems()->pluck('product_id');
        if ($ids->isEmpty()) {
            return ProductResource::collection(collect());
        }

        $products = Product::query()
            ->with(['category', 'images'])
            ->published()
            ->whereIn('id', $ids)
            ->orderByDesc('id')
            ->get();

        return ProductResource::collection($products);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'product_id' => 'required|integer|exists:products,id',
        ]);

        $product = Product::query()->published()->findOrFail($validated['product_id']);

        WishlistItem::query()->firstOrCreate([
            'user_id' => $request->user()->id,
            'product_id' => $product->id,
        ]);

        return response()->json(['message' => 'Ajouté aux favoris.'], 201);
    }

    public function destroy(Request $request, int $productId): JsonResponse
    {
        $request->user()->wishlistItems()->where('product_id', $productId)->delete();

        return response()->json(['message' => 'Retiré des favoris.']);
    }
}
