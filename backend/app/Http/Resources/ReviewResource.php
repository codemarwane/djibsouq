<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ReviewResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'productId' => $this->product_id,
            'userId' => $this->user_id,
            'userName' => $this->whenLoaded('user', fn () => $this->user?->name),
            'rating' => (int) $this->rating,
            'comment' => $this->comment,
            'isApproved' => (bool) $this->is_approved,
            'createdAt' => $this->created_at?->toIso8601String(),
        ];
    }
}
