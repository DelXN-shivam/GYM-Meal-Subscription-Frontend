import 'package:flutter/foundation.dart';

class ProfileDataProvider with ChangeNotifier {
  // Signup Screen Data
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _password;
  DateTime? _dateOfBirth;
  String? _gender;

  // Location Data
  String? _currentLocation;
  double? _latitude;
  double? _longitude;
  String? _address;

  // Meal Preferences
  List<String> _dietaryRestrictions = [];
  List<String> _mealPreferences = [];
  List<String> _allergies = [];
  String? _mealPlanType;

  // Subscription Details
  String? _subscriptionType;
  DateTime? _subscriptionStartDate;
  DateTime? _subscriptionEndDate;
  bool _isSubscribed = false;

  // Getters
  String? get fullName => _fullName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get password => _password;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get gender => _gender;
  String? get currentLocation => _currentLocation;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get address => _address;
  List<String> get dietaryRestrictions => _dietaryRestrictions;
  List<String> get mealPreferences => _mealPreferences;
  List<String> get allergies => _allergies;
  String? get mealPlanType => _mealPlanType;
  String? get subscriptionType => _subscriptionType;
  DateTime? get subscriptionStartDate => _subscriptionStartDate;
  DateTime? get subscriptionEndDate => _subscriptionEndDate;
  bool get isSubscribed => _isSubscribed;

  // Signup Screen Methods
  void updateSignupData({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? password,
    DateTime? dateOfBirth,
    String? gender,
  }) {
    _fullName = fullName ?? _fullName;
    _email = email ?? _email;
    _phoneNumber = phoneNumber ?? _phoneNumber;
    _password = password ?? _password;
    _dateOfBirth = dateOfBirth ?? _dateOfBirth;
    _gender = gender ?? _gender;
    notifyListeners();
  }

  // Location Methods
  void updateLocation({
    String? currentLocation,
    double? latitude,
    double? longitude,
    String? address,
  }) {
    _currentLocation = currentLocation ?? _currentLocation;
    _latitude = latitude ?? _latitude;
    _longitude = longitude ?? _longitude;
    _address = address ?? _address;
    notifyListeners();
  }

  // Meal Preferences Methods
  void updateMealPreferences({
    List<String>? dietaryRestrictions,
    List<String>? mealPreferences,
    List<String>? allergies,
    String? mealPlanType,
  }) {
    _dietaryRestrictions = dietaryRestrictions ?? _dietaryRestrictions;
    _mealPreferences = mealPreferences ?? _mealPreferences;
    _allergies = allergies ?? _allergies;
    _mealPlanType = mealPlanType ?? _mealPlanType;
    notifyListeners();
  }

  // Subscription Methods
  void updateSubscriptionDetails({
    String? subscriptionType,
    DateTime? startDate,
    DateTime? endDate,
    bool? isSubscribed,
  }) {
    _subscriptionType = subscriptionType ?? _subscriptionType;
    _subscriptionStartDate = startDate ?? _subscriptionStartDate;
    _subscriptionEndDate = endDate ?? _subscriptionEndDate;
    _isSubscribed = isSubscribed ?? _isSubscribed;
    notifyListeners();
  }

  // Clear all data
  void clearAllData() {
    _fullName = null;
    _email = null;
    _phoneNumber = null;
    _password = null;
    _dateOfBirth = null;
    _gender = null;
    _currentLocation = null;
    _latitude = null;
    _longitude = null;
    _address = null;
    _dietaryRestrictions = [];
    _mealPreferences = [];
    _allergies = [];
    _mealPlanType = null;
    _subscriptionType = null;
    _subscriptionStartDate = null;
    _subscriptionEndDate = null;
    _isSubscribed = false;
    notifyListeners();
  }
}
