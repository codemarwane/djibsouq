<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

/**
 * Aligné sur le modèle Flutter `Category` (id, name, image, icon, color).
 */
class CategoryResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'description' => $this->description,
            'image' => $this->image_path,
            'imageUrl' => $this->when($this->image_path, function () {
                $p = $this->image_path;
                if (str_starts_with($p, 'http://') || str_starts_with($p, 'https://')) {
                    return $p;
                }

                return Storage::disk('public')->url($p);
            }),
            'icon' => $this->icon_key,
            'color' => $this->accent_color_hex,
            'sortOrder' => $this->sort_order,
            'isActive' => $this->is_active,
        ];
    }
}
