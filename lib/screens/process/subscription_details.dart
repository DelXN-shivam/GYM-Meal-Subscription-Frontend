import 'dart:convert';
import 'dart:developer';
import 'package:gym_app_user_1/screens/process/subscription_plans_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  final String mongoId;
  const SubscriptionDetailsScreen({Key? key, required this.mongoId})
    : super(key: key);

  @override
  _SubscriptionDetailsScreenState createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  // final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  // Plan duration
  String? selectedDuration;
  final List<String> durations = ['Weekly', 'Monthly'];

  // Meals per day
  bool showMealsDropdown = false;
  int? selectedMealsPerDay;
  final List<int> mealOptions = [1, 2, 3];

  // Meal types (multiple selection)
  Set<String> selectedMealTypes = {};
  final List<String> allMealTypes = ['Breakfast', 'Lunch', 'Dinner'];

  // Number of days/weeks
  int? selectedPlanDuration;
  final List<int> planDurations = [5, 7];

  // Start date
  bool showDatePicker = false;
  DateTime? selectedDate;
  DateTime currentMonth = DateTime.now();

  // Add these variables at the top of the class with other state variables
  String? selectedDefaultAddress;
  final List<String> defaultAddresses = ['Home', 'Office', 'College'];

  // Custom address
  TextEditingController customAddressController = TextEditingController();

  Future<void> _handleContinue() async {
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

    // Meal types count validation
    if (selectedMealsPerDay != null &&
        selectedMealTypes.length != selectedMealsPerDay) {
      _showSnackBar('Please select exactly $selectedMealsPerDay meal type(s)');
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
          "mealData": {
            "mealPerDay": selectedMealsPerDay,
            "mealTypes": selectedMealTypes.toList(),
            "numberOfDays": selectedPlanDuration,
            "mealDuration": selectedDuration!.toLowerCase(),
            // "dietaryPreference": ,
          },
        }),
      );
      log('Update response status: ${backendResponse.statusCode}');
      log('Update response body: ${backendResponse.body}');
      if (backendResponse.statusCode == 200 ||
          backendResponse.statusCode == 201) {
        final responseData = json.decode(backendResponse.body);
        log("Decoded Data: $responseData");
        log('Update successful, storing user data...');
        log(backendResponse.body);
        _showSnackBar('Data updated successfully! ✅');

        // Get the profile data provider
        final profileProvider = Provider.of<ProfileDataProvider>(
          context,
          listen: false,
        );

        // Store meal preferences data in the provider
        profileProvider.updateSubscriptionDetails(
          planDuration: selectedPlanDuration,
          mealsPerDay: selectedMealsPerDay,
          selectedMealTypes: selectedMealTypes.toList(),
          planLength: selectedPlanDuration,
          startDate: selectedDate,
          defaultDeliveryAddress: selectedDefaultAddress,
        );
        profileProvider.setPreferencesCompleted(true);

        // Log all profile data before navigation
        profileProvider.logAllProfileData(
          pageName: 'Subscription Details Screen',
        );

        // Show success and print preferences
        _showSnackBar('Fetching subscription details!');

        log('=== SUBSCRIPTION DETAILS DATA ===');
        log('Plan Duration: $selectedDuration');
        log('Meals Per Day: $selectedMealsPerDay');
        log('Meal Types: $selectedMealTypes');
        log('Plan Length: $selectedPlanDuration');
        log('Start Date: $selectedDate');
        log('Default Delivery Address: $selectedDefaultAddress');

        // Navigator.pushNamed(context, AppRoutes.setPreferences);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SubscriptionPlansPage(mongoId: widget.mongoId),
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
                'Subscription Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Choose plan details',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 40),

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
              _buildSectionTitle('Default Delivery Address'),
              SizedBox(height: 12),
              _buildDefaultDeliveryAddress(),
              SizedBox(height: 32),

              // Continue Button
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    shadowColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
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
                          'Continue to choose your plan',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
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
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPlanDurationSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
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
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    duration,
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
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
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              count == 1 ? 'Meal' : 'Meals',
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: allMealTypes.map((mealType) {
          final isSelected = selectedMealTypes.contains(mealType.toLowerCase());
          final canSelectMore =
              selectedMealsPerDay == null ||
              selectedMealTypes.length < selectedMealsPerDay!;
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  if (selectedMealTypes.length > 1) {
                    selectedMealTypes.remove(mealType.toLowerCase());
                  } else {
                    _showSnackBar('At least one meal type must be selected');
                  }
                } else {
                  if (canSelectMore) {
                    selectedMealTypes.add(mealType.toLowerCase());
                  } else {
                    _showSnackBar(
                      'You can only select $selectedMealsPerDay meal type(s)',
                    );
                  }
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    mealType,
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        spacing: 16,
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
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '$plan day meal plan',
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
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
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
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
                          ? Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7)
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  showDatePicker
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
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
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
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
                      icon: Icon(
                        Icons.chevron_left,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
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
                      icon: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
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
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
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
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isOtherMonth || isPast
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                  : isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        spacing: 16,
        children: [
          ...defaultAddresses.map((address) {
            final isSelected = selectedDefaultAddress == address;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDefaultAddress = address;
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check : Icons.add,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Icon(
                      _getAddressIcon(address),
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      address,
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
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

  void _showSubscriptionSummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Subscription Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryItem('Plan Duration', selectedDuration!),
              _buildSummaryItem('Meals per Day', '$selectedMealsPerDay'),
              _buildSummaryItem('Meal Types', selectedMealTypes.join(', ')),
              _buildSummaryItem(
                'Plan Length',
                '${selectedPlanDuration ?? ''} day meal plan',
              ),
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
                  color: Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
