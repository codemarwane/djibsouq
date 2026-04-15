<?php

namespace Tests\Feature\Api;

use App\Models\Category;
use App\Models\Product;
use App\Models\Promotion;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;

class PromotionApiTest extends TestCase
{
    use DatabaseTransactions;

    public function test_promotions_index_lists_active_promotions(): void
    {
        $category = Category::query()->create([
            'name' => 'Cat',
            'slug' => 'cat',
            'sort_order' => 0,
            'is_active' => true,
        ]);

        $product = Product::query()->create([
            'category_id' => $category->id,
            'title' => 'Item',
            'slug' => 'item',
            'description' => 'x',
            'price' => 10,
            'is_published' => true,
        ]);

        $promo = Promotion::query()->create([
            'title' => 'Soldes',
            'description' => null,
            'discount_type' => 'percent',
            'discount_value' => 10,
            'starts_at' => now()->subDay(),
            'ends_at' => now()->addWeek(),
            'is_active' => true,
        ]);

        $promo->products()->attach($product->id);

        $response = $this->getJson('/api/promotions');

        $response->assertOk()
            ->assertJsonPath('data.0.title', 'Soldes');
    }
}
