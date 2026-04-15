<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\AddressResource;
use App\Models\Address;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class AddressController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $addresses = $request->user()
            ->addresses()
            ->orderByDesc('is_default')
            ->orderByDesc('id')
            ->get();

        return AddressResource::collection($addresses);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $this->validatedAddress($request);

        if ($validated['is_default'] ?? false) {
            $request->user()->addresses()->update(['is_default' => false]);
        }

        $address = $request->user()->addresses()->create($validated);

        return response()->json(['data' => new AddressResource($address)], 201);
    }

    public function show(Request $request, Address $address): AddressResource
    {
        $this->authorizeAddress($request, $address);

        return new AddressResource($address);
    }

    public function update(Request $request, Address $address): AddressResource
    {
        $this->authorizeAddress($request, $address);

        $validated = $this->validatedAddress($request, partial: true);

        if (($validated['is_default'] ?? false) === true) {
            $request->user()->addresses()->where('id', '!=', $address->id)->update(['is_default' => false]);
        }

        $address->update($validated);

        return new AddressResource($address->fresh());
    }

    public function destroy(Request $request, Address $address): JsonResponse
    {
        $this->authorizeAddress($request, $address);
        $address->delete();

        return response()->json(['message' => 'Adresse supprimée.']);
    }

    public function setDefault(Request $request, Address $address): AddressResource
    {
        $this->authorizeAddress($request, $address);

        $request->user()->addresses()->update(['is_default' => false]);
        $address->update(['is_default' => true]);

        return new AddressResource($address->fresh());
    }

    private function authorizeAddress(Request $request, Address $address): void
    {
        if ((int) $address->user_id !== (int) $request->user()->id) {
            abort(403);
        }
    }

    /**
     * @return array<string, mixed>
     */
    private function validatedAddress(Request $request, bool $partial = false): array
    {
        $rules = [
            'label' => ($partial ? 'sometimes' : 'nullable').'|string|max:100',
            'full_name' => ($partial ? 'sometimes' : 'required').'|string|max:255',
            'phone' => ($partial ? 'sometimes' : 'required').'|string|max:32',
            'line1' => ($partial ? 'sometimes' : 'required').'|string|max:255',
            'line2' => 'nullable|string|max:255',
            'city' => ($partial ? 'sometimes' : 'required').'|string|max:120',
            'region' => 'nullable|string|max:120',
            'postal_code' => 'nullable|string|max:32',
            'country_code' => ($partial ? 'sometimes' : 'required').'|string|size:2',
            'is_default' => 'sometimes|boolean',
        ];

        return $request->validate($rules);
    }
}
