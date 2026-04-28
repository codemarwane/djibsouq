
/// Stocke le jeton invité renvoyé par le backend pour fusionner panier / wishlist sans compte.
library;

import 'package:shared_preferences/shared_preferences.dart';

class GuestTokenStore {
  static const _guestTokenKey = 'guest_token';

  static final GuestTokenStore instance = GuestTokenStore._();
  GuestTokenStore._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  String? get guestToken => _prefs?.getString(_guestTokenKey);

  Future<void> saveGuestToken(String? value) async {
    await init();
    if (value == null || value.isEmpty) {
      await _prefs!.remove(_guestTokenKey);
      return;
    }
    await _prefs!.setString(_guestTokenKey, value);
  }
}
