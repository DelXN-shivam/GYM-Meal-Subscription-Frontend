import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';
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

  // Future<void> setData() async {
  //   log("Call to set data in login");
  //   final profileProvider = Provider.of<ProfileDataProvider>(
  //     context,
  //     listen: false,
  //   );
  //   // Fetch user data from API and update profile provider
  //   final localStorage = LocalStorageService();
  //   final mongoId = await localStorage.getMongoId();
  //   if (mongoId != null && mongoId.isNotEmpty) {
  //     log("fetching URL");
  //     final url =
  //         'https://gym-meal-subscription-backend.vercel.app/api/v1/user/get/$mongoId';
  //     try {
  //       final response = await http.get(Uri.parse(url));
  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);
  //         if (data['user'] != null) {
  //           log("Data filling in profile provider");
  //           profileProvider.updateFromUserJson(data['user']);
  //           log("Data field in profile provider");
  //         }
  //       }
  //     } catch (e) {
  //       // Handle error (optional: show error or log)
  //     }
  //   }
  // }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.setLoading(true);
    setState(() {
      _errorMessage = null;
    });
    // final profileProvider = Provider.of<ProfileDataProvider>(
    //   context,
    //   listen: false,
    // );

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
        log("Storing data in Profile provider");
        // if (responseData['user'] != null) {
        // profileProvider.updateFromUserJson(responseData['user']);
        // }

        // Store user data in auth provider
        await authProvider.setUserData(
          context: context,
          firebaseUser: userCredential.user!,
          backendUserData: responseData['data']['user'],
        );

        // Fetch and update profile data from backend before navigating to home
        try {
          final localStorage = LocalStorageService();
          final mongoId = await localStorage.getMongoId();
          if (mongoId != null && mongoId.isNotEmpty) {
            final url =
                'https://gym-meal-subscription-backend.vercel.app/api/v1/user/get/$mongoId';
            final response = await http.get(Uri.parse(url));
            if (response.statusCode == 200) {
              final data = json.decode(response.body);
              if (data['user'] != null) {
                Provider.of<ProfileDataProvider>(
                  context,
                  listen: false,
                ).updateFromUserJson(data['user']);
              }
            } else {
              print('Failed to fetch user: $response.statusCode');
            }
          }
        } catch (e) {
          print('Error in profile refresh after login: $e');
        }

        // await setData();

        // Navigate to next page
        Navigator.pushReplacementNamed(context, AppRoutes.home);
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
              context: context,
              firebaseUser: userCredential.user!,
              backendUserData: responseData['data']['user'],
            );
            // Navigate to next page
            Navigator.pushReplacementNamed(context, AppRoutes.home);
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
    _showSnackBar('Password reset functionality is not implemented yet');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                  'Welcome Back',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in to continue your fitness journey',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 40),

                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                ],

                // Email field
                _buildLabel('Email Address'),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Password field
                _buildLabel('Password'),
                SizedBox(height: 12),
                _buildPasswordField(),
                SizedBox(height: 16),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resetPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Login button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, _) => ElevatedButton(
                      onPressed: authProvider.isLoading ? null : _login,
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
                      child: authProvider.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Sign In',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Theme.of(context).dividerColor),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Theme.of(context).dividerColor),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                // Signup link
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 16,
                      ),
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
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
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
        color: Theme.of(context).colorScheme.onBackground,
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
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontSize: 16,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(20),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              )
            : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontSize: 16,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(20),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
    );
  }
}
