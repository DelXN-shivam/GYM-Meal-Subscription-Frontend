import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app_user_1/config/routes.dart';

class SampleMealScreen extends StatefulWidget {
  @override
  _SampleMealScreenState createState() => _SampleMealScreenState();
}

class _SampleMealScreenState extends State<SampleMealScreen> {
  // User profile data
  int age = 25;
  String gender = 'Male';
  double height = 175.0; // cm
  double weight = 75.0; // kg
  String activity = 'Moderate';
  String goal = 'Gain muscle';

  // Nutrition data
  int calories = 2700;
  int carbsPercent = 40;
  int proteinPercent = 30;
  int fatsPercent = 30;

  // Calculate BMI
  double get bmi => weight / ((height / 100) * (height / 100));

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
              // Header with logo
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
                  SizedBox(width: 24),
                ],
              ),
              SizedBox(height: 20),

              // Title
              Text(
                'Your Meal Plan',
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 32),

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
                    Navigator.pushNamed(context, AppRoutes.subscriptionDetails);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4ECDC4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
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
        color: Color(0xFF2D3748),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Your personalized meal plan based on your preferences',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2D3748),
        ),
      ),
    );
  }

  Widget _buildBMICard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Your BMI',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 10),
          Text(
            bmi.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "That's a great start to begin with",
            style: TextStyle(fontSize: 16, color: Color(0xFF4A5568)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildProfileItem('📈', 'Age', '$age'),
          SizedBox(height: 12),
          _buildProfileItem('⚧', 'Gender', gender),
          SizedBox(height: 12),
          _buildProfileItem('📏', 'Height', '${height.toInt()} cm'),
          SizedBox(height: 12),
          _buildProfileItem('⚖️', 'Weight', '${weight.toInt()} kg'),
          SizedBox(height: 12),
          _buildProfileItem('🏃', 'Activity', activity),
          SizedBox(height: 12),
          _buildProfileItem('🎯', 'Goal', goal),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              color: Color(0xFF2D3748),
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
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Daily Calories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A5568),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '$calories kcal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5568),
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
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
            color: Color(0xFF4ECDC4),
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
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                calories,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A5568),
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
            backgroundColor: Color(0xFF4ECDC4),
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
          color: Color(0xFFBDE5DF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
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
                color: Color(0xFF2D3748),
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
