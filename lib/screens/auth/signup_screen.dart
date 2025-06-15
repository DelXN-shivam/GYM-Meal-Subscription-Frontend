import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  // Dropdown values
  String? selectedGender;
  String? selectedAddress = 'Home address';
  // Separate toggles for each address
  bool showHomeAddress = true;
  bool showOfficeAddress = false;
  bool showCollegeAddress = false;

  // Address controllers
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController officeAddressController = TextEditingController();
  TextEditingController collegeAddressController = TextEditingController();

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> addressOptions = [
    'Home address',
    'Office address',
    'College address',
  ];

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    emailController.dispose();
    contactController.dispose();
    homeAddressController.dispose();
    officeAddressController.dispose();
    collegeAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Color(0xFF4ECDC4), width: 2),
                  ),
                  child: Text(
                    'GYM Meal',
                    style: TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Title
                Text(
                  'Signup',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 32),

                // Your name
                _buildLabel('Your name'),
                SizedBox(height: 8),
                _buildTextField(
                  controller: nameController,
                  hintText: 'Enter your name',
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Name is required';
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Your age
                _buildLabel('Your age'),
                SizedBox(height: 8),
                _buildTextField(
                  controller: ageController,
                  hintText: 'Enter your age',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Age is required';
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Your gender
                _buildLabel('Your gender'),
                SizedBox(height: 8),
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

                // Height and Weight row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Your height'),
                          SizedBox(height: 8),
                          _buildTextField(
                            controller: heightController,
                            hintText: 'Enter your height',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true)
                                return 'Height is required';
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
                          SizedBox(height: 8),
                          _buildTextField(
                            controller: weightController,
                            hintText: 'Enter your weight',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true)
                                return 'Weight is required';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Your email address
                _buildLabel('Your email address'),
                SizedBox(height: 8),
                _buildTextField(
                  controller: emailController,
                  hintText: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Email is required';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value!)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Your contact number
                _buildLabel('Your contact number'),
                SizedBox(height: 8),
                _buildTextField(
                  controller: contactController,
                  hintText: 'Enter your contact number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Contact number is required';
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Your address
                _buildLabel('Your address'),
                SizedBox(height: 8),
                // Home address dropdown
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
                // Office address dropdown
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
                // College address dropdown
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

                // Signup button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (selectedGender == null) {
                          _showSnackBar('Please select your gender');
                          return;
                        }
                        _handleSignup();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4ECDC4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Signup',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Login link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Color(0xFF718096), fontSize: 16),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              _handleLogin();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFF4ECDC4),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF4ECDC4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
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
        color: Color(0xFF2D3748),
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: Color(0xFF2D3748), fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
        filled: true,
        fillColor: Color(0xFFBDE5DF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF4ECDC4), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red, width: 2),
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFBDE5DF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hintText,
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF9CA3AF),
            size: 24,
          ),
          style: TextStyle(color: Color(0xFF2D3748), fontSize: 16),
          dropdownColor: Colors.white,
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
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
          color: Color(0xFFBDE5DF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: Color(0xFF2D3748), fontSize: 16),
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Color(0xFF9CA3AF),
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
      style: TextStyle(color: Color(0xFF2D3748), fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 16),
        filled: true,
        fillColor: Color(0xFFE8F5F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF4ECDC4), width: 2),
        ),
        contentPadding: EdgeInsets.all(20),
      ),
    );
  }

  void _handleSignup() {
    // Show success message
    _showSnackBar('Account created successfully!');

    // Here you would typically:
    // 1. Send data to your backend
    // 2. Navigate to login or home screen
    // 3. Store user data locally if needed

    print('Signup Data:');
    print('Name: ${nameController.text}');
    print('Age: ${ageController.text}');
    print('Gender: $selectedGender');
    print('Height: ${heightController.text}');
    print('Weight: ${weightController.text}');
    print('Email: ${emailController.text}');
    print('Contact: ${contactController.text}');
    print('Home Address: ${homeAddressController.text}');
    print('Office Address: ${officeAddressController.text}');
    print('College Address: ${collegeAddressController.text}');
  }

  void _handleLogin() {
    // Navigate to login screen
    _showSnackBar('Navigating to login...');
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF4ECDC4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
