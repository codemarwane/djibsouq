<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class ProductImageResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $path = $this->path;

        return [
            'id' => $this->id,
            'path' => $path,
            'url' => $path && (str_starts_with($path, 'http://') || str_starts_with($path, 'https://'))
                ? $path
                : Storage::disk('public')->url($path),
            'sortOrder' => $this->sort_order,
            'isPrimary' => (bool) $this->is_primary,
        ];
    }
}
