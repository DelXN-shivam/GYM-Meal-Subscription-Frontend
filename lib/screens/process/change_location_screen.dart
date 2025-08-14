import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';

class ChangeLocationScreen extends StatefulWidget {
  @override
  _ChangeLocationScreenState createState() => _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<ChangeLocationScreen> {
  // Pause delivery
  bool isPauseDelivery = false;

  // Default delivery address
  String? selectedDefaultAddress;
  final List<String> defaultAddresses = ['Home', 'Office', 'College'];

  // Specific day delivery
  bool showDatePicker = false;
  DateTime? selectedDate;
  DateTime currentMonth = DateTime.now();

  // Change delivery location
  String? selectedDeliveryLocation;
  final List<String> deliveryLocations = [
    'Home',
    'Office',
    'College',
    'Custom',
  ];

  // Custom address
  TextEditingController customAddressController = TextEditingController();

  // Notification
  bool notifyBeforeDelivery = true;

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<ProfileDataProvider>(
      context,
      listen: false,
    );
    if (profileProvider.defaultDeliveryAddress != null)
      selectedDefaultAddress = profileProvider.defaultDeliveryAddress;
    if (profileProvider.currentLocation != null)
      selectedDeliveryLocation = profileProvider.currentLocation;
    if (profileProvider.customAddress != null)
      customAddressController.text = profileProvider.customAddress!;
  }

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
                'Set things up',
                style: TextStyle(
                  color: Color(0xFF2D3748),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Configure your delivery preferences',
                style: TextStyle(
                  color: Color(0xFF4A5568),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 32),

              // Pause Delivery
              _buildSectionTitle('Pause Delivery'),
              SizedBox(height: 12),
              _buildPauseDelivery(),
              SizedBox(height: 32),

              // Default Delivery Address
              _buildSectionTitle('Default Delivery Address'),
              SizedBox(height: 12),
              _buildDefaultDeliveryAddress(),
              SizedBox(height: 32),

              // Specific Day Delivery
              _buildSectionTitle('Specific Day Delivery'),
              SizedBox(height: 12),
              _buildSpecificDayDelivery(),
              SizedBox(height: 32),

              // Change Delivery Location
              _buildSectionTitle('Change Delivery Location'),
              SizedBox(height: 12),
              _buildChangeDeliveryLocation(),
              SizedBox(height: 32),

              // Custom Address
              _buildSectionTitle('Custom Address'),
              SizedBox(height: 12),
              _buildCustomAddress(),
              SizedBox(height: 32),

              // Notify Me
              _buildSectionTitle('Notifications'),
              SizedBox(height: 12),
              _buildNotifyMe(),
              SizedBox(height: 48),

              // Proceed Button
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4ECDC4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Proceed to payment',
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

  Widget _buildPauseDelivery() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isPauseDelivery = !isPauseDelivery;
          });
        },
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isPauseDelivery
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isPauseDelivery
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).dividerColor,
                  width: 2,
                ),
              ),
              child: isPauseDelivery
                  ? Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 15),
            Icon(
              Icons.pause,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Pause delivery',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultDeliveryAddress() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: defaultAddresses.map((address) {
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
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Icon(
                    _getAddressIcon(address),
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    address,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
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

  Widget _buildSpecificDayDelivery() {
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
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Select specific date',
                    style: TextStyle(
                      color: selectedDate == null
                          ? Theme.of(context).hintColor
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  showDatePicker
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.onSurface,
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
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
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
                        color: Theme.of(context).colorScheme.onSurface,
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
                            color: Theme.of(context).colorScheme.onSurface,
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
                            color: Theme.of(context).colorScheme.onSurface,
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

  Widget _buildChangeDeliveryLocation() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ...deliveryLocations.map((location) {
            final isSelected = selectedDeliveryLocation == location;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDeliveryLocation = location;
                  if (location != 'Custom') {
                    customAddressController.clear();
                  }
                });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check : Icons.add,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Icon(
                      location == 'Custom'
                          ? Icons.edit_location_alt_outlined
                          : _getAddressIcon(location),
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      location,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
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

  Widget _buildCustomAddress() {
    if (selectedDeliveryLocation != 'Custom') {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: customAddressController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Enter custom address',
          hintStyle: TextStyle(color: Theme.of(context).hintColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildNotifyMe() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            notifyBeforeDelivery = !notifyBeforeDelivery;
          });
        },
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: notifyBeforeDelivery
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: notifyBeforeDelivery
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).dividerColor,
                  width: 2,
                ),
              ),
              child: notifyBeforeDelivery
                  ? Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                'Notify 30 minutes before delivery',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
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
          children: days.sublist(i, Math.min(i + 7, days.length)),
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
                  ? Theme.of(context).hintColor
                  : isSelected
                  ? Colors.white
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

  void _handleProceed() {
    // Validate selections
    if (selectedDefaultAddress == null) {
      _showSnackBar('Please select a default delivery address');
      return;
    }

    if (selectedDeliveryLocation == null) {
      _showSnackBar('Please select a delivery location');
      return;
    }

    if (selectedDeliveryLocation == 'Custom' &&
        customAddressController.text.trim().isEmpty) {
      _showSnackBar('Please enter a custom address');
      return;
    }

    // Get the profile data provider
    final profileProvider = Provider.of<ProfileDataProvider>(
      context,
      listen: false,
    );

    // Store location data in the provider
    profileProvider.updateLocation(
      currentLocation: selectedDeliveryLocation,
      address: selectedDeliveryLocation == 'Custom'
          ? customAddressController.text.trim()
          : selectedDeliveryLocation,
    );

    // Log all profile data before navigation
    profileProvider.logAllProfileData(pageName: 'Change Location Screen');

    // Log all selected data
    print('=== Setup Screen Data ===');
    print('Pause Delivery: ${isPauseDelivery ? 'Yes' : 'No'}');
    print('Default Delivery Address: $selectedDefaultAddress');
    print('Selected Delivery Location: $selectedDeliveryLocation');
    if (selectedDeliveryLocation == 'Custom') {
      print('Custom Address: ${customAddressController.text.trim()}');
    }
    if (selectedDate != null) {
      print(
        'Specific Delivery Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
      );
    }
    print('Notify Before Delivery: ${notifyBeforeDelivery ? 'Yes' : 'No'}');
    print('=======================');

    Navigator.pushNamed(context, AppRoutes.subscriptionPlans);
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
