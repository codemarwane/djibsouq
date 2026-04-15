<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class ProductManagementController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Product::query()->with(['category', 'images']);

        if ($request->filled('category_id')) {
            $query->where('category_id', (int) $request->input('category_id'));
        }

        if ($request->has('is_published')) {
            $query->where('is_published', $request->boolean('is_published'));
        }

        if ($request->filled('search')) {
            $s = '%'.$request->string('search').'%';
            $query->where(function ($q) use ($s) {
                $q->where('title', 'like', $s)
                    ->orWhere('sku', 'like', $s);
            });
        }

        return ProductResource::collection(
            $query->orderByDesc('id')
                ->paginate(min((int) $request->input('per_page', 20), 100))
        );
    }

    public function show(Product $adminProduct): ProductResource
    {
        $adminProduct->load(['category', 'images']);

        return new ProductResource($adminProduct);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $this->storeRules($request);

        if (empty($validated['slug'])) {
            $validated['slug'] = Str::slug($validated['title']);
        }

        $product = Product::query()->create(array_merge([
            'stock_quantity' => 0,
            'reviews_count' => 0,
            'track_stock' => true,
            'is_best_seller' => false,
            'is_featured' => false,
            'is_published' => true,
        ], $validated));

        $product->load(['category', 'images']);

        return response()->json(['data' => new ProductResource($product)], 201);
    }

    public function update(Request $request, Product $adminProduct): JsonResponse
    {
        $validated = $request->validate([
            'category_id' => 'sometimes|integer|exists:categories,id',
            'title' => 'sometimes|string|max:255',
            'slug' => ['nullable', 'string', 'max:255', Rule::unique('products', 'slug')->ignore($adminProduct->id)],
            'sku' => ['nullable', 'string', 'max:64', Rule::unique('products', 'sku')->ignore($adminProduct->id)],
            'description' => 'sometimes|string',
            'price' => 'sometimes|numeric|min:0',
            'compare_at_price' => 'nullable|numeric|min:0',
            'discount_percent' => 'nullable|numeric|min:0|max:100',
            'stock_quantity' => 'sometimes|integer|min:0',
            'track_stock' => 'sometimes|boolean',
            'rating_avg' => 'nullable|numeric|min:0|max:5',
            'reviews_count' => 'sometimes|integer|min:0',
            'is_best_seller' => 'sometimes|boolean',
            'is_featured' => 'sometimes|boolean',
            'is_published' => 'sometimes|boolean',
            'primary_image_path' => 'nullable|string|max:2048',
        ]);

        if (array_key_exists('title', $validated) && ! array_key_exists('slug', $validated)) {
            $validated['slug'] = Str::slug($validated['title']);
        }

        $adminProduct->update($validated);
        $adminProduct->load(['category', 'images']);

        return response()->json(['data' => new ProductResource($adminProduct->fresh())]);
    }

    public function destroy(Product $adminProduct): JsonResponse
    {
        $adminProduct->delete();

        return response()->json(['message' => 'Produit supprimé (soft delete).']);
    }

    /**
     * @return array<string, mixed>
     */
    private function storeRules(Request $request): array
    {
        return $request->validate([
            'category_id' => 'required|integer|exists:categories,id',
            'title' => 'required|string|max:255',
            'slug' => 'nullable|string|max:255|unique:products,slug',
            'sku' => 'nullable|string|max:64|unique:products,sku',
            'description' => 'required|string',
            'price' => 'required|numeric|min:0',
            'compare_at_price' => 'nullable|numeric|min:0',
            'discount_percent' => 'nullable|numeric|min:0|max:100',
            'stock_quantity' => 'nullable|integer|min:0',
            'track_stock' => 'sometimes|boolean',
            'rating_avg' => 'nullable|numeric|min:0|max:5',
            'reviews_count' => 'nullable|integer|min:0',
            'is_best_seller' => 'sometimes|boolean',
            'is_featured' => 'sometimes|boolean',
            'is_published' => 'sometimes|boolean',
            'primary_image_path' => 'nullable|string|max:2048',
        ]);
    }
}
