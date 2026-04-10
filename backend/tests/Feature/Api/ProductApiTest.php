<?php

namespace Tests\Feature\Api;

use App\Models\Category;
use App\Models\Product;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;

class ProductApiTest extends TestCase
{
    use DatabaseTransactions;

    public function test_products_index_returns_paginated_json(): void
    {
        $category = Category::query()->create([
            'name' => 'Électronique',
            'slug' => 'electronique',
            'sort_order' => 0,
            'is_active' => true,
        ]);

        Product::query()->create([
            'category_id' => $category->id,
            'title' => 'Test Phone',
            'slug' => 'test-phone',
            'description' => 'Desc',
            'price' => 99.99,
            'is_published' => true,
            'reviews_count' => 0,
        ]);

        $response = $this->getJson('/api/products?per_page=10');

        $response->assertOk()
            ->assertJsonPath('data.0.title', 'Test Phone')
            ->assertJsonStructure([
                'data',
                'links',
                'meta',
            ]);
    }

    public function test_products_index_filters_by_category_slug(): void
    {
        $catA = Category::query()->create([
            'name' => 'A',
            'slug' => 'cat-a',
            'sort_order' => 0,
            'is_active' => true,
        ]);
        $catB = Category::query()->create([
            'name' => 'B',
            'slug' => 'cat-b',
            'sort_order' => 1,
            'is_active' => true,
        ]);

        Product::query()->create([
            'category_id' => $catA->id,
            'title' => 'In A',
            'slug' => 'in-a',
            'description' => 'x',
            'price' => 10,
            'is_published' => true,
        ]);
        Product::query()->create([
            'category_id' => $catB->id,
            'title' => 'In B',
            'slug' => 'in-b',
            'description' => 'x',
            'price' => 20,
            'is_published' => true,
        ]);

        $response = $this->getJson('/api/products?category_slug=cat-a');

        $response->assertOk();
        $this->assertCount(1, $response->json('data'));
        $this->assertSame('In A', $response->json('data.0.title'));
    }

    public function test_product_show_returns_detail(): void
    {
        $category = Category::query()->create([
            'name' => 'Sports',
            'slug' => 'sports',
            'sort_order' => 0,
            'is_active' => true,
        ]);

        $product = Product::query()->create([
            'category_id' => $category->id,
            'title' => 'Ball',
            'slug' => 'ball',
            'description' => 'Round',
            'price' => 15,
            'compare_at_price' => 20,
            'is_published' => true,
            'is_best_seller' => true,
            'rating_avg' => 4.5,
            'reviews_count' => 3,
        ]);

        $response = $this->getJson('/api/products/'.$product->id);

        $response->assertOk()
            ->assertJsonPath('data.title', 'Ball')
            ->assertJsonPath('data.category', 'Sports')
            ->assertJsonPath('data.originalPrice', 20)
            ->assertJsonPath('data.isBestSeller', true);
    }

    public function test_unpublished_product_returns_404(): void
    {
        $category = Category::query()->create([
            'name' => 'X',
            'slug' => 'x',
            'sort_order' => 0,
            'is_active' => true,
        ]);

        $product = Product::query()->create([
            'category_id' => $category->id,
            'title' => 'Hidden',
            'slug' => 'hidden',
            'description' => 'x',
            'price' => 1,
            'is_published' => false,
        ]);

        $this->getJson('/api/products/'.$product->id)->assertNotFound();
    }
}
