<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CartResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'guestToken' => $this->guest_token,
            'items' => CartItemResource::collection($this->whenLoaded('items')),
            'itemsCount' => $this->when($this->relationLoaded('items'), fn () => $this->items->count()),
            'subtotal' => $this->when($this->relationLoaded('items'), function () {
                return round($this->items->sum(fn ($i) => $i->quantity * (float) $i->unit_price_snapshot), 2);
            }),
        ];
    }
}
