<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class PromotionResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $banner = $this->banner_image_path;

        return [
            'id' => $this->id,
            'title' => $this->title,
            'description' => $this->description,
            'discountType' => $this->discount_type,
            'discountValue' => (float) $this->discount_value,
            'startsAt' => $this->starts_at?->toIso8601String(),
            'endsAt' => $this->ends_at?->toIso8601String(),
            'isActive' => (bool) $this->is_active,
            'bannerImagePath' => $banner,
            'bannerImageUrl' => $banner
                ? (str_starts_with($banner, 'http://') || str_starts_with($banner, 'https://')
                    ? $banner
                    : Storage::disk('public')->url($banner))
                : null,
            'products' => ProductResource::collection($this->whenLoaded('products')),
            'categories' => CategoryResource::collection($this->whenLoaded('categories')),
        ];
    }
}
