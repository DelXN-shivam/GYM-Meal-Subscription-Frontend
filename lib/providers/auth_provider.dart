import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  Map<String, dynamic>? get userData => _userData;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      fetchAndSetUserData(user);
      notifyListeners();
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required int age,
    required String gender,
    required double height,
    required double weight,
    required String fitnessGoal,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.email).set({
        'name': name,
        'email': email,
        'age': age,
        'gender': gender,
        'height': height,
        'weight': weight,
        'fitnessGoal': fitnessGoal,
        'dietaryPreferences': dietaryPreferences,
        'allergies': allergies,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      await fetchAndSetUserData(_auth.currentUser);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchAndSetUserData(User? user) async {
    if (user == null || user.email == null) {
      _userData = null;
      notifyListeners();
      return;
    }
    try {
      final doc = await _firestore.collection('users').doc(user.email).get();
      if (doc.exists) {
        _userData = doc.data();
      } else {
        _userData = null;
        print('User document not found for email: ${user.email}');
      }
      notifyListeners();
    } catch (e) {
      _userData = null;
      print('Error fetching user data: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userData = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
