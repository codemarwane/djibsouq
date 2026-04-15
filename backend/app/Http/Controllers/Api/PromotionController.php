<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\PromotionResource;
use App\Models\Promotion;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class PromotionController extends Controller
{
    /**
     * Promotions actives (fenêtre de dates + is_active) avec produits publiés.
     */
    public function index(Request $request): AnonymousResourceCollection
    {
        $query = Promotion::query()
            ->activeNow()
            ->with(['products' => fn ($q) => $q->published()->with(['category', 'images'])])
            ->orderByDesc('id');

        if ($request->boolean('with_categories')) {
            $query->with('categories');
        }

        $perPage = min(max((int) $request->input('per_page', 15), 1), 100);

        return PromotionResource::collection($query->paginate($perPage));
    }

    public function show(Promotion $promotion): PromotionResource
    {
        $promotion->load([
            'products' => fn ($q) => $q->published()->with(['category', 'images']),
            'categories',
        ]);

        return new PromotionResource($promotion);
    }
}
