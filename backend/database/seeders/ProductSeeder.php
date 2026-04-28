<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        $productsByCategory = [
            'electronique' => [
                ['title' => 'iPhone 15 Pro', 'price' => 999.99, 'stock_quantity' => 18, 'is_best_seller' => true, 'is_featured' => true],
                ['title' => 'MacBook Air M3', 'price' => 1299.00, 'stock_quantity' => 12, 'is_best_seller' => true, 'is_featured' => true],
                ['title' => 'Casque Bluetooth Sony', 'price' => 199.90, 'stock_quantity' => 35, 'is_best_seller' => false, 'is_featured' => true],
                ['title' => 'Apple Watch Series 9', 'price' => 449.00, 'stock_quantity' => 20, 'is_best_seller' => true, 'is_featured' => false],
            ],
            'vetements' => [
                ['title' => 'Chemise Oxford Homme', 'price' => 39.90, 'stock_quantity' => 60, 'is_best_seller' => false, 'is_featured' => true],
                ['title' => 'Robe Elegante Femme', 'price' => 59.00, 'stock_quantity' => 42, 'is_best_seller' => true, 'is_featured' => true],
                ['title' => 'Sneakers Urbaines', 'price' => 89.00, 'stock_quantity' => 28, 'is_best_seller' => true, 'is_featured' => false],
                ['title' => 'Veste Legere', 'price' => 74.50, 'stock_quantity' => 25, 'is_best_seller' => false, 'is_featured' => true],
            ],
            'maison' => [
                ['title' => 'Canape 3 places', 'price' => 499.00, 'stock_quantity' => 6, 'is_best_seller' => true, 'is_featured' => true],
                ['title' => 'Lampe LED Design', 'price' => 34.90, 'stock_quantity' => 55, 'is_best_seller' => false, 'is_featured' => true],
                ['title' => 'Set Vaisselle 24 pieces', 'price' => 79.90, 'stock_quantity' => 22, 'is_best_seller' => true, 'is_featured' => false],
                ['title' => 'Tapis Moderne', 'price' => 119.00, 'stock_quantity' => 15, 'is_best_seller' => false, 'is_featured' => true],
            ],
            'sports' => [
                ['title' => 'Tapis de Yoga Premium', 'price' => 29.90, 'stock_quantity' => 70, 'is_best_seller' => true, 'is_featured' => false],
                ['title' => 'Halteres Reglables', 'price' => 149.00, 'stock_quantity' => 16, 'is_best_seller' => true, 'is_featured' => true],
                ['title' => 'Ballon de Football Pro', 'price' => 24.50, 'stock_quantity' => 80, 'is_best_seller' => false, 'is_featured' => true],
                ['title' => 'Montre Sport Connectee', 'price' => 169.00, 'stock_quantity' => 14, 'is_best_seller' => false, 'is_featured' => true],
            ],
        ];

        foreach ($productsByCategory as $categorySlug => $products) {
            $category = Category::query()->where('slug', $categorySlug)->first();
            if (! $category) {
                continue;
            }

            foreach ($products as $index => $payload) {
                $slug = Str::slug($payload['title']);
                $sku = strtoupper($categorySlug).'-'.str_pad((string) ($index + 1), 3, '0', STR_PAD_LEFT);

                Product::query()->updateOrCreate(
                    ['slug' => $slug],
                    [
                        'category_id' => $category->id,
                        'title' => $payload['title'],
                        'slug' => $slug,
                        'sku' => $sku,
                        'description' => 'Produit '.$payload['title'].' de la categorie '.$category->name.'.',
                        'price' => $payload['price'],
                        'compare_at_price' => round($payload['price'] * 1.15, 2),
                        'discount_percent' => 15,
                        'stock_quantity' => $payload['stock_quantity'],
                        'track_stock' => true,
                        'rating_avg' => fake()->randomFloat(2, 4.0, 5.0),
                        'reviews_count' => fake()->numberBetween(5, 250),
                        'is_best_seller' => $payload['is_best_seller'],
                        'is_featured' => $payload['is_featured'],
                        'is_published' => true,
                        'primary_image_path' => 'products/'.Str::slug($payload['title']).'.jpg',
                    ]
                );
            }
        }
    }
}
