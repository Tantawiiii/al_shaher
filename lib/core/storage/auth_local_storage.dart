import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists auth token and serialized user payload from login.
class AuthLocalStorage {
  AuthLocalStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _keyToken = 'auth_token';
  static const _keyType = 'auth_type';
  static const _keyUserJson = 'auth_user_json';

  String? getToken() {
    final t = _prefs.getString(_keyToken);
    if (t == null || t.isEmpty) return null;
    return t;
  }

  String? getAuthType() => _prefs.getString(_keyType);

  Map<String, dynamic>? getUserMap() {
    final raw = _prefs.getString(_keyUserJson);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession({
    required String token,
    required String type,
    required Map<String, dynamic> user,
  }) async {
    await _prefs.setString(_keyToken, token);
    await _prefs.setString(_keyType, type);
    await _prefs.setString(_keyUserJson, jsonEncode(user));
  }

  Future<void> clear() async {
    await _prefs.remove(_keyToken);
    await _prefs.remove(_keyType);
    await _prefs.remove(_keyUserJson);
  }

  bool get hasToken => getToken() != null;
}
