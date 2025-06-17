import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app_user_1/config/routes.dart';

class SetPreferencesScreen extends StatefulWidget {
  @override
  _SetPreferencesScreenState createState() => _SetPreferencesScreenState();
}

class _SetPreferencesScreenState extends State<SetPreferencesScreen> {
  // Goals - Single selection
  String? selectedGoal;
  final List<String> goals = ['Lose weight', 'Maintain', 'Muscle gain'];

  // Activity level
  String selectedActivityLevel = 'Select activity level';
  bool isActivityDropdownExpanded = false;
  final List<String> activityLevels = ['Sedentary', 'Moderate', 'Active'];

  // Dietary preferences - Single selection
  String? selectedDiet;
  final List<String> dietaryOptions = ['Veg', 'Non-veg', 'Vegan'];

  // Allergies - Multiple selection
  Set<String> selectedAllergies = {}; // Pre-selected as shown in image
  final List<String> allergyOptions = [
    'Nuts',
    'Gluten',
    'Dairy',
    'Eggs',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF2D3748),
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/logo.svg',
                        height: 60,
                      ),
                    ),
                  ),
                  // Empty SizedBox to balance the back button
                  SizedBox(width: 24),
                ],
              ),
              SizedBox(height: 20),

              // Title
              Text(
                'Set preferences',
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 32),

              // Your goals
              _buildSectionTitle('Your goals'),
              SizedBox(height: 12),
              _buildGoalsSection(),
              SizedBox(height: 32),

              // Activity level
              _buildSectionTitle('Activity level'),
              SizedBox(height: 12),
              _buildActivityLevelSection(),
              SizedBox(height: 32),

              // Dietary preferences
              _buildSectionTitle('Dietary preferences'),
              SizedBox(height: 12),
              _buildDietarySection(),
              SizedBox(height: 32),

              // Allergies
              _buildSectionTitle('Allergies'),
              SizedBox(height: 12),
              _buildAllergiesSection(),
              SizedBox(height: 48),

              // Generate meal plan button
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleGenerateMealPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4ECDC4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Generate your meal plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Color(0xFF2D3748),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: goals.map((goal) {
          final isSelected = selectedGoal == goal;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedGoal = goal;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF2D8A7A) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected ? Colors.white : Color(0xFF2D3748),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    goal,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityLevelSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isActivityDropdownExpanded = !isActivityDropdownExpanded;
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFBDE5DF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedActivityLevel,
                    style: TextStyle(
                      color: selectedActivityLevel == 'Select activity level'
                          ? Color(0xFF9CA3AF)
                          : Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  isActivityDropdownExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Color(0xFF2D3748),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (isActivityDropdownExpanded) ...[
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF4ECDC4), width: 2),
            ),
            child: Column(
              children: activityLevels.map((level) {
                final isLast = level == activityLevels.last;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedActivityLevel = level;
                      isActivityDropdownExpanded = false;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: !isLast
                          ? Border(
                              bottom: BorderSide(
                                color: Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            )
                          : null,
                    ),
                    child: Text(
                      level,
                      style: TextStyle(
                        color: Color(0xFF2D3748),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDietarySection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: dietaryOptions.map((diet) {
          final isSelected = selectedDiet == diet;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDiet = diet;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF2D8A7A) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected ? Colors.white : Color(0xFF2D3748),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    diet,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAllergiesSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: allergyOptions.map((allergy) {
          final isSelected = selectedAllergies.contains(allergy);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedAllergies.remove(allergy);
                } else {
                  selectedAllergies.add(allergy);
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF2D8A7A) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected ? Colors.white : Color(0xFF2D3748),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    allergy,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleGenerateMealPlan() {
    // Validate selections
    if (selectedGoal == null) {
      _showSnackBar('Please select your goal');
      return;
    }

    if (selectedActivityLevel == 'Select activity level') {
      _showSnackBar('Please select your activity level');
      return;
    }

    if (selectedDiet == null) {
      _showSnackBar('Please select your dietary preference');
      return;
    }

    // Show success and print preferences
    _showSnackBar('Generating your personalized meal plan!');

    log('=== MEAL PLAN PREFERENCES ===');
    log('Goal: $selectedGoal');
    log('Activity Level: $selectedActivityLevel');
    log('Dietary Preference: $selectedDiet');
    log('Allergies: ${selectedAllergies.toList()}');
    log('=============================');

    Navigator.pushNamed(context, AppRoutes.sampleMeal);

    // Here you would typically:
    // 1. Send preferences to backend
    // 2. Generate meal plan
    // 3. Navigate to meal plan screen
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF4ECDC4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
