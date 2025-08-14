import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/auth_provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';
import 'package:gym_app_user_1/services/local_storage_service.dart';

class NextPage extends StatefulWidget {
  const NextPage({Key? key}) : super(key: key);

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  final LocalStorageService _localStorageService = LocalStorageService();
  Map<String, dynamic> _localStorageData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocalStorageData();
  }

  Future<void> _loadLocalStorageData() async {
    try {
      final isLoggedIn = await _localStorageService.isLoggedIn();
      final userId = await _localStorageService.getUserId();
      final username = await _localStorageService.getUsername();
      final mongoId = await _localStorageService.getMongoId();
      final mongoEmail = await _localStorageService.getMongoEmail();

      setState(() {
        _localStorageData = {
          'isLoggedIn': isLoggedIn,
          'userId': userId,
          'username': username,
          'mongoId': mongoId,
          'mongoEmail': mongoEmail,
        };
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading local storage data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Logout'),
              ),
            ],
          );
        },
      );

      if (shouldLogout == true) {
        // Get the auth provider and call logout
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final profileProvider = Provider.of<ProfileDataProvider>(
          context,
          listen: false,
        );
        await authProvider.logout();
        profileProvider.clearAllData();

        // Navigate back to login screen
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => true);
        }
      }
    } catch (e) {
      print('Error during logout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final firebaseUser = authProvider.firebaseUser;
        final backendUserData = authProvider.backendUserData;

        return Scaffold(
          appBar: AppBar(title: const Text('Welcome')),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Firebase User Info:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('UID: ${firebaseUser?.uid ?? 'N/A'}'),
                        Text('Email: ${firebaseUser?.email ?? 'N/A'}'),
                        const SizedBox(height: 20),
                        const Text(
                          'Backend User Info:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('ID: ${backendUserData?['mongoId'] ?? 'N/A'}'),
                        Text('Name: ${backendUserData?['name'] ?? 'N/A'}'),
                        Text(
                          'Email: ${backendUserData?['mongoEmail'] ?? 'N/A'}',
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Local Storage Data:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._localStorageData.entries
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2.0,
                                ),
                                child: Text(
                                  '${entry.key}: ${entry.value ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _loadLocalStorageData,
                                child: const Text('Refresh Local Storage Data'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _handleLogout,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Logout'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
