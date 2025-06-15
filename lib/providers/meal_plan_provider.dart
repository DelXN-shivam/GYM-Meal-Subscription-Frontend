import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart'; // Import flutter/widgets.dart

class MealPlanProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  Map<String, dynamic>? _currentMealPlan;
  Map<String, dynamic>? _userMetrics;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get currentMealPlan => _currentMealPlan;
  Map<String, dynamic>? get userMetrics => _userMetrics;

  // Calculate BMR using Mifflin-St Jeor equation
  double calculateBMR({
    required double weight,
    required double height,
    required int age,
    required String gender,
  }) {
    double bmr = (10 * weight) + (6.25 * height) - (5 * age);
    return gender.toLowerCase() == 'male' ? bmr + 5 : bmr - 161;
  }

  // Calculate daily calorie needs based on activity level and goal
  double calculateDailyCalories({
    required double bmr,
    required String activityLevel,
    required String fitnessGoal,
  }) {
    double activityMultiplier = 1.2; // Sedentary
    switch (activityLevel.toLowerCase()) {
      case 'lightly active':
        activityMultiplier = 1.375;
        break;
      case 'moderately active':
        activityMultiplier = 1.55;
        break;
      case 'very active':
        activityMultiplier = 1.725;
        break;
      case 'extra active':
        activityMultiplier = 1.9;
        break;
    }

    double goalMultiplier = 1.0; // Maintain
    switch (fitnessGoal.toLowerCase()) {
      case 'lose weight':
        goalMultiplier = 0.85;
        break;
      case 'gain muscle':
        goalMultiplier = 1.15;
        break;
    }

    return bmr * activityMultiplier * goalMultiplier;
  }

  // Calculate macronutrient breakdown
  Map<String, double> calculateMacros({
    required double calories,
    required String fitnessGoal,
  }) {
    double protein, carbs, fat;

    switch (fitnessGoal.toLowerCase()) {
      case 'lose weight':
        protein = 0.4; // 40% protein
        carbs = 0.3; // 30% carbs
        fat = 0.3; // 30% fat
        break;
      case 'gain muscle':
        protein = 0.35; // 35% protein
        carbs = 0.45; // 45% carbs
        fat = 0.2; // 20% fat
        break;
      default: // maintain
        protein = 0.3; // 30% protein
        carbs = 0.4; // 40% carbs
        fat = 0.3; // 30% fat
    }

    return {
      'protein': (calories * protein) / 4, // 4 calories per gram of protein
      'carbs': (calories * carbs) / 4, // 4 calories per gram of carbs
      'fat': (calories * fat) / 9, // 9 calories per gram of fat
    };
  }

  Future<void> generateMealPlan({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      _isLoading = true;
      // Schedule notifyListeners for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final bmr = calculateBMR(
        weight: userData['weight'],
        height: userData['height'],
        age: userData['age'],
        gender: userData['gender'],
      );

      final dailyCalories = calculateDailyCalories(
        bmr: bmr,
        activityLevel: userData['activityLevel'],
        fitnessGoal: userData['fitnessGoal'],
      );

      final macros = calculateMacros(
        calories: dailyCalories,
        fitnessGoal: userData['fitnessGoal'],
      );

      // Store the meal plan in Firestore
      await _firestore.collection('meal_plans').doc(userId).set({
        'bmr': bmr,
        'dailyCalories': dailyCalories,
        'macros': macros,
        'userData': userData,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _currentMealPlan = {
        'bmr': bmr,
        'dailyCalories': dailyCalories,
        'macros': macros,
      };
      _userMetrics = userData;

      _isLoading = false;
      // Schedule notifyListeners for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      // Schedule notifyListeners for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      rethrow;
    }
  }

  Future<void> loadUserMealPlan(String userId) async {
    try {
      _isLoading = true;
      // Schedule notifyListeners for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      final doc = await _firestore.collection('meal_plans').doc(userId).get();
      if (doc.exists) {
        _currentMealPlan = doc.data();
        _userMetrics = doc.data()?['userData'];
      }

      _isLoading = false;
      // Schedule notifyListeners for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      // Schedule notifyListeners for the next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      rethrow;
    }
  }
}
