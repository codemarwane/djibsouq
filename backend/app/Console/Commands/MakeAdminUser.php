<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;

class MakeAdminUser extends Command
{
    protected $signature = 'djibsouq:make-admin
                            {email : Adresse e-mail du compte}
                            {password : Mot de passe (min. 8 caractères)}
                            {--name=Administrateur : Nom affiché (nouveau compte)}
                            {--force : Promouvoir / réinitialiser sans confirmation}';

    protected $description = 'Crée ou promeut un utilisateur administrateur (role=admin).';

    public function handle(): int
    {
        $email = $this->argument('email');
        $password = $this->argument('password');

        if (strlen($password) < 8) {
            $this->error('Le mot de passe doit contenir au moins 8 caractères.');

            return self::FAILURE;
        }

        $user = User::query()->firstOrNew(['email' => $email]);

        if ($user->exists && ! $this->option('force')) {
            if (! $this->confirm('Un utilisateur existe déjà avec cet e-mail. Le promouvoir admin et réinitialiser le mot de passe ?', true)) {
                return self::FAILURE;
            }
        }

        if (! $user->exists) {
            $user->name = (string) $this->option('name');
            $user->locale = 'fr';
            $user->email_verified_at = now();
        }

        $user->password = $password;
        $user->role = 'admin';
        $user->is_active = true;
        $user->inactive_reason = null;
        $user->failed_login_attempts = 0;
        $user->save();

        $this->info('Compte admin prêt : '.$email);

        return self::SUCCESS;
    }
}
