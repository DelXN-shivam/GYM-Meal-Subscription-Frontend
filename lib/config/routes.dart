import 'package:flutter/material.dart';
import 'package:gym_app_user_1/screens/auth/login_screen.dart';
import 'package:gym_app_user_1/screens/home/next_screen.dart';
import 'package:gym_app_user_1/screens/process/sample_meal_screen.dart';
import 'package:gym_app_user_1/screens/process/set_preferences_screen.dart';
import 'package:gym_app_user_1/screens/auth/signup_screen.dart';
import 'package:gym_app_user_1/screens/onboarding/onboarding_screen.dart';
import 'package:gym_app_user_1/screens/process/change_location_screen.dart';
import 'package:gym_app_user_1/screens/process/subscription_details.dart';
import 'package:gym_app_user_1/screens/process/subscription_plans_screen.dart';
import 'package:gym_app_user_1/screens/profile/profile_screen.dart';
import 'package:gym_app_user_1/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String setPreferences = '/set-preferences';
  static const String sampleMeal = '/sample-meal';
  static const String subscriptionDetails = '/subscription-details';
  static const String changeLocation = '/change-location';
  static const String subscriptionPlans = '/subscription-plans';
  static const String mealPlan = '/meal-plan';
  static const String profile = '/profile';
  static const String next = '/next';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => SignupScreen(),
    setPreferences: (context) => SetPreferencesScreen(),
    sampleMeal: (context) => SampleMealScreen(),
    subscriptionDetails: (context) => SubscriptionDetailsScreen(),
    changeLocation: (context) => ChangeLocationScreen(),
    subscriptionPlans: (context) => SubscriptionPlansPage(),
    profile: (context) => ProfileScreen(),
    next: (context) => const NextPage(),
  };
}
