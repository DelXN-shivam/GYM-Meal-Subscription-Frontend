import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:gym_app_user_1/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  void clearFields() {
    nameController.clear();
    emailController.clear();
    contactController.clear();
    passwordController.clear();
  }

  void _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      log("Firebase Account Creation Done: ${userCredential.user?.uid}");
      log('Starting backend data storing...');
      final backendResponse = await http.post(
        Uri.parse(
          'https://gym-meal-subscription-backend.vercel.app/api/v1/user/register',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'contactNo': contactController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );
      log('Signup response status: ${backendResponse.statusCode}');
      // log('Signup response body: ${backendResponse.body}');
      if (backendResponse.statusCode == 200 ||
          backendResponse.statusCode == 201) {
        final responseData = json.decode(backendResponse.body);
        // log("Decoded Data: $responseData");
        log('Signup successful, storing user data...');
        // log(backendResponse.body);
        _showSnackBar('Account created successfully!');
        final profileProvider = Provider.of<ProfileDataProvider>(
          context,
          listen: false,
        );
        profileProvider.updateSignupData(
          fullName: nameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: contactController.text.trim(),
          password: passwordController.text.trim(),
        );
        profileProvider.setSignupCompleted(true);
        profileProvider.logAllProfileData(pageName: 'Signup Screen');
        Navigator.pushNamed(context, AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.message}");
    } catch (e) {
      log("An unexpected error occurred: $e");
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
  void dispose() {
    clearFields();
    super.dispose();
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
                // Header
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 26),
                    child: SvgPicture.asset(
                      'assets/svg/newLogo.svg',
                      height: 40,
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Title
                Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Join us on your fitness journey',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 40),

                // Your name
                _buildLabel('Your name'),
                SizedBox(height: 12),
                _buildTextField(
                  controller: nameController,
                  hintText: 'Enter your name',
                  inputFormatter: FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z\s]'),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Name is required';
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Your email address
                _buildLabel('Your email address'),
                SizedBox(height: 12),
                _buildTextField(
                  controller: emailController,
                  hintText: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Email is required';
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value!)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Your contact number
                _buildLabel('Your contact number'),
                SizedBox(height: 12),
                _buildTextField(
                  controller: contactController,
                  hintText: 'Enter your contact number',
                  keyboardType: TextInputType.phone,
                  inputFormatter: FilteringTextInputFormatter.digitsOnly,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Contact number is required';
                    if (value!.length != 10)
                      return 'Contact number must be 10 digits';
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid contact number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Your password
                _buildLabel('Password'),
                SizedBox(height: 12),
                _buildTextField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Password is required';
                    if (value!.length < 6)
                      return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                SizedBox(height: 40),

                // Signup button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _handleSignup();
                            }
                          },
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
                            height: 20,
                            width: 20,
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
                SizedBox(height: 32),

                // Login link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.pushReplacementNamed(
                              //   context,
                              //   AppRoutes.login,
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFF2D5BFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF2D5BFF),
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
}
