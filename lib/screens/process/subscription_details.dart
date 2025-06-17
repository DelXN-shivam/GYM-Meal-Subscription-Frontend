import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app_user_1/config/routes.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  @override
  _SubscriptionDetailsScreenState createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  // Plan duration
  String? selectedDuration;
  final List<String> durations = ['Weekly', 'Monthly'];

  // Meals per day
  bool showMealsDropdown = false;
  int? selectedMealsPerDay;
  final List<int> mealOptions = [1, 2, 3];

  // Meal types (multiple selection)
  Set<String> selectedMealTypes = {'Breakfast'};
  final List<String> allMealTypes = ['Breakfast', 'Lunch', 'Dinner'];

  // Number of days/weeks
  String? selectedPlanDuration;
  final List<String> planDurations = ['5 day meal plan', '7 day meal plan'];

  // Start date
  bool showDatePicker = false;
  DateTime? selectedDate;
  DateTime currentMonth = DateTime.now();

  // Add these variables at the top of the class with other state variables
  String? selectedDefaultAddress;
  final List<String> defaultAddresses = ['Home', 'Office', 'College', 'Custom'];

  // Custom address
  TextEditingController customAddressController = TextEditingController();

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
                'Subscription Details',
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Choose plan details',
                style: TextStyle(
                  color: Color(0xFF4A5568),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 32),

              // Plan Duration
              _buildSectionTitle('Plan duration'),
              SizedBox(height: 12),
              _buildPlanDurationSection(),
              SizedBox(height: 32),

              // Meals per day
              _buildSectionTitle('Meals per day'),
              SizedBox(height: 12),
              _buildMealsPerDaySection(),
              SizedBox(height: 32),

              // Meal Types
              _buildSectionTitle('Meal Types'),
              SizedBox(height: 12),
              _buildMealTypesSection(),
              SizedBox(height: 32),

              // Plan Duration
              _buildSectionTitle('Plan Length'),
              SizedBox(height: 12),
              _buildPlanDurationOptionsSection(),
              SizedBox(height: 32),

              // Start Date
              _buildSectionTitle('Start Date'),
              SizedBox(height: 12),
              _buildStartDateSection(),
              SizedBox(height: 32),

              // Add this before the Continue Button
              SizedBox(height: 32),
              _buildSectionTitle('Default Delivery Address'),
              SizedBox(height: 12),
              _buildDefaultDeliveryAddress(),
              SizedBox(height: 32),

              // Continue Button
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4ECDC4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue to choose your plan',
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

  Widget _buildPlanDurationSection() {
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
        children: durations.map((duration) {
          final isSelected = selectedDuration == duration;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDuration = duration;
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
                    duration,
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

  Widget _buildMealsPerDaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: mealOptions.map((count) {
            return _buildMealCountCard(
              count: count,
              isSelected: selectedMealsPerDay == count,
              onTap: () => setState(() => selectedMealsPerDay = count),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMealCountCard({
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2D8A7A) : Color(0xFFBDE5DF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xFF2D8A7A) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF2D3748),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              count == 1 ? 'Meal' : 'Meals',
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF2D3748),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypesSection() {
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
        children: allMealTypes.map((mealType) {
          final isSelected = selectedMealTypes.contains(mealType);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  if (selectedMealTypes.length > 1) {
                    selectedMealTypes.remove(mealType);
                  } else {
                    _showSnackBar('At least one meal type must be selected');
                  }
                } else {
                  selectedMealTypes.add(mealType);
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
                    mealType,
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

  Widget _buildPlanDurationOptionsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: planDurations.map((plan) {
          final isSelected = selectedPlanDuration == plan;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPlanDuration = plan;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF2D8A7A) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected ? Colors.white : Color(0xFF2D3748),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    plan,
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

  Widget _buildStartDateSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showDatePicker = !showDatePicker;
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
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Select start date',
                    style: TextStyle(
                      color: selectedDate == null
                          ? Color(0xFF9CA3AF)
                          : Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  showDatePicker
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Color(0xFF2D3748),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (showDatePicker) ...[
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF4ECDC4), width: 2),
            ),
            child: Column(
              children: [
                // Month navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentMonth = DateTime(
                            currentMonth.year,
                            currentMonth.month - 1,
                          );
                        });
                      },
                      icon: Icon(Icons.chevron_left, color: Color(0xFF2D3748)),
                    ),
                    Text(
                      '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentMonth = DateTime(
                            currentMonth.year,
                            currentMonth.month + 1,
                          );
                        });
                      },
                      icon: Icon(Icons.chevron_right, color: Color(0xFF2D3748)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Week days header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                    return Container(
                      width: 35,
                      height: 35,
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A5568),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                // Calendar grid
                ..._buildCalendarWeeks(),
                SizedBox(height: 20),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            showDatePicker = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF4A5568),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedDate == null) {
                            _showSnackBar('Please select a date');
                            return;
                          }
                          setState(() {
                            showDatePicker = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4ECDC4),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildCalendarWeeks() {
    List<Widget> weeks = [];
    DateTime firstDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    );
    DateTime lastDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    );

    int firstWeekday = firstDayOfMonth.weekday == 7
        ? 0
        : firstDayOfMonth.weekday;
    int daysInMonth = lastDayOfMonth.day;

    List<Widget> days = [];

    // Previous month days
    DateTime prevMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    int prevMonthDays = DateTime(prevMonth.year, prevMonth.month + 1, 0).day;

    for (int i = firstWeekday - 1; i >= 0; i--) {
      days.add(_buildCalendarDay(prevMonthDays - i, true));
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(_buildCalendarDay(day, false));
    }

    // Next month days
    int remainingDays = (7 - (days.length % 7)) % 7;
    for (int day = 1; day <= remainingDays; day++) {
      days.add(_buildCalendarDay(day, true));
    }

    // Group days into weeks
    for (int i = 0; i < days.length; i += 7) {
      weeks.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.sublist(i, i + 7),
        ),
      );
      if (i + 7 < days.length) {
        weeks.add(SizedBox(height: 5));
      }
    }

    return weeks;
  }

  Widget _buildCalendarDay(int day, bool isOtherMonth) {
    DateTime dayDate = DateTime(currentMonth.year, currentMonth.month, day);
    bool isSelected =
        selectedDate != null &&
        selectedDate!.day == day &&
        selectedDate!.month == currentMonth.month &&
        selectedDate!.year == currentMonth.year &&
        !isOtherMonth;

    bool isPast = dayDate.isBefore(DateTime.now().subtract(Duration(days: 1)));

    return GestureDetector(
      onTap: isOtherMonth || isPast
          ? null
          : () {
              setState(() {
                selectedDate = DateTime(
                  currentMonth.year,
                  currentMonth.month,
                  day,
                );
              });
            },
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF4ECDC4) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isOtherMonth || isPast
                  ? Color(0xFFCBD5E0)
                  : isSelected
                  ? Colors.white
                  : Color(0xFF2D3748),
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Widget _buildDefaultDeliveryAddress() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ...defaultAddresses.map((address) {
            final isSelected = selectedDefaultAddress == address;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDefaultAddress = address;
                  if (address != 'Custom') {
                    customAddressController.clear();
                  }
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF2D8A7A) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check : Icons.add,
                      color: isSelected ? Colors.white : Color(0xFF2D3748),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Icon(
                      address == 'Custom'
                          ? Icons.edit_location_alt_outlined
                          : _getAddressIcon(address),
                      color: isSelected ? Colors.white : Color(0xFF2D3748),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      address,
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
          if (selectedDefaultAddress == 'Custom') ...[
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: customAddressController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter custom address',
                  hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(fontSize: 16, color: Color(0xFF2D3748)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getAddressIcon(String address) {
    switch (address) {
      case 'Home':
        return Icons.home_outlined;
      case 'Office':
        return Icons.business_outlined;
      case 'College':
        return Icons.school_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  void _handleContinue() {
    // Validate selections
    if (selectedDuration == null) {
      _showSnackBar('Please select a plan duration');
      return;
    }

    if (selectedMealsPerDay == null) {
      _showSnackBar('Please select number of meals per day');
      return;
    }

    if (selectedPlanDuration == null) {
      _showSnackBar('Please select a plan length');
      return;
    }

    if (selectedDate == null) {
      _showSnackBar('Please select a start date');
      return;
    }

    if (selectedDefaultAddress == null) {
      _showSnackBar('Please select a default delivery address');
      return;
    }

    if (selectedDefaultAddress == 'Custom' &&
        customAddressController.text.trim().isEmpty) {
      _showSnackBar('Please enter a custom address');
      return;
    }

    // Log all selected data
    print('=== Subscription Details Data ===');
    print('Plan Duration: $selectedDuration');
    print('Meals per Day: $selectedMealsPerDay');
    print('Meal Types: ${selectedMealTypes.join(', ')}');
    print('Plan Length: $selectedPlanDuration');
    print(
      'Start Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
    );
    print('Default Delivery Address: $selectedDefaultAddress');
    if (selectedDefaultAddress == 'Custom') {
      print('Custom Address: ${customAddressController.text.trim()}');
    }
    print('==============================');

    Navigator.pushNamed(context, AppRoutes.subscriptionPlans);
  }

  void _showSubscriptionSummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Subscription Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D8A7A),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryItem('Plan Duration', selectedDuration!),
              _buildSummaryItem('Meals per Day', '$selectedMealsPerDay'),
              _buildSummaryItem('Meal Types', selectedMealTypes.join(', ')),
              _buildSummaryItem('Plan Length', selectedPlanDuration!),
              _buildSummaryItem(
                'Start Date',
                '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Color(0xFF2D8A7A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
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
