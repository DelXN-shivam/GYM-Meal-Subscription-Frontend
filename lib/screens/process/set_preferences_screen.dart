import 'dart:developer';
import 'dart:convert';
import 'package:gym_app_user_1/screens/process/sample_meal_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';

class SetPreferencesScreen extends StatefulWidget {
  final String mongoId;
  const SetPreferencesScreen({Key? key, required this.mongoId})
    : super(key: key);

  @override
  _SetPreferencesScreenState createState() => _SetPreferencesScreenState();
}

class _SetPreferencesScreenState extends State<SetPreferencesScreen> {
  // final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Goals - Single selection
  String? selectedGoal;
  final List<String> goals = ['lose-weight', 'maintain', 'muscle-gain'];

  // Activity level
  String selectedActivityLevel = 'Select activity level';
  bool isActivityDropdownExpanded = false;
  final List<String> activityLevels = ['sedentary', 'moderate', 'active'];

  // Dietary preferences - Multiple selection
  Set<String> selectedDiet = {}; // Changed from String? to Set<String>
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

  String getGoalDisplay(String goal) {
    switch (goal) {
      case 'lose-weight':
        return 'Lose Weight';
      case 'muscle-gain':
        return 'Muscle Gain';
      case 'maintain':
        return 'Maintain';
      default:
        return goal;
    }
  }

  String getActivityDisplay(String activity) {
    switch (activity) {
      case 'sedentary':
        return 'Sedentary';
      case 'moderate':
        return 'Moderate';
      case 'active':
        return 'Active';
      default:
        return activity;
    }
  }

  void _handleGenerateMealPlan() async {
    // if (!(_formKey.currentState?.validate() ?? false)) return;
    // Validate selections
    if (selectedGoal == null) {
      _showSnackBar('Please select your goal');
      return;
    }

    if (selectedActivityLevel == 'Select activity level') {
      _showSnackBar('Please select your activity level');
      return;
    }

    if (selectedDiet.isEmpty) {
      _showSnackBar('Please select your dietary preference(s)');
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      log('Starting backend data storing...');
      if (widget.mongoId.isEmpty) {
        throw Exception('User ID not found. Please try again.');
      }
      final backendResponse = await http.put(
        Uri.parse(
          'https://gym-meal-subscription-backend.vercel.app/api/v1/user/update/${widget.mongoId}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "fitnessGoal": selectedGoal,
          "activityLevel": selectedActivityLevel,
          "dietPreference": selectedDiet.toList(),
          "allergy": selectedAllergies.toList(),
        }),
      );
      // log('Update response status: ${backendResponse.statusCode}');
      // log('Update response body: ${backendResponse.body}');
      if (backendResponse.statusCode == 200 ||
          backendResponse.statusCode == 201) {
        final responseData = json.decode(backendResponse.body);
        // log("Decoded Data: $responseData");
        // log('Update successful, storing user data...');
        // log(backendResponse.body);
        _showSnackBar('Data updated successfully! ✅');

        // Get the profile data provider
        final profileProvider = Provider.of<ProfileDataProvider>(
          context,
          listen: false,
        );

        // Store meal preferences data in the provider
        profileProvider.updateMealPreferences(
          goal: selectedGoal,
          activityLevel: selectedActivityLevel,
          dietaryPreference: selectedDiet.toList(), // Now a list
          allergies: selectedAllergies.toList(),
        );
        profileProvider.setPreferencesCompleted(true);

        // Log all profile data before navigation
        profileProvider.logAllProfileData(pageName: 'Set Preferences Screen');

        // Show success and print preferences
        _showSnackBar('Generating your personalized meal plan!');

        log('=== MEAL PLAN PREFERENCES ===');
        log('Goal: $selectedGoal');
        log('Activity Level: $selectedActivityLevel');
        log('Dietary Preference: ${selectedDiet.toList()}');
        log('Allergies: ${selectedAllergies.toList()}');
        log('=============================');

        // Navigator.pushNamed(context, AppRoutes.setPreferences);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SampleMealScreen(mongoId: widget.mongoId),
          ),
        );
      } else {
        throw Exception('Failed to update data. Please try again.');
      }
    } catch (e) {
      log("An unexpected error occurred: $e");
      _showSnackBar('Error: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF2D5BFF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    log("&&&&&&&  ${widget.mongoId}  &&&&&&&");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
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
                      color: Colors.white,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/svg/newLogo.svg',
                        height: 40,
                      ),
                    ),
                  ),
                  // Empty SizedBox to balance the back button
                  SizedBox(width: 24),
                ],
              ),
              SizedBox(height: 40),

              // Title
              Text(
                'Set Preferences',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Customize your meal plan preferences',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 40),

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
                  onPressed: _isLoading ? null : _handleGenerateMealPlan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D5BFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    shadowColor: Color(0xFF2D5BFF).withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
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
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
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
                color: isSelected ? Color(0xFF2D5BFF) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Color(0xFF2D5BFF) : Colors.grey[800]!,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected ? Colors.white : Colors.grey[400],
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    getGoalDisplay(goal),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white,
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
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getActivityDisplay(selectedActivityLevel),
                    style: TextStyle(
                      color: selectedActivityLevel == 'Select activity level'
                          ? Colors.grey[400]
                          : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  isActivityDropdownExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
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
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF2D5BFF), width: 2),
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
                                color: Colors.grey[800]!,
                                width: 1,
                              ),
                            )
                          : null,
                    ),
                    child: Text(
                      getActivityDisplay(level),
                      style: TextStyle(
                        color: Colors.white,
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
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: dietaryOptions.map((diet) {
          final isSelected = selectedDiet.contains(diet.toLowerCase());
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedDiet.remove(diet.toLowerCase());
                } else {
                  selectedDiet.add(diet.toLowerCase());
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF2D5BFF) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Color(0xFF2D5BFF) : Colors.grey[800]!,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected ? Colors.white : Colors.grey[400],
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    diet,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white,
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
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: allergyOptions.map((allergy) {
          final isSelected = selectedAllergies.contains(allergy.toLowerCase());
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedAllergies.remove(allergy.toLowerCase());
                } else {
                  selectedAllergies.add(allergy.toLowerCase());
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF2D5BFF) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Color(0xFF2D5BFF) : Colors.grey[800]!,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected ? Colors.white : Colors.grey[400],
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    allergy,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white,
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
}
