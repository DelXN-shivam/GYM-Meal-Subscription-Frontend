import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _loggedInKey = 'isLoggedIn';
  static const _userIdKey = 'userId';
  static const _usernameKey = 'username';
  static const _mongoIdKey = 'mongoId';
  static const _mongoEmailKey = 'mongoEmail';
  // Add more keys for other user data you want to store

  Future<void> saveLoginData({
    required String userId,
    required String username,
    required String mongoId,
    required String mongoEmail,
    // Add more parameters for other user data
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_mongoIdKey, mongoId);
    await prefs.setString(_mongoEmailKey, mongoEmail);
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

  Future<String?> getMongoId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mongoIdKey);
  }

  Future<String?> getMongoEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mongoEmailKey);
  }

  // Add more methods to retrieve other user data

  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_mongoIdKey);
    await prefs.remove(_mongoEmailKey);
    // Remove other user data keys
  }
}
