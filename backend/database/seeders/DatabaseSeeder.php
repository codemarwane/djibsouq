<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

/**
 * Point d’entrée du seed : catégories, produits, promotions, puis comptes de test (client + admin).
 * Les mots de passe sont en clair ici uniquement pour le développement local.
 */
class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Exécute les seeders enfants et crée ou met à jour les utilisateurs de démo.
     *
     * @return void
     */
    public function run(): void
    {
        $this->call([
            CategorySeeder::class,
            ProductSeeder::class,
            PromotionSeeder::class,
        ]);

        User::query()->updateOrCreate(['email' => 'test@example.com'], [
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
            'role' => 'customer',
            'is_active' => true,
            'inactive_reason' => null,
            'failed_login_attempts' => 0,
        ]);

        User::query()->updateOrCreate(['email' => 'admin@djibsouq.local'], [
            'name' => 'Admin Djibsouq',
            'email' => 'admin@djibsouq.local',
            'password' => 'password123',
            'role' => 'admin',
            'is_active' => true,
            'inactive_reason' => null,
            'failed_login_attempts' => 0,
        ]);
    }
}
