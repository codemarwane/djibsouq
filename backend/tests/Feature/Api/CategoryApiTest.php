<?php

namespace Tests\Feature\Api;

use App\Models\Category;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Tests\TestCase;

class CategoryApiTest extends TestCase
{
    use DatabaseTransactions;

    public function test_categories_index_lists_active_only(): void
    {
        Category::query()->create([
            'name' => 'Active',
            'slug' => 'active',
            'sort_order' => 0,
            'is_active' => true,
        ]);
        Category::query()->create([
            'name' => 'Hidden',
            'slug' => 'hidden',
            'sort_order' => 1,
            'is_active' => false,
        ]);

        $response = $this->getJson('/api/categories');

        $response->assertOk();
        $this->assertCount(1, $response->json('data'));
        $this->assertSame('Active', $response->json('data.0.name'));
    }
}
