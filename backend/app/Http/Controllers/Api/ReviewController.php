<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ReviewResource;
use App\Models\Product;
use App\Models\Review;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class ReviewController extends Controller
{
    public function index(Product $product): AnonymousResourceCollection
    {
        $reviews = Review::query()
            ->where('product_id', $product->id)
            ->where('is_approved', true)
            ->with('user:id,name')
            ->orderByDesc('id')
            ->paginate(20);

        return ReviewResource::collection($reviews);
    }

    public function store(Request $request, Product $product): JsonResponse
    {
        $validated = $request->validate([
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:5000',
        ]);

        $review = Review::query()->updateOrCreate(
            [
                'product_id' => $product->id,
                'user_id' => $request->user()->id,
            ],
            [
                'rating' => $validated['rating'],
                'comment' => $validated['comment'] ?? null,
                'is_approved' => true,
            ]
        );

        $this->refreshProductRating($product);

        return response()->json(['data' => new ReviewResource($review)], 201);
    }

    private function refreshProductRating(Product $product): void
    {
        $q = fn () => Review::query()
            ->where('product_id', $product->id)
            ->where('is_approved', true);

        $cnt = $q()->count();
        $avg = $q()->avg('rating');

        $product->update([
            'rating_avg' => $cnt > 0 ? round((float) $avg, 2) : null,
            'reviews_count' => $cnt,
        ]);
    }
}
