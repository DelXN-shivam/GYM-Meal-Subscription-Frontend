import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';

class SubscriptionPlansPage extends StatefulWidget {
  final String mongoId;
  const SubscriptionPlansPage({super.key, required this.mongoId});

  @override
  _SubscriptionPlansPageState createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  int? selectedPlan; // 0 for weekly, 1 for monthly

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
                'Get Subscription',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Choose your plan',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 40),

              // Weekly Plan
              _buildSectionTitle('Weekly Plan'),
              SizedBox(height: 12),
              _buildWeeklyPlan(),
              SizedBox(height: 32),

              // Monthly Plan
              _buildSectionTitle('Monthly Plan'),
              SizedBox(height: 12),
              _buildMonthlyPlan(),
              SizedBox(height: 48),
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

  Widget _buildWeeklyPlan() {
    final isSelected = selectedPlan == 0;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF2D5BFF) : Colors.transparent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 30,
                  color: isSelected ? Colors.white : Colors.grey[400],
                ),
                SizedBox(height: 10),
                Text(
                  'Weekly plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '₹ 1,999',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Muscle Gain',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF0A0A0A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Column(
              children: [
                _buildPlanDetail('Duration : 7 days/ week'),
                _buildPlanDetail('Daily calorie target : 1800kcal'),
                _buildPlanDetail('Meals per day : 2/ Lunch & Dinner'),
                SizedBox(height: 10),
                Text(
                  'Nutrients',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Protein 120g | Carbs 150g | Fats 50g',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedPlan = 0;
                      });
                      _showCheckoutDialog('Weekly Plan', '₹ 1,999');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D5BFF),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Color(0xFF2D5BFF).withOpacity(0.3),
                    ),
                    child: Text(
                      'Proceed to checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyPlan() {
    final isSelected = selectedPlan == 1;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF2D5BFF) : Colors.transparent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.star_border,
                  size: 30,
                  color: isSelected ? Colors.white : Colors.grey[400],
                ),
                SizedBox(height: 10),
                Text(
                  'Monthly plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '₹ 6,999',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Muscle Gain',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF0A0A0A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Column(
              children: [
                _buildPlanDetail('Duration : 30 days/ month'),
                _buildPlanDetail('Daily calorie target : 2400kcal'),
                _buildPlanDetail(
                  'Meals per day : 3/ Breakfast, Lunch & Dinner',
                ),
                SizedBox(height: 10),
                Text(
                  'Nutrients',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Protein 120g | Carbs 150g | Fats 50g',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedPlan = 1;
                      });
                      _showCheckoutDialog('Monthly Plan', '₹ 6,999');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D5BFF),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      shadowColor: Color(0xFF2D5BFF).withOpacity(0.3),
                    ),
                    child: Text(
                      'Proceed to checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanDetail(String detail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Text(
        detail,
        style: TextStyle(fontSize: 14, color: Colors.grey[400]),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _handleContinue() {
    if (selectedPlan == null) {
      _showSnackBar('Please select a plan');
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.profile,
      (route) => false,
    );
    Navigator.pop(context);
  }

  void _showCheckoutDialog(String planName, String price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFF1A1A1A),
          title: Text(
            'Confirm Purchase',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5BFF),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plan: $planName',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Price: $price',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5BFF),
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Are you sure you want to proceed with this subscription?',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processPayment(planName, price);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2D5BFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _processPayment(String planName, String price) {
    // Get the profile data provider
    final profileProvider = Provider.of<ProfileDataProvider>(
      context,
      listen: false,
    );

    // Store subscription plan data in the provider
    profileProvider.updateSubscriptionDetails(
      subscriptionType: planName,
      isSubscribed: true,
      subscriptionStartDate: DateTime.now(),
      subscriptionEndDate: DateTime.now().add(
        Duration(days: 30),
      ), // Example: 30 days subscription
    );
    profileProvider.setSubscriptionPlanCompleted(true);

    // Log all profile data before processing payment
    profileProvider.logAllProfileData(pageName: 'Subscription Plans Screen');

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFF1A1A1A),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D5BFF)),
              ),
              SizedBox(height: 20),
              Text(
                'Processing Payment...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );

    // Simulate payment processing
    Future.delayed(Duration(seconds: 3), () {
      // Navigator.of(context).pop(); // Close loading dialog
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
      _showSuccessDialog(planName, price);
    });
  }

  void _showSuccessDialog(String planName, String price) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFF1A1A1A),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF2D5BFF),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 40, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your $planName subscription has been activated.',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              Text(
                'Amount paid: $price',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D5BFF),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the success dialog
                    _handleContinue();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2D5BFF),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
}
