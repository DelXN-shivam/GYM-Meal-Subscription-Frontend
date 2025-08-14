import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gym_app_user_1/config/routes.dart';
import 'package:gym_app_user_1/screens/profile/edit_profile.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';
import 'package:gym_app_user_1/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _username;
  String? _email;
  String? _mongoId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final localStorage = LocalStorageService();
      final username = await localStorage.getUsername();
      final email = await localStorage.getMongoEmail();
      setState(() {
        _username = username;
        _email = email;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _username = null;
        _email = null;
        _loading = false;
      });
      // Optionally log error
    }
  }

  Future<void> _refreshProfileData() async {
    try {
      await _loadUserInfo(); // reload local info
      final localStorage = LocalStorageService();
      final mongoId = await localStorage.getMongoId();
      if (mongoId != null && mongoId.isNotEmpty) {
        final url =
            'https://gym-meal-subscription-backend.vercel.app/api/v1/user/get/$mongoId';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          log("Data on Profile Refresh:- $data");
          if (data['user'] != null) {
            if (mounted) {
              Provider.of<ProfileDataProvider>(
                context,
                listen: false,
              ).updateFromUserJson(data['user']);
            }
          }
        } else {
          print('Failed to fetch user: ${response.statusCode}');
        }
      }
    } catch (e, stack) {
      print('Error in _refreshProfileData: $e');
      print(stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileDataProvider>(context, listen: true);
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: RefreshIndicator(
        onRefresh: _refreshProfileData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 20),
                // _buildProfileCompletionStatus(context),
                // SizedBox(height: 20),
                // Enhanced Profile Image Block
                Center(
                  child: Stack(
                    children: [
                      // Gradient border
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.18),
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Edit icon
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.18),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // Personal Info Card
                _ProfileSectionCard(
                  title: 'Personal Info',
                  icon: Icons.person,
                  children: [
                    _ProfileInfoRow(
                      label: 'Name',
                      value: profile.fullName ?? 'No Name',
                      icon: Icons.person_outline,
                    ),
                    _ProfileInfoRow(
                      label: 'Email',
                      value: profile.email ?? 'No Email',
                      icon: Icons.email_outlined,
                    ),
                    _ProfileInfoRow(
                      label: 'Phone',
                      value: profile.phoneNumber ?? 'No Phone',
                      icon: Icons.phone_outlined,
                    ),
                    _ProfileInfoRow(
                      label: 'Gender',
                      value: profile.gender ?? 'Not specified',
                      icon: Icons.male,
                    ),
                    _ProfileInfoRow(
                      label: 'Age',
                      value: profile.age?.toString(),
                      icon: Icons.cake_outlined,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Addresses Card
                _ProfileSectionCard(
                  title: 'Addresses',
                  icon: Icons.location_on,
                  children: [
                    _ProfileInfoRow(
                      label: 'Home',
                      value: profile.homeAddress,
                      icon: Icons.home_outlined,
                    ),
                    _ProfileInfoRow(
                      label: 'Office',
                      value: profile.officeAddress,
                      icon: Icons.business_outlined,
                    ),
                    _ProfileInfoRow(
                      label: 'College',
                      value: profile.collegeAddress,
                      icon: Icons.school_outlined,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Health Card
                _ProfileSectionCard(
                  title: 'Health',
                  icon: Icons.monitor_heart,
                  children: [
                    _ProfileInfoRow(
                      label: 'Height',
                      value: profile.height != null
                          ? '${profile.height} cm'
                          : null,
                      icon: Icons.height,
                    ),
                    _ProfileInfoRow(
                      label: 'Weight',
                      value: profile.weight != null
                          ? '${profile.weight} kg'
                          : null,
                      icon: Icons.monitor_weight,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Preferences Card
                _ProfileSectionCard(
                  title: 'Preferences',
                  icon: Icons.tune,
                  children: [
                    if (profile.dietaryPreference != null &&
                        profile.dietaryPreference!.isNotEmpty)
                      _ProfileChipsRow(
                        label: 'Diet',
                        values: profile.dietaryPreference!,
                      ),
                    if (profile.allergies.isNotEmpty)
                      _ProfileChipsRow(
                        label: 'Allergies',
                        values: profile.allergies,
                      ),
                    _ProfileInfoRow(
                      label: 'Activity Level',
                      value: profile.activityLevel,
                      icon: Icons.directions_run,
                    ),
                    _ProfileInfoRow(
                      label: 'Fitness Goal',
                      value: profile.goal,
                      icon: Icons.flag_outlined,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Meal Plan Card
                _ProfileSectionCard(
                  title: 'Meal Plan',
                  icon: Icons.restaurant,
                  children: [
                    _ProfileInfoRow(
                      label: 'Meals per Day',
                      value: profile.mealsPerDay?.toString(),
                      icon: Icons.fastfood_outlined,
                    ),
                    if (profile.selectedMealTypes.isNotEmpty)
                      _ProfileChipsRow(
                        label: 'Meal Types',
                        values: profile.selectedMealTypes,
                      ),
                    _ProfileInfoRow(
                      label: 'Number of Days',
                      value: profile.planDuration?.toString(),
                      icon: Icons.calendar_today_outlined,
                    ),
                    if (profile.mealPlanType != null)
                      _ProfileChipsRow(
                        label: 'Meal Duration',
                        values: [profile.mealPlanType!],
                      ),
                  ],
                ),
                SizedBox(height: 24),
                // _buildSettingsSection(context),
                // SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Manage your account & settings',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.additionalDetails),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Icon(
              Icons.edit_note,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCompletionStatus(BuildContext context) {
    final provider = Provider.of<ProfileDataProvider>(context, listen: true);
    final percent = provider.profileCompletionPercent;
    final currentStep = provider.currentProfileStep;
    final steps = [
      {'label': 'Signup', 'icon': Icons.person_add_alt_1},
      {'label': 'Details', 'icon': Icons.info_outline},
      {'label': 'Preferences', 'icon': Icons.tune},
      {'label': 'Sample Meal', 'icon': Icons.restaurant_menu},
      {'label': 'Subscription', 'icon': Icons.subscriptions},
      {'label': 'Plan', 'icon': Icons.assignment_turned_in},
      {'label': 'Completed', 'icon': Icons.check_circle},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Completion',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Container(
              height: 10,
              width: MediaQuery.of(context).size.width * percent,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(percent * 100).toInt()}% completed',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 14,
              ),
            ),
            Text(
              steps[currentStep.clamp(0, steps.length - 1)]['label'] as String,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(steps.length, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              return Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : isCurrent
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        child: Icon(
                          steps[index]['icon'] as IconData,
                          size: 16,
                          color: isCompleted || isCurrent
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        steps[index]['label'] as String,
                        style: TextStyle(
                          color: isCompleted || isCurrent
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (index != steps.length - 1)
                    Container(
                      width: 18,
                      height: 2,
                      color: isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&crop=face',
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            _loading ? '...' : (_username ?? 'User'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _loading ? '...' : (_email ?? ''),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildContactItem(
                  Icons.message,
                  'jamieNelson234',
                  Theme.of(context).colorScheme.primary,
                  context,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildContactItem(
                  Icons.phone,
                  '+91-8134258374',
                  Theme.of(context).colorScheme.primary,
                  context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String text,
    Color color,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '85 Kg',
                  'Current Weight',
                  Icons.monitor_weight,
                  Theme.of(context).colorScheme.primary,
                  context,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '1/3',
                  'Current Workout',
                  Icons.fitness_center,
                  Theme.of(context).colorScheme.secondary,
                  context,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Apr 01',
                  'Latest Progress',
                  Icons.photo_camera,
                  Theme.of(context).colorScheme.error,
                  context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetrics(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Metrics',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  'Sep 05',
                  'Latest Measurement',
                  Icons.straighten,
                  context,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMetricItem(
                  '0',
                  'Steps Today',
                  Icons.directions_walk,
                  context,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMetricItem(
                  '120 bpm',
                  'Heart Rate',
                  Icons.favorite,
                  context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String value,
    String label,
    IconData icon,
    BuildContext context,
  ) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutProgress(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Workout Plan',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '2',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildWorkoutProgressItem(
            'Morning Workout',
            '0/5',
            Theme.of(context).colorScheme.primary,
            Icons.wb_sunny,
            context,
          ),
          SizedBox(height: 12),
          _buildWorkoutProgressItem(
            'Cardio Workout',
            '2/6',
            Theme.of(context).colorScheme.secondary,
            Icons.directions_run,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutProgressItem(
    String title,
    String progress,
    Color color,
    IconData icon,
    BuildContext context,
  ) {
    final parts = progress.split('/');
    final current = int.parse(parts[0]);
    final total = int.parse(parts[1]);
    final percentage = current / total;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              progress,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final settings = [
      {
        'icon': Icons.notifications,
        'title': 'Notifications',
        'subtitle': 'Manage your alerts',
      },
      {
        'icon': Icons.privacy_tip,
        'title': 'Privacy',
        'subtitle': 'Control your data',
      },
      {
        'icon': Icons.help,
        'title': 'Help & Support',
        'subtitle': 'Get assistance',
      },
      {
        'icon': Icons.logout,
        'title': 'Logout',
        'subtitle': 'Sign out of your account',
      },
    ];
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: settings.length,
            itemBuilder: (context, index) {
              final item = settings[index];
              return _buildSettingsItem(
                item['icon'] as IconData,
                item['title'] as String,
                item['subtitle'] as String,
                context,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String subtitle,
    BuildContext context,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Handle settings item tap
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  size: 20,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Enhanced Helper Widgets for new UI ---

class _ProfileSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _ProfileSectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.13),
            Theme.of(context).colorScheme.secondary.withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.09),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ..._addDividers(children),
        ],
      ),
    );
  }

  List<Widget> _addDividers(List<Widget> children) {
    final List<Widget> result = [];
    for (int i = 0; i < children.length; i++) {
      if (i > 0) {
        result.add(Divider(height: 18, thickness: 0.7));
      }
      result.add(children[i]);
    }
    return result;
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final IconData? icon;
  const _ProfileInfoRow({required this.label, required this.value, this.icon});
  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ),
            SizedBox(width: 8),
          ],
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileChipsRow extends StatelessWidget {
  final String label;
  final List<String> values;
  const _ProfileChipsRow({required this.label, required this.values});
  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.label_important_outline,
            size: 16,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          SizedBox(width: 6),
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Wrap(
              spacing: 7,
              runSpacing: 5,
              children: values
                  .map(
                    (v) => Chip(
                      label: Text(
                        v,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.25),
                        ),
                      ),
                      elevation: 1,
                      shadowColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.10),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
