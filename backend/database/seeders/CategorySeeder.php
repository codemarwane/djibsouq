<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Electronique',
                'slug' => 'electronique',
                'description' => 'Smartphones, ordinateurs, accessoires et gadgets.',
                'icon_key' => 'devices',
                'image_path' => 'categories/electronique.jpg',
                'accent_color_hex' => '#3B82F6',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'name' => 'Vetements',
                'slug' => 'vetements',
                'description' => 'Mode homme, femme et enfant.',
                'icon_key' => 'shopping_bag',
                'image_path' => 'categories/vetements.jpg',
                'accent_color_hex' => '#EC4899',
                'sort_order' => 2,
                'is_active' => true,
            ],
            [
                'name' => 'Maison',
                'slug' => 'maison',
                'description' => 'Decoration, cuisine et ameublement.',
                'icon_key' => 'home',
                'image_path' => 'categories/maison.jpg',
                'accent_color_hex' => '#10B981',
                'sort_order' => 3,
                'is_active' => true,
            ],
            [
                'name' => 'Sports',
                'slug' => 'sports',
                'description' => 'Equipements et accessoires sportifs.',
                'icon_key' => 'sports_soccer',
                'image_path' => 'categories/sports.jpg',
                'accent_color_hex' => '#F59E0B',
                'sort_order' => 4,
                'is_active' => true,
            ],
        ];

        foreach ($categories as $category) {
            Category::query()->updateOrCreate(
                ['slug' => $category['slug']],
                $category
            );
        }
    }
}
