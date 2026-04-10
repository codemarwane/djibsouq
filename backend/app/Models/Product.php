<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    use SoftDeletes;

    /**
     * Liaison route API publique : uniquement les produits publiés.
     */
    public function resolveRouteBinding($value, $field = null)
    {
        return $this->where($field ?? $this->getRouteKeyName(), $value)
            ->where('is_published', true)
            ->firstOrFail();
    }

    protected $fillable = [
        'category_id',
        'title',
        'slug',
        'sku',
        'description',
        'price',
        'compare_at_price',
        'discount_percent',
        'stock_quantity',
        'track_stock',
        'rating_avg',
        'reviews_count',
        'is_best_seller',
        'is_featured',
        'is_published',
        'primary_image_path',
    ];

    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'compare_at_price' => 'decimal:2',
            'discount_percent' => 'decimal:2',
            'rating_avg' => 'decimal:2',
            'track_stock' => 'boolean',
            'is_best_seller' => 'boolean',
            'is_featured' => 'boolean',
            'is_published' => 'boolean',
        ];
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function images(): HasMany
    {
        return $this->hasMany(ProductImage::class)->orderBy('sort_order');
    }

    public function reviews(): HasMany
    {
        return $this->hasMany(Review::class);
    }

    public function promotions(): BelongsToMany
    {
        return $this->belongsToMany(Promotion::class, 'promotion_product')
            ->withTimestamps();
    }

    public function scopePublished(Builder $query): Builder
    {
        return $query->where('is_published', true);
    }

    public function scopeForCategorySlug(Builder $query, string $slug): Builder
    {
        return $query->whereHas('category', fn (Builder $q) => $q->where('slug', $slug));
    }

    public function scopeForCategoryId(Builder $query, int $id): Builder
    {
        return $query->where('category_id', $id);
    }
}
