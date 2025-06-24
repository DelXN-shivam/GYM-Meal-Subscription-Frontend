import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:gym_app_user_1/screens/process/subscription_details.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';

class SampleMealScreen extends StatefulWidget {
  final String mongoId;
  const SampleMealScreen({Key? key, required this.mongoId}) : super(key: key);

  @override
  _SampleMealScreenState createState() => _SampleMealScreenState();
}

class _SampleMealScreenState extends State<SampleMealScreen> {
  // User profile data
  int? age;
  String? gender;
  double? height; // cm
  double? weight; // kg
  String? activity;
  String? goal;

  // Nutrition data from backend
  int calories = 0;
  int carbsPercent = 0;
  int proteinPercent = 0;
  int fatsPercent = 0;
  double bmiValue = 0;
  int bmr = 0;
  int tdee = 0;

  // Calculate BMI
  double get bmi => bmiValue;

  // Meal data
  List<Map<String, dynamic>> breakfastItems = [
    {'name': 'Oats', 'image': '🥣'},
    {'name': 'Eggs', 'image': '🥚'},
    {'name': 'Fruit', 'image': '🍎'},
  ];

  List<Map<String, dynamic>> lunchItems = [
    {'name': 'Grilled\nChicken', 'image': '🍗'},
    {'name': 'Rice', 'image': '🍚'},
    {'name': 'Veggies', 'image': '🥗'},
  ];

  List<Map<String, dynamic>> dinnerItems = [
    {'name': 'Quinoa', 'image': '🌾'},
    {'name': 'Tofu', 'image': '🧈'},
    {'name': 'Salad', 'image': '🥗'},
  ];

  Future<void> fetchCaloriesData() async {
    try {
      log('Starting backend data storing...');
      if (widget.mongoId.isEmpty) {
        throw Exception('User ID not found. Please try again.');
      }
      final profileProvider = Provider.of<ProfileDataProvider>(
        context,
        listen: false,
      );

      // Update local state with profile data
      setState(() {
        age = profileProvider.age;
        gender = profileProvider.gender;
        height = profileProvider.height;
        weight = profileProvider.weight;
        activity = profileProvider.activityLevel;
        goal = profileProvider.goal;
      });

      final backendResponse = await http.post(
        Uri.parse(
          'https://gym-meal-subscription-backend.vercel.app/api/v1/user/calculate-calories',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "gender": profileProvider.gender?.toLowerCase(),
          "weight": profileProvider.weight,
          "height": profileProvider.height,
          "age": profileProvider.age,
          "activityLevel": profileProvider.activityLevel?.toLowerCase(),
          "goal": profileProvider.goal?.toLowerCase(),
        }),
      );
      log('Update response status: ${backendResponse.statusCode}');
      log('Update response body: ${backendResponse.body}');
      if (backendResponse.statusCode == 200 ||
          backendResponse.statusCode == 201) {
        final responseData = json.decode(backendResponse.body);
        log("Decoded Data: $responseData");

        // Update state with response data
        setState(() {
          calories = responseData['recommendedCalories'] ?? 0;
          bmiValue = double.parse(responseData['bmi'] ?? "0");
          bmr = responseData['bmr'] ?? 0;
          tdee = responseData['tdee'] ?? 0;

          // Update macronutrients
          if (responseData['macronutients'] != null) {
            proteinPercent = responseData['macronutients']['protein'] ?? 0;
            carbsPercent = responseData['macronutients']['carbs'] ?? 0;
            fatsPercent = responseData['macronutients']['fats'] ?? 0;
          }
        });

        log('Update successful, storing user data...');
      } else {
        throw Exception('Failed to update data. Please try again.');
      }
    } catch (e) {
      log("An unexpected error occurred: $e");
      log('Error: ${e.toString().replaceAll('Exception: ', '')}');
    }

    // Get the profile data provider
    final profileProvider = Provider.of<ProfileDataProvider>(
      context,
      listen: false,
    );

    // Log all profile data before navigation
    profileProvider.logAllProfileData(pageName: 'Sample Meal Screen');
    profileProvider.setSampleMealCompleted(true);
  }

  @override
  void initState() {
    fetchCaloriesData();
    super.initState();
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
              // Header with logo
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
                  SizedBox(width: 24),
                ],
              ),
              SizedBox(height: 40),

              // Title
              Text(
                'Your Meal Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Personalized nutrition for your goals',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 40),

              // // Stats Section
              // _buildSectionTitle('Your stats'),
              // SizedBox(height: 12),
              // _buildStatsSection(),
              // SizedBox(height: 32),

              // BMI Card
              _buildSectionTitle('BMI Analysis'),
              SizedBox(height: 12),
              _buildBMICard(),
              SizedBox(height: 32),

              // Profile Summary
              _buildSectionTitle('Profile Summary'),
              SizedBox(height: 12),
              _buildProfileSummary(),
              SizedBox(height: 32),

              // Nutrition Plan
              _buildSectionTitle('Nutrition Plan'),
              SizedBox(height: 12),
              _buildNutritionPlan(),
              SizedBox(height: 32),

              // Meal Plan
              _buildSectionTitle('Sample Day Meal Plan'),
              SizedBox(height: 12),
              _buildMealPlan(),
              SizedBox(height: 32),

              // Select Plan Button
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  // onPressed: _showPlanSelectedDialog,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SubscriptionDetailsScreen(mongoId: widget.mongoId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D5BFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    shadowColor: Color(0xFF2D5BFF).withOpacity(0.3),
                  ),
                  child: Text(
                    'Select plan Details',
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

  Widget _buildStatsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Text(
        'Your personalized meal plan based on your preferences',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBMICard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Text(
            'Your BMI',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5BFF),
            ),
          ),
          SizedBox(height: 10),
          Text(
            _getBMIMessage(bmi),
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  String _getBMIMessage(double bmi) {
    if (bmi < 18.5) return "You're underweight";
    if (bmi < 24.9) return "You're in a healthy weight range";
    if (bmi < 29.9) return "You're overweight";
    return "You're in the obese range";
  }

  Widget _buildProfileSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          _buildProfileItem('📈', 'Age', '${age ?? ''}'),
          SizedBox(height: 12),
          _buildProfileItem('⚧', 'Gender', gender ?? ''),
          SizedBox(height: 12),
          _buildProfileItem('📏', 'Height', '${height?.toInt() ?? 0} cm'),
          SizedBox(height: 12),
          _buildProfileItem('⚖️', 'Weight', '${weight?.toInt() ?? 0} kg'),
          SizedBox(height: 12),
          _buildProfileItem('🏃', 'Activity', activity ?? ''),
          SizedBox(height: 12),
          _buildProfileItem('🎯', 'Goal', goal ?? ''),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 16)),
          SizedBox(width: 12),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionPlan() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Column(
              children: [
                Text(
                  'Daily Calories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '$calories kcal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5BFF),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BMR: $bmr kcal  •  ',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                    Text(
                      'TDEE: $tdee kcal',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMacroItem('Carbs', '$carbsPercent%')),
              SizedBox(width: 12),
              Expanded(child: _buildMacroItem('Protein', '$proteinPercent%')),
              SizedBox(width: 12),
              Expanded(child: _buildMacroItem('Fats', '$fatsPercent%')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlan() {
    return Column(
      children: [
        _buildMealSection('Breakfast', '600 kcal', breakfastItems),
        SizedBox(height: 20),
        _buildMealSection('Lunch', '900 kcal', lunchItems),
        SizedBox(height: 20),
        _buildMealSection('Dinner', '700 kcal', dinnerItems),
      ],
    );
  }

  Widget _buildMealSection(
    String mealName,
    String calories,
    List<Map<String, dynamic>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF2D5BFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                calories,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: items
              .map(
                (item) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: items.indexOf(item) < items.length - 1 ? 12 : 0,
                    ),
                    child: _buildMealItem(item['name'], item['image']),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMealItem(String name, String emoji) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: $name'),
            backgroundColor: Color(0xFF2D5BFF),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF0A0A0A),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[800]!),
              ),
              child: Center(child: Text(emoji, style: TextStyle(fontSize: 24))),
            ),
            SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void _showPlanSelectedDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         title: Text(
  //           'Plan Selected!',
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xFF2D8A7A),
  //           ),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'Your personalized meal plan has been selected.',
  //               style: TextStyle(color: Color(0xFF4A5568)),
  //             ),
  //             SizedBox(height: 16),
  //             _buildDialogItem('BMI', '${bmi.toStringAsFixed(1)}'),
  //             _buildDialogItem('Daily Calories', '$calories kcal'),
  //             _buildDialogItem('Goal', goal),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text(
  //               'Got it!',
  //               style: TextStyle(
  //                 color: Color(0xFF2D8A7A),
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildDialogItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '• $label: ',
            style: TextStyle(
              color: Color(0xFF4A5568),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF2D3748),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
