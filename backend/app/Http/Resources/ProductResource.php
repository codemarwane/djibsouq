<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

/**
 * Aligné sur le modèle Flutter `Product` (camelCase).
 */
class ProductResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'price' => (float) $this->price,
            'image' => $this->primary_image_path,
            'imageUrl' => $this->publicImageUrl(),
            'category' => $this->whenLoaded('category', fn () => $this->category?->name),
            'categoryId' => $this->category_id,
            'categorySlug' => $this->whenLoaded('category', fn () => $this->category?->slug),
            'description' => $this->description,
            'rating' => $this->rating_avg !== null ? (float) $this->rating_avg : null,
            'reviews' => (int) $this->reviews_count,
            'isBestSeller' => (bool) $this->is_best_seller,
            'discount' => $this->discount_percent !== null ? (float) $this->discount_percent : null,
            'originalPrice' => $this->compare_at_price !== null ? (float) $this->compare_at_price : null,
            'sku' => $this->sku,
            'stockQuantity' => (int) $this->stock_quantity,
            'isFeatured' => (bool) $this->is_featured,
            'images' => $this->whenLoaded(
                'images',
                fn () => ProductImageResource::collection($this->images),
            ),
        ];
    }

    private function publicImageUrl(): ?string
    {
        if (! $this->primary_image_path) {
            return null;
        }

        return $this->absoluteUrl($this->primary_image_path);
    }

    private function absoluteUrl(string $path): string
    {
        if (str_starts_with($path, 'http://') || str_starts_with($path, 'https://')) {
            return $path;
        }

        return Storage::disk('public')->url($path);
    }
}
