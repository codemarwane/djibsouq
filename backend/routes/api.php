<?php

use App\Http\Controllers\Api\AddressController;
use App\Http\Controllers\Api\Admin\CategoryManagementController;
use App\Http\Controllers\Api\Admin\ProductManagementController;
use App\Http\Controllers\Api\Admin\UserManagementController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ContactController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\PasswordController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\PromotionController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\UserNotificationController;
use App\Http\Controllers\Api\WishlistController;
use Illuminate\Support\Facades\Route;

Route::get('categories', [CategoryController::class, 'index']);

Route::get('promotions', [PromotionController::class, 'index']);
Route::get('promotions/{promotion}', [PromotionController::class, 'show']);

Route::get('products', [ProductController::class, 'index']);
Route::get('products/{product}/reviews', [ReviewController::class, 'index']);
Route::get('products/{product}', [ProductController::class, 'show']);

Route::middleware('throttle:10,1')->group(function () {
    Route::post('auth/register', [AuthController::class, 'register']);
    Route::post('auth/login', [AuthController::class, 'login']);
});

Route::middleware('throttle:5,1')->group(function () {
    Route::post('password/forgot', [PasswordController::class, 'forgot']);
    Route::post('password/reset', [PasswordController::class, 'reset']);
});

Route::post('contact', [ContactController::class, 'store']);

Route::get('cart', [CartController::class, 'show']);
Route::post('cart/items', [CartController::class, 'addItem']);
Route::patch('cart/items/{cartItem}', [CartController::class, 'updateItem']);
Route::delete('cart/items/{cartItem}', [CartController::class, 'removeItem']);
Route::delete('cart', [CartController::class, 'clear']);

Route::middleware(['auth:sanctum', 'active'])->group(function () {
    Route::post('auth/logout', [AuthController::class, 'logout']);

    Route::get('user', [ProfileController::class, 'show']);
    Route::put('user', [ProfileController::class, 'update']);
    Route::put('user/password', [ProfileController::class, 'updatePassword']);

    Route::get('wishlist', [WishlistController::class, 'index']);
    Route::post('wishlist', [WishlistController::class, 'store']);
    Route::delete('wishlist/{productId}', [WishlistController::class, 'destroy'])->whereNumber('productId');

    Route::apiResource('addresses', AddressController::class);
    Route::post('addresses/{address}/default', [AddressController::class, 'setDefault']);

    Route::get('orders', [OrderController::class, 'index']);
    Route::post('orders', [OrderController::class, 'store']);
    Route::get('orders/{order}', [OrderController::class, 'show']);

    Route::get('notifications', [UserNotificationController::class, 'index']);
    Route::post('notifications/read-all', [UserNotificationController::class, 'markAllRead']);
    Route::post('notifications/{notification}/read', [UserNotificationController::class, 'markRead']);

    Route::post('products/{product}/reviews', [ReviewController::class, 'store']);
});

Route::middleware(['auth:sanctum', 'active', 'admin'])->prefix('admin')->group(function () {
    Route::apiResource('users', UserManagementController::class)->except(['create', 'edit']);

    Route::apiResource('categories', CategoryManagementController::class);
    Route::apiResource('products', ProductManagementController::class)
        ->parameters(['product' => 'adminProduct']);
});
