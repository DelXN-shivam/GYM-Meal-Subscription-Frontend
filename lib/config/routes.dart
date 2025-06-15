import 'package:flutter/material.dart';
import 'package:gym_app_user_1/screens/auth/login_screen.dart';
import 'package:gym_app_user_1/screens/auth/register_screen.dart';
import 'package:gym_app_user_1/screens/auth/signup_screen.dart';
import 'package:gym_app_user_1/screens/home/home_screen.dart';
import 'package:gym_app_user_1/screens/meal_plan/meal_plan_screen.dart';
import 'package:gym_app_user_1/screens/onboarding/onboarding_screen.dart';
import 'package:gym_app_user_1/screens/profile/profile_screen.dart';
import 'package:gym_app_user_1/screens/splash_screen.dart';
import 'package:gym_app_user_1/screens/subscription/subscription_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String mealPlan = '/meal-plan';
  static const String subscription = '/subscription';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    signup: (context) => SignupScreen(),
    home: (context) => const HomeScreen(),
    mealPlan: (context) => const MealPlanScreen(),
    subscription: (context) => const SubscriptionScreen(),
    profile: (context) => ProfileScreen(),
  };
}
