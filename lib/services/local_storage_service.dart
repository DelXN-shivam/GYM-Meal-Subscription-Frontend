import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _loggedInKey = 'isLoggedIn';
  static const _userIdKey = 'userId';
  static const _usernameKey = 'username';
  // Add more keys for other user data you want to store

  Future<void> saveLoginData({
    required String userId,
    required String username,
    // Add more parameters for other user data
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    // Save other user data
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // Add more methods to retrieve other user data

  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    // Remove other user data keys
  }
}
