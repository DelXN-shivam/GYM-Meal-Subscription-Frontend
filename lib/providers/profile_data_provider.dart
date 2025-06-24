import 'package:flutter/foundation.dart';
import 'dart:developer';

class ProfileDataProvider with ChangeNotifier {
  // Signup Screen Data
  String? _fullName;
  String? _email;
  String? _phoneNumber;
  String? _password;
  DateTime? _dateOfBirth;
  String? _gender;
  int? _age;
  double? _height;
  double? _weight;
  String? _homeAddress;
  String? _officeAddress;
  String? _collegeAddress;

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
  String? _goal;
  String? _activityLevel;
  List<String> _dietaryPreference = [];

  // Subscription Details
  String? _subscriptionType;
  DateTime? _subscriptionStartDate;
  DateTime? _subscriptionEndDate;
  bool _isSubscribed = false;
  int? _planDuration;
  int? _mealsPerDay;
  List<String> _selectedMealTypes = [];
  int? _planLength;
  DateTime? _startDate;
  String? _defaultDeliveryAddress;
  String? _customAddress;

  // Profile completion flags
  bool _signupCompleted = false;
  bool _detailsCompleted = false;
  bool _preferencesCompleted = false;
  bool _sampleMealCompleted = false;
  bool _subscriptionDetailsCompleted = false;
  bool _subscriptionPlanCompleted = false;

  // Getters
  String? get fullName => _fullName;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get password => _password;
  DateTime? get dateOfBirth => _dateOfBirth;
  String? get gender => _gender;
  int? get age => _age;
  double? get height => _height;
  double? get weight => _weight;
  String? get homeAddress => _homeAddress;
  String? get officeAddress => _officeAddress;
  String? get collegeAddress => _collegeAddress;
  String? get currentLocation => _currentLocation;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String? get address => _address;
  List<String> get dietaryRestrictions => _dietaryRestrictions;
  List<String> get mealPreferences => _mealPreferences;
  List<String> get allergies => _allergies;
  String? get mealPlanType => _mealPlanType;
  String? get goal => _goal;
  String? get activityLevel => _activityLevel;
  List<String>? get dietaryPreference => _dietaryPreference;
  String? get subscriptionType => _subscriptionType;
  DateTime? get subscriptionStartDate => _subscriptionStartDate;
  DateTime? get subscriptionEndDate => _subscriptionEndDate;
  bool get isSubscribed => _isSubscribed;
  int? get planDuration => _planDuration;
  int? get mealsPerDay => _mealsPerDay;
  List<String> get selectedMealTypes => _selectedMealTypes;
  int? get planLength => _planLength;
  DateTime? get startDate => _startDate;
  String? get defaultDeliveryAddress => _defaultDeliveryAddress;
  String? get customAddress => _customAddress;
  bool get signupCompleted => _signupCompleted;
  bool get detailsCompleted => _detailsCompleted;
  bool get preferencesCompleted => _preferencesCompleted;
  bool get sampleMealCompleted => _sampleMealCompleted;
  bool get subscriptionDetailsCompleted => _subscriptionDetailsCompleted;
  bool get subscriptionPlanCompleted => _subscriptionPlanCompleted;

  int get currentProfileStep {
    if (!_signupCompleted) return 0;
    if (!_detailsCompleted) return 1;
    if (!_preferencesCompleted) return 2;
    if (!_sampleMealCompleted) return 3;
    if (!_subscriptionDetailsCompleted) return 4;
    if (!_subscriptionPlanCompleted) return 5;
    return 6; // Completed
  }

  double get profileCompletionPercent =>
      ([
        _signupCompleted,
        _detailsCompleted,
        _preferencesCompleted,
        _sampleMealCompleted,
        _subscriptionDetailsCompleted,
        _subscriptionPlanCompleted,
      ].where((f) => f).length /
      6.0);

  void setSignupCompleted(bool value) {
    _signupCompleted = value;
    notifyListeners();
  }

  void setDetailsCompleted(bool value) {
    _detailsCompleted = value;
    notifyListeners();
  }

  void setPreferencesCompleted(bool value) {
    _preferencesCompleted = value;
    notifyListeners();
  }

  void setSampleMealCompleted(bool value) {
    _sampleMealCompleted = value;
    notifyListeners();
  }

  void setSubscriptionDetailsCompleted(bool value) {
    _subscriptionDetailsCompleted = value;
    notifyListeners();
  }

  void setSubscriptionPlanCompleted(bool value) {
    _subscriptionPlanCompleted = value;
    notifyListeners();
  }

  // Signup Screen Methods
  void updateSignupData({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? password,
    DateTime? dateOfBirth,
    String? gender,
    int? age,
    double? height,
    double? weight,
    String? homeAddress,
    String? officeAddress,
    String? collegeAddress,
  }) {
    _fullName = fullName ?? _fullName;
    _email = email ?? _email;
    _phoneNumber = phoneNumber ?? _phoneNumber;
    _password = password ?? _password;
    _dateOfBirth = dateOfBirth ?? _dateOfBirth;
    _gender = gender ?? _gender;
    _age = age ?? _age;
    _height = height ?? _height;
    _weight = weight ?? _weight;
    _homeAddress = homeAddress ?? _homeAddress;
    _officeAddress = officeAddress ?? _officeAddress;
    _collegeAddress = collegeAddress ?? _collegeAddress;
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
    String? goal,
    String? activityLevel,
    List<String>? dietaryPreference,
  }) {
    _dietaryRestrictions = dietaryRestrictions ?? _dietaryRestrictions;
    _mealPreferences = mealPreferences ?? _mealPreferences;
    _allergies = allergies ?? _allergies;
    _mealPlanType = mealPlanType ?? _mealPlanType;
    _goal = goal ?? _goal;
    _activityLevel = activityLevel ?? _activityLevel;
    _dietaryPreference = dietaryPreference ?? _dietaryPreference;
    notifyListeners();
  }

  // Subscription Methods
  void updateSubscriptionDetails({
    String? subscriptionType,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    bool? isSubscribed,
    int? planDuration,
    int? mealsPerDay,
    List<String>? selectedMealTypes,
    int? planLength,
    DateTime? startDate,
    String? defaultDeliveryAddress,
    String? customAddress,
  }) {
    _subscriptionType = subscriptionType ?? _subscriptionType;
    _subscriptionStartDate = subscriptionStartDate ?? _subscriptionStartDate;
    _subscriptionEndDate = subscriptionEndDate ?? _subscriptionEndDate;
    _isSubscribed = isSubscribed ?? _isSubscribed;
    _planDuration = planDuration ?? _planDuration;
    _mealsPerDay = mealsPerDay ?? _mealsPerDay;
    _selectedMealTypes = selectedMealTypes ?? _selectedMealTypes;
    _planLength = planLength ?? _planLength;
    _startDate = startDate ?? _startDate;
    _defaultDeliveryAddress = defaultDeliveryAddress ?? _defaultDeliveryAddress;
    _customAddress = customAddress ?? _customAddress;
    notifyListeners();
  }

  // Comprehensive logging method
  void logAllProfileData({String? pageName}) {
    log('=== PROFILE DATA LOG ${pageName != null ? '($pageName)' : ''} ===');

    // Signup Data
    log('SIGNUP DATA:');
    log('  Full Name: $_fullName');
    log('  Email: $_email');
    log('  Phone Number: $_phoneNumber');
    // log('  Password: ${_password != null ? '[HIDDEN]' : null}');
    log('  Password: $_password');
    log('  Date of Birth: $_dateOfBirth');
    log('  Gender: $_gender');
    log('  Age: $_age');
    log('  Height: $_height cm');
    log('  Weight: $_weight kg');
    log('  Home Address: $_homeAddress');
    log('  Office Address: $_officeAddress');
    log('  College Address: $_collegeAddress');

    // Location Data
    log('LOCATION DATA:');
    log('  Current Location: $_currentLocation');
    log('  Latitude: $_latitude');
    log('  Longitude: $_longitude');
    log('  Address: $_address');

    // Meal Preferences
    log('MEAL PREFERENCES:');
    log('  Goal: $_goal');
    log('  Activity Level: $_activityLevel');
    log('  Dietary Preference: $_dietaryPreference');
    log('  Dietary Restrictions: $_dietaryRestrictions');
    log('  Meal Preferences: $_mealPreferences');
    log('  Allergies: $_allergies');
    log('  Meal Plan Type: $_mealPlanType');

    // Subscription Details
    log('SUBSCRIPTION DETAILS:');
    log('  Subscription Type: $_subscriptionType');
    log('  Plan Duration: $_planDuration');
    log('  Meals Per Day: $_mealsPerDay');
    log('  Selected Meal Types: $_selectedMealTypes');
    log('  Plan Length: $_planLength');
    log('  Start Date: $_startDate');
    log('  Default Delivery Address: $_defaultDeliveryAddress');
    log('  Custom Address: $_customAddress');
    log('  Subscription Start Date: $_subscriptionStartDate');
    log('  Subscription End Date: $_subscriptionEndDate');
    log('  Is Subscribed: $_isSubscribed');

    log('=== END PROFILE DATA LOG ===');
  }

  // Clear all data
  void clearAllData() {
    _fullName = null;
    _email = null;
    _phoneNumber = null;
    _password = null;
    _dateOfBirth = null;
    _gender = null;
    _age = null;
    _height = null;
    _weight = null;
    _homeAddress = null;
    _officeAddress = null;
    _collegeAddress = null;
    _currentLocation = null;
    _latitude = null;
    _longitude = null;
    _address = null;
    _dietaryRestrictions = [];
    _mealPreferences = [];
    _allergies = [];
    _mealPlanType = null;
    _goal = null;
    _activityLevel = null;
    _dietaryPreference = [];
    _subscriptionType = null;
    _subscriptionStartDate = null;
    _subscriptionEndDate = null;
    _isSubscribed = false;
    _planDuration = null;
    _mealsPerDay = null;
    _selectedMealTypes = [];
    _planLength = null;
    _startDate = null;
    _defaultDeliveryAddress = null;
    _customAddress = null;
    notifyListeners();
  }
}
