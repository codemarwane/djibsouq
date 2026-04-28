<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Product;
use App\Models\Promotion;
use Illuminate\Database\Seeder;


/**
 * Insère des promotions actives et relie catégories + un échantillon aléatoire de produits.
 * Idempotent par titre de promotion.
 */
class PromotionSeeder extends Seeder
{
    /**
     * @return void
     */
    public function run(): void
    {
        $promotions = [
            [
                'title' => 'Offre Electronique Flash',
                'description' => 'Jusqu a 20% sur une selection de produits electroniques.',
                'discount_type' => 'percentage',
                'discount_value' => 20,
                'starts_at' => now()->subDays(2),
                'ends_at' => now()->addDays(10),
                'is_active' => true,
                'banner_image_path' => 'promotions/electronique-flash.jpg',
                'category_slugs' => ['electronique'],
            ],
            [
                'title' => 'Maison Confort',
                'description' => 'Reduction fixe sur les produits maison.',
                'discount_type' => 'fixed',
                'discount_value' => 15,
                'starts_at' => now()->subDay(),
                'ends_at' => now()->addDays(15),
                'is_active' => true,
                'banner_image_path' => 'promotions/maison-confort.jpg',
                'category_slugs' => ['maison'],
            ],
            [
                'title' => 'Sport Week-End',
                'description' => 'Promo sur les essentiels sport.',
                'discount_type' => 'percentage',
                'discount_value' => 12,
                'starts_at' => now()->subDays(3),
                'ends_at' => now()->addDays(7),
                'is_active' => true,
                'banner_image_path' => 'promotions/sport-weekend.jpg',
                'category_slugs' => ['sports', 'vetements'],
            ],
        ];

        foreach ($promotions as $item) {
            $categorySlugs = $item['category_slugs'];
            unset($item['category_slugs']);

            $promotion = Promotion::query()->updateOrCreate(
                ['title' => $item['title']],
                $item
            );

            $categories = Category::query()
                ->whereIn('slug', $categorySlugs)
                ->get();

            $promotion->categories()->sync($categories->pluck('id')->all());

            $productIds = Product::query()
                ->whereIn('category_id', $categories->pluck('id')->all())
                ->inRandomOrder()
                ->limit(6)
                ->pluck('id')
                ->all();

            $promotion->products()->sync($productIds);
        }
    }
}
