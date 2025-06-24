import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gym_app_user_1/screens/process/set_preferences_screen.dart';
import 'package:gym_app_user_1/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  @override
  _AdditionalDetailsScreenState createState() =>
      _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final LocalStorageService _localStorageService = LocalStorageService();
  String mongoId = "";

  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController collegeAddressController = TextEditingController();

  String? selectedGender;
  bool isGenderDropdownExpanded = false;
  bool showHomeAddress = true;
  bool showOfficeAddress = false;
  bool showCollegeAddress = false;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadMongoId();
  }

  void _loadMongoId() async {
    final id = await _localStorageService.getMongoId();
    setState(() {
      mongoId = id ?? "";
    });
  }

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    homeAddressController.dispose();
    officeAddressController.dispose();
    collegeAddressController.dispose();
    super.dispose();
  }

  void _handleContinue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
    });
    if (selectedGender == null) {
      _showSnackBar('Please select your gender');
      return;
    }
    try {
      log('Starting backend data storing...');
      if (mongoId.isEmpty) {
        throw Exception('User ID not found. Please try again.');
      }
      final backendResponse = await http.put(
        Uri.parse(
          'https://gym-meal-subscription-backend.vercel.app/api/v1/user/update/${mongoId}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'age': ageController.text.trim(),
          'weight': weightController.text.trim(),
          'height': heightController.text.trim(),
          "gender": selectedGender!.toLowerCase(),
          "homeAddress": homeAddressController.text.trim(),
          "officeAddress": officeAddressController.text.trim(),
          "collegeAddress": collegeAddressController.text.trim(),
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
        final profileProvider = Provider.of<ProfileDataProvider>(
          context,
          listen: false,
        );
        profileProvider.updateSignupData(
          age: int.tryParse(ageController.text.trim()),
          weight: double.tryParse(weightController.text.trim()),
          height: double.tryParse(heightController.text.trim()),
          gender: selectedGender!.toLowerCase(),
          homeAddress: homeAddressController.text.trim(),
          officeAddress: officeAddressController.text.trim(),
          collegeAddress: collegeAddressController.text.trim(),
        );
        profileProvider.setDetailsCompleted(true);
        profileProvider.logAllProfileData(pageName: 'Additional data Screen');

        // Navigator.pushNamed(context, AppRoutes.setPreferences);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPreferencesScreen(mongoId: mongoId),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button and logo
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
                    SizedBox(width: 24), // To balance the row
                  ],
                ),
                SizedBox(height: 40),
                Text(
                  'Additional Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tell us more about you',
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
                SizedBox(height: 40),
                _buildLabel('Your age'),
                SizedBox(height: 12),
                _buildTextField(
                  controller: ageController,
                  hintText: 'Enter your age',
                  keyboardType: TextInputType.number,
                  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Age is required';
                    int? age = int.tryParse(value!);
                    if (age == null) return 'Please enter a valid age';
                    if (age < 12 || age > 100)
                      return 'Age must be between 12 and 100';
                    return null;
                  },
                ),
                SizedBox(height: 24),
                _buildLabel('Your gender'),
                SizedBox(height: 12),
                _buildDropdown(
                  value: selectedGender,
                  hintText: 'Select your gender',
                  items: genderOptions,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Your height'),
                          SizedBox(height: 12),
                          _buildTextField(
                            controller: heightController,
                            hintText: 'Enter height in cm',
                            keyboardType: TextInputType.number,
                            inputFormatter:
                                FilteringTextInputFormatter.digitsOnly,
                            validator: (value) {
                              if (value?.isEmpty ?? true)
                                return 'Height is required';
                              int? height = int.tryParse(value!);
                              if (height == null)
                                return 'Please enter a valid height';
                              if (height < 100 || height > 250)
                                return 'Height must be between 100 and 250 cm';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Your weight'),
                          SizedBox(height: 12),
                          _buildTextField(
                            controller: weightController,
                            hintText: 'Enter weight in kg',
                            keyboardType: TextInputType.number,
                            inputFormatter:
                                FilteringTextInputFormatter.digitsOnly,
                            validator: (value) {
                              if (value?.isEmpty ?? true)
                                return 'Weight is required';
                              int? weight = int.tryParse(value!);
                              if (weight == null)
                                return 'Please enter a valid weight';
                              if (weight < 30 || weight > 200)
                                return 'Weight must be between 30 and 200 kg';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                _buildLabel('Your address'),
                SizedBox(height: 12),
                _buildAddressDropdown(
                  label: 'Home address',
                  isExpanded: showHomeAddress,
                  controller: homeAddressController,
                  onTap: () {
                    setState(() {
                      showHomeAddress = !showHomeAddress;
                    });
                  },
                ),
                if (showHomeAddress) ...[
                  SizedBox(height: 12),
                  _buildAddressTextField(
                    controller: homeAddressController,
                    hintText: 'Enter your home address',
                  ),
                ],
                SizedBox(height: 12),
                _buildAddressDropdown(
                  label: 'Office address',
                  isExpanded: showOfficeAddress,
                  controller: officeAddressController,
                  onTap: () {
                    setState(() {
                      showOfficeAddress = !showOfficeAddress;
                    });
                  },
                ),
                if (showOfficeAddress) ...[
                  SizedBox(height: 12),
                  _buildAddressTextField(
                    controller: officeAddressController,
                    hintText: 'Enter your office address',
                  ),
                ],
                SizedBox(height: 12),
                _buildAddressDropdown(
                  label: 'College address',
                  isExpanded: showCollegeAddress,
                  controller: collegeAddressController,
                  onTap: () {
                    setState(() {
                      showCollegeAddress = !showCollegeAddress;
                    });
                  },
                ),
                if (showCollegeAddress) ...[
                  SizedBox(height: 12),
                  _buildAddressTextField(
                    controller: collegeAddressController,
                    hintText: 'Enter your college address',
                  ),
                ],
                SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleContinue,
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
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextInputFormatter? inputFormatter,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatter != null ? [inputFormatter] : null,
      style: TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        filled: true,
        fillColor: Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF2D5BFF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFFFF5555), width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFFFF5555), width: 2),
        ),
        contentPadding: EdgeInsets.all(20),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isGenderDropdownExpanded = !isGenderDropdownExpanded;
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
                    value ?? hintText,
                    style: TextStyle(
                      color: value == null ? Colors.grey[400] : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  isGenderDropdownExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (isGenderDropdownExpanded) ...[
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF2D5BFF), width: 2),
            ),
            child: Column(
              children: items.map((item) {
                final isLast = item == items.last;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = item;
                      isGenderDropdownExpanded = false;
                    });
                    onChanged(item);
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
                      item,
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

  Widget _buildAddressDropdown({
    required String label,
    required bool isExpanded,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
                label,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
        filled: true,
        fillColor: Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF2D5BFF), width: 2),
        ),
        contentPadding: EdgeInsets.all(20),
      ),
    );
  }
}
