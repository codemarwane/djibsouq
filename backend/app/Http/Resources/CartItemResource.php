<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CartItemResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'quantity' => (int) $this->quantity,
            'unitPriceSnapshot' => (float) $this->unit_price_snapshot,
            'product' => new ProductResource($this->whenLoaded('product')),
        ];
    }
}
