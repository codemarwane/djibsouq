<?php

return [

    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'],

    /*
    | Séparez les origines par des virgules (ex. https://app.example.com,http://localhost:8080).
    | Pour le développement, la valeur par défaut autorise toutes les origines (sans credentials).
    */
    'allowed_origins' => (function () {
        $raw = env('CORS_ALLOWED_ORIGINS', '*');
        if ($raw === null || $raw === '' || $raw === '*') {
            return ['*'];
        }

        return array_values(array_filter(array_map('trim', explode(',', (string) $raw))));
    })(),

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    /*
    | Mettre à true uniquement si vous utilisez cookies Sanctum SPA avec des origines explicites.
    */
    'supports_credentials' => (bool) env('CORS_SUPPORTS_CREDENTIALS', false),

];
