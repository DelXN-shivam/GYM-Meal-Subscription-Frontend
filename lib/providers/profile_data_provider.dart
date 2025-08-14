import 'package:flutter/foundation.dart';
import 'dart:developer';
import 'package:gym_app_user_1/services/local_storage_service.dart';
import 'package:provider/provider.dart';

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

  // Nutrition & Health Data
  double? _bmr;
  double? _tdee;
  double? _recommendedCalories;
  double? _bmi;
  double? _protein; // percent
  double? _carbs; // percent
  double? _fats; // percent

  // Address Details
  String? _defaultAddress;
  String? _actualAddress;
  DateTime? _deliveryDate;

  // Products and Subscriptions
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _subscriptions = [];

  // Meta fields
  String? _userId;
  String? _originalPassword;
  DateTime? _createdAt;
  DateTime? _updatedAt;
  int? _v;

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
  double? get bmr => _bmr;
  double? get tdee => _tdee;
  double? get recommendedCalories => _recommendedCalories;
  double? get bmi => _bmi;
  double? get protein => _protein;
  double? get carbs => _carbs;
  double? get fats => _fats;

  // Address Details Getters
  String? get defaultAddress => _defaultAddress;
  String? get actualAddress => _actualAddress;
  DateTime? get deliveryDate => _deliveryDate;

  // Products and Subscriptions Getters
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get subscriptions => _subscriptions;

  // Meta fields Getters
  String? get userId => _userId;
  String? get originalPassword => _originalPassword;
  DateTime? get createdAt => _createdAt;
  DateTime? get updatedAt => _updatedAt;
  int? get v => _v;

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

  // Nutrition & Health Methods
  void updateNutritionAndHealth({
    double? bmr,
    double? tdee,
    double? recommendedCalories,
    double? bmi,
    double? protein,
    double? carbs,
    double? fats,
  }) {
    _bmr = bmr ?? _bmr;
    _tdee = tdee ?? _tdee;
    _recommendedCalories = recommendedCalories ?? _recommendedCalories;
    _bmi = bmi ?? _bmi;
    _protein = protein ?? _protein;
    _carbs = carbs ?? _carbs;
    _fats = fats ?? _fats;
    notifyListeners();
  }

  // Comprehensive logging method - UPDATED VERSION
  void logAllProfileData({String? pageName}) {
    log('=== PROFILE DATA LOG ${pageName != null ? '($pageName)' : ''} ===');

    // Signup Data
    log('SIGNUP DATA:');
    log('  Full Name: $_fullName');
    log('  Email: $_email');
    log('  Phone Number: $_phoneNumber');
    log('  Password: $_password');
    log('  Original Password: $_originalPassword');
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
    log('  Meals Per Day: $_mealsPerDay');
    log('  Selected Meal Types: $_selectedMealTypes');
    log('  Plan Duration: $_planDuration days');

    // Address Details
    log('ADDRESS DETAILS:');
    log('  Default Address: $_defaultAddress');
    log('  Actual Address: $_actualAddress');
    log('  Custom Address: $_customAddress');
    log('  Delivery Date: $_deliveryDate');

    // Product Details - ENHANCED LOGGING
    log('PRODUCT DETAILS:');
    if (_products.isEmpty) {
      log('  No products');
    } else {
      for (var product in _products) {
        log('  Product:');
        product.forEach((key, value) {
          if (value is List) {
            log('    $key: ${value.join(', ')}');
          } else {
            log('    $key: $value');
          }
        });
      }
    }

    // Subscription Details - ENHANCED LOGGING
    log('SUBSCRIPTION DETAILS:');
    if (_subscriptions.isEmpty) {
      log('  No subscriptions');
    } else {
      for (var sub in _subscriptions) {
        log('  Subscription:');
        sub.forEach((key, value) {
          log('    $key: $value');
        });
      }
    }

    // Nutrition & Health Data
    log('NUTRITION & HEALTH:');
    log('  BMR: $_bmr');
    log('  TDEE: $_tdee');
    log('  Recommended Calories: $_recommendedCalories');
    log('  BMI: $_bmi');
    log('  Protein: $_protein%');
    log('  Carbs: $_carbs%');
    log('  Fats: $_fats%');

    // Meta fields
    log('META DATA:');
    log('  User ID: $_userId');
    log('  Created At: $_createdAt');
    log('  Updated At: $_updatedAt');
    log('  Version: $_v');

    // Profile Completion
    log('PROFILE COMPLETION:');
    log('  Current Step: $currentProfileStep');
    log(
      '  Completion %: ${(profileCompletionPercent * 100).toStringAsFixed(1)}%',
    );
    log('  Signup Completed: $_signupCompleted');
    log('  Details Completed: $_detailsCompleted');
    log('  Preferences Completed: $_preferencesCompleted');
    log('  Sample Meal Completed: $_sampleMealCompleted');
    log('  Subscription Details Completed: $_subscriptionDetailsCompleted');
    log('  Subscription Plan Completed: $_subscriptionPlanCompleted');

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
    _bmr = null;
    _tdee = null;
    _recommendedCalories = null;
    _bmi = null;
    _protein = null;
    _carbs = null;
    _fats = null;
    _defaultAddress = null;
    _actualAddress = null;
    _deliveryDate = null;
    _products = [];
    _subscriptions = [];
    _userId = null;
    _originalPassword = null;
    _createdAt = null;
    _updatedAt = null;
    _v = null;
    notifyListeners();
  }

  // Add this method to update all fields from user JSON
  void updateFromUserJson(Map<String, dynamic> userJson) {
    // Basic info
    _fullName = userJson['name'];
    _email = userJson['email'];
    _phoneNumber = userJson['contactNo'];
    _password = userJson['password'];
    _gender = userJson['gender'];
    _age = userJson['age'];
    _height = (userJson['height'] is int)
        ? (userJson['height'] as int).toDouble()
        : userJson['height'];
    _weight = (userJson['weight'] is int)
        ? (userJson['weight'] as int).toDouble()
        : userJson['weight'];
    _homeAddress = userJson['homeAddress'];
    _officeAddress = userJson['officeAddress'];
    _collegeAddress = userJson['collegeAddress'];
    // Preferences
    _dietaryPreference = List<String>.from(userJson['dietPreference'] ?? []);
    _allergies = List<String>.from(userJson['allergy'] ?? []);
    _goal = userJson['fitnessGoal'];
    _activityLevel = userJson['activityLevel'];
    // Meal Data
    final mealData = userJson['mealData'] ?? {};
    _mealsPerDay = mealData['mealPerDay'];
    _selectedMealTypes = List<String>.from(mealData['mealTypes'] ?? []);
    _planDuration = mealData['numberOfDays'];
    _mealPlanType =
        (mealData['mealDuration'] != null &&
            mealData['mealDuration'] is List &&
            mealData['mealDuration'].isNotEmpty)
        ? mealData['mealDuration'][0]
        : null;
    // Nutrition & Health
    _bmr = (userJson['nutrients']?['bmr'] as num?)?.toDouble() ?? 0.0;
    _tdee = (userJson['nutrients']?['tdee'] as num?)?.toDouble() ?? 0.0;
    _recommendedCalories =
        (userJson['nutrients']?['recommendedCalories'] as num?)?.toDouble() ??
        0.0;
    _bmi = (userJson['nutrients']?['bmi'] as num?)?.toDouble() ?? 0.0;
    _protein =
        (userJson['nutrients']?['macroNutrients']?['protein'] as num?)
            ?.toDouble() ??
        0.0;
    _carbs =
        (userJson['nutrients']?['macroNutrients']?['carbs'] as num?)
            ?.toDouble() ??
        0.0;
    _fats =
        (userJson['nutrients']?['macroNutrients']?['fats'] as num?)
            ?.toDouble() ??
        0.0;

    // Address Details
    final addressDetails = userJson['addressDetails'] ?? {};
    _defaultAddress = addressDetails['defaultAddress'];
    _actualAddress = addressDetails['actualAddress'];
    _customAddress = addressDetails['customAddress'];
    _deliveryDate = addressDetails['deliveryDate'] != null
        ? DateTime.tryParse(addressDetails['deliveryDate'])
        : null;

    // Products
    if (userJson['products'] != null && userJson['products'] is List) {
      log('Products raw: ${userJson['products']}');
      _products = List<Map<String, dynamic>>.from(
        (userJson['products'] as List).map((e) => Map<String, dynamic>.from(e)),
      );
      log('Products parsed: $_products');
    } else {
      _products = [];
    }

    // Subscriptions
    if (userJson['subscriptions'] != null &&
        userJson['subscriptions'] is List) {
      _subscriptions = List<Map<String, dynamic>>.from(
        (userJson['subscriptions'] as List).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      );
    } else {
      _subscriptions = [];
    }

    // Meta fields
    _userId = userJson['_id'];
    _originalPassword = userJson['originalPassword'];
    _createdAt = userJson['createdAt'] != null
        ? DateTime.tryParse(userJson['createdAt'])
        : null;
    _updatedAt = userJson['updatedAt'] != null
        ? DateTime.tryParse(userJson['updatedAt'])
        : null;
    _v = userJson['__v'];

    // Subscriptions, products, etc. can be handled similarly if needed
    notifyListeners();
  }

  Future<void> refreshProfileData() async {
    // TODO: Replace this with your actual backend fetch logic
    // Example: final latestUserJson = await fetchUserJsonFromBackend();
    // For now, this is just a placeholder that returns null
    Map<String, dynamic>? latestUserJson;
    // Uncomment and implement your backend fetch here:
    // latestUserJson = await YourApiService.getUserProfile();

    if (latestUserJson != null) {
      updateFromUserJson(latestUserJson);
    }
    // Optionally, you can keep the local storage fallback for username/email
    final localStorage = LocalStorageService();
    final username = await localStorage.getUsername();
    final email = await localStorage.getMongoEmail();
    updateSignupData(fullName: username, email: email);
    // notifyListeners(); // already called in updateSignupData and updateFromUserJson
  }
}
