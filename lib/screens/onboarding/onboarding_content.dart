import 'package:flutter/material.dart';

class OnboardingContent {
  final IconData icon;
  final String title;
  final String description;

  OnboardingContent({
    required this.icon,
    required this.title,
    required this.description,
  });
}

final List<OnboardingContent> onboardingContents = [
  OnboardingContent(
    icon: Icons.fitness_center,
    title: 'Personalized Meal Plans',
    description:
        'Get customized meal plans based on your fitness goals, dietary preferences, and body metrics.',
  ),
  OnboardingContent(
    icon: Icons.calendar_today,
    title: 'Flexible Delivery Schedule',
    description:
        'Choose your preferred delivery times and locations. Pause or modify your schedule anytime.',
  ),
  OnboardingContent(
    icon: Icons.restaurant_menu,
    title: 'Nutritious & Delicious',
    description:
        'Enjoy chef-prepared meals that are both healthy and tasty, made with fresh ingredients.',
  ),
  OnboardingContent(
    icon: Icons.track_changes,
    title: 'Track Your Progress',
    description:
        'Monitor your fitness journey with detailed nutrition tracking and progress reports.',
  ),
];
