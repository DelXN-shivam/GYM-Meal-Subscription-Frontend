import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:gym_app_user_1/screens/home/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/services/local_storage_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:gym_app_user_1/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Firebase authentication instance
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.setLoading(true);
    setState(() {
      _errorMessage = null;
    });

    try {
      log('Starting Firebase authentication...');
      // 1. First authenticate with Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      log('Firebase authentication successful: ${userCredential.user?.uid}');

      log('Starting backend authentication...');
      // 2. Then authenticate with your Node.js backend
      final backendResponse = await http.post(
        Uri.parse(
          'https://gym-meal-subscription-backend.vercel.app/api/v1/auth/login',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );
      log('Backend response status: ${backendResponse.statusCode}');
      log('Backend response body: ${backendResponse.body}');

      if (backendResponse.statusCode == 200 ||
          backendResponse.statusCode == 201) {
        final responseData = json.decode(backendResponse.body);
        log("Decoded Data: $responseData");
        log('Backend authentication successful, storing user data...');
        log(backendResponse.body);

        // Store user data in auth provider
        await authProvider.setUserData(
          firebaseUser: userCredential.user!,
          backendUserData: responseData['data']['user'],
        );

        // Navigate to next page
        Navigator.pushReplacementNamed(context, AppRoutes.next);
        log('Navigation completed');
      } else if (backendResponse.statusCode == 308) {
        // Handle redirect
        final location = backendResponse.headers['location'];
        if (location != null) {
          log('Following redirect to: $location');
          final redirectResponse = await http.post(
            Uri.parse(location),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'email': _emailController.text.trim(),
              'password': _passwordController.text.trim(),
            }),
          );

          if (redirectResponse.statusCode == 200 ||
              redirectResponse.statusCode == 201) {
            final responseData = json.decode(redirectResponse.body);
            log(
              'Backend authentication successful after redirect, storing user data...',
            );

            // Store user data in auth provider
            await authProvider.setUserData(
              firebaseUser: userCredential.user!,
              backendUserData: responseData['data']['user'],
            );

            // Navigate to next page
            Navigator.pushReplacementNamed(context, AppRoutes.next);
            log('Navigation completed');
          } else {
            throw Exception(
              'Backend login failed after redirect: ${redirectResponse.statusCode}',
            );
          }
        } else {
          throw Exception('Received redirect but no location header');
        }
      } else {
        // If backend login fails, sign out from Firebase to maintain consistency
        log('Backend authentication failed, signing out from Firebase...');
        await _auth.signOut();

        final errorData = json.decode(backendResponse.body);
        throw Exception(errorData['message'] ?? 'Backend login failed');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      log('Firebase authentication error: ${e.message}');
      setState(() {
        _errorMessage = e.message ?? 'Firebase authentication failed';
      });
    } catch (e) {
      log('General error: $e');
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      authProvider.setLoading(false);
    }
  }

  void _resetPassword() {
    // TODO: Implement password reset functionality
    // This is a placeholder for the actual implementation
    _showSnackBar('Password reset functionality is not implemented yet');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Color(0xFF4ECDC4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
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
                Center(
                  child: SvgPicture.asset('assets/svg/logo.svg', height: 60),
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  'Login',
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Welcome back to your fitness journey',
                  style: TextStyle(color: Color(0xFF718096), fontSize: 16),
                ),
                SizedBox(height: 32),

                // Email field
                _buildLabel('Email Address'),
                SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: 24),

                // Password field
                _buildLabel('Password'),
                SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Color(0xFF2D3748), fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 16,
                    ),
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
                      borderSide: BorderSide(
                        color: Color(0xFF4ECDC4),
                        width: 2,
                      ),
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
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF9CA3AF)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Color(0xFF9CA3AF),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resetPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF4ECDC4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Login button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4ECDC4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24),

                // Signup link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(color: Color(0xFF718096), fontSize: 16),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.signup,
                              );
                            },
                            child: Text(
                              'Sign Up',
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
    IconData? prefixIcon,
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
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Color(0xFF9CA3AF))
            : null,
      ),
    );
  }
}
