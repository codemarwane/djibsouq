<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class ProductController extends Controller
{
    /**
     * Liste paginée des produits publiés.
     *
     * Query: `category_slug`, `category_id`, `per_page` (1–100, défaut 15).
     */
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Product::query()
            ->with(['category', 'images'])
            ->published();

        if ($request->filled('category_slug')) {
            $query->forCategorySlug($request->string('category_slug'));
        }

        if ($request->filled('category_id')) {
            $query->forCategoryId((int) $request->input('category_id'));
        }

        $perPage = min(max((int) $request->input('per_page', 15), 1), 100);

        return ProductResource::collection(
            $query->orderByDesc('is_featured')
                ->orderByDesc('is_best_seller')
                ->orderByDesc('id')
                ->paginate($perPage)
        );
    }

    /**
     * Détail produit (par id).
     */
    public function show(Product $product): ProductResource
    {
        $product->loadMissing(['category', 'images']);

        return new ProductResource($product);
    }
}
