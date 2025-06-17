import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app_user_1/services/local_storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _firebaseUser;
  Map<String, dynamic>? _backendUserData;
  final LocalStorageService _localStorageService = LocalStorageService();
  bool _isLoading = false;

  AuthProvider() {
    initializeUser();
  }

  // Getters
  User? get firebaseUser => _firebaseUser;
  Map<String, dynamic>? get backendUserData => _backendUserData;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _firebaseUser != null && _backendUserData != null;

  // Initialize user data when app starts
  Future<void> initializeUser() async {
    setLoading(true);
    try {
      // Get current Firebase user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        _firebaseUser = currentUser;

        final userData = await _getUserDataFromBackend(currentUser.uid);
        _backendUserData = userData;

        notifyListeners();
      }
    } catch (e) {
      print('Error initializing user: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<Map<String, dynamic>> _getUserDataFromBackend(String userId) async {
    return {
      'name': await _localStorageService.getUsername() ?? 'N/A',
      'userId': userId,
      'mongoId': await _localStorageService.getMongoId() ?? 'N/A',
      'mongoEmail': await _localStorageService.getMongoEmail() ?? 'N/A',
      // Add other user data fields
    };
  }

  // Set loading state
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set user data after successful login
  Future<void> setUserData({
    required User firebaseUser,
    required Map<String, dynamic> backendUserData,
  }) async {
    _firebaseUser = firebaseUser;
    _backendUserData = backendUserData;

    // Log the backend user data for debugging
    log("Backend User Data: $backendUserData");

    // Save login data to local storage
    await _localStorageService.saveLoginData(
      userId: firebaseUser.uid,
      username: backendUserData['name'] ?? '',
      mongoId: backendUserData['id'] ?? '',
      mongoEmail: backendUserData['email'] ?? '',
    );

    // Log the saved data for verification
    log("Saved Mongo ID: ${await _localStorageService.getMongoId()}");
    log("Saved Mongo Email: ${await _localStorageService.getMongoEmail()}");

    notifyListeners();
  }

  // Clear user data on logout
  Future<void> logout() async {
    _firebaseUser = null;
    _backendUserData = null;
    await _localStorageService.clearLoginData();
    notifyListeners();
  }

  // Check if user is logged in
  Future<bool> checkLoginStatus() async {
    return await _localStorageService.isLoggedIn();
  }
}
