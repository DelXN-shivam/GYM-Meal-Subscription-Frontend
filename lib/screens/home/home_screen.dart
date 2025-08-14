import 'package:gym_app_user_1/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';
import 'package:gym_app_user_1/providers/auth_provider.dart';
import 'package:gym_app_user_1/providers/theme_provider.dart';
import 'package:gym_app_user_1/services/local_storage_service.dart';

import 'meals_screen.dart';
import 'progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:gym_app_user_1/screens/home/category_products_screen.dart';
import 'package:gym_app_user_1/screens/home/product_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  // User info for drawer
  String? _username;
  String? _email;
  bool _userLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    // Log profile data after splash navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileDataProvider>(
        context,
        listen: false,
      );
      profileProvider.logAllProfileData(pageName: 'HomeScreen');
    });
  }

  @override
  Future<void> _loadUserInfo() async {
    final localStorage = LocalStorageService();
    final username = await localStorage.getUsername();
    final email = await localStorage.getMongoEmail();
    setState(() {
      _username = username;
      _email = email;
      _userLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pop(context); // Close the drawer
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _HomeTab(),
      MealsScreen(),
      // WorkoutsScreen(),
      ProductScreen(),
      ProgressScreen(),
      ProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            // Enhanced Header with gradient and better styling
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Avatar with better styling
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 45,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // User name with shimmer effect for loading
                      _userLoading
                          ? Container(
                              width: 120,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          : Text(
                              _username ?? 'User',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.onPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                      const SizedBox(height: 8),
                      // Email with better styling
                      _userLoading
                          ? Container(
                              width: 160,
                              height: 14,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          : Text(
                              _email ?? '',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            // Navigation Items with improved styling
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    index: 0,
                  ),
                  _buildDrawerItem(
                    icon: Icons.restaurant_rounded,
                    title: 'Meals',
                    index: 1,
                  ),
                  _buildDrawerItem(
                    icon: Icons.shopping_bag,
                    title: 'Products',
                    index: 2,
                  ),
                  _buildDrawerItem(
                    icon: Icons.trending_up_rounded,
                    title: 'Progress',
                    index: 3,
                  ),
                  _buildDrawerItem(
                    icon: Icons.account_circle_rounded,
                    title: 'Profile',
                    index: 4,
                  ),
                  // Elegant divider
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).dividerColor.withOpacity(0.1),
                          Theme.of(context).dividerColor,
                          Theme.of(context).dividerColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                  // Theme toggle with enhanced design
                  _buildThemeToggleItem(),
                  _buildSettingsItem(),
                ],
              ),
            ),
            // Logout button at bottom with distinctive styling
            Container(
              padding: const EdgeInsets.all(16),
              child: _buildLogoutButton(),
            ),
          ],
        ),
      ),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onSurface.withOpacity(0.5),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_rounded),
            label: 'Meals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_rounded),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Helper methods for the enhanced drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16,
          ),
        ),
        onTap: () => _onDrawerItemTapped(index),
        selected: isSelected,
        selectedTileColor: Theme.of(
          context,
        ).colorScheme.primary.withOpacity(0.08),
        hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.04),
      ),
    );
  }

  Widget _buildThemeToggleItem() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeMode = themeProvider.themeMode;

    String themeText;
    IconData themeIcon;

    switch (themeMode) {
      case ThemeMode.light:
        themeText = 'Light';
        themeIcon = Icons.light_mode_rounded;
        break;
      case ThemeMode.dark:
        themeText = 'Dark';
        themeIcon = Icons.dark_mode_rounded;
        break;
      default:
        themeText = 'System';
        themeIcon = Icons.brightness_auto_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            themeIcon,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
        ),
        title: Text(
          'Theme',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          themeText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          size: 20,
        ),
        onTap: () {
          themeProvider.toggleTheme();
        },
        hoverColor: Theme.of(context).colorScheme.secondary.withOpacity(0.04),
      ),
    );
  }

  Widget _buildSettingsItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.settings_rounded,
            color: Theme.of(context).colorScheme.outline,
            size: 24,
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          size: 20,
        ),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Settings coming soon!'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
        hoverColor: Theme.of(context).colorScheme.outline.withOpacity(0.04),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextButton.icon(
        onPressed: () async {
          Navigator.pop(context);
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              final colorScheme = Theme.of(context).colorScheme;
              return Theme(
                data: Theme.of(context).copyWith(
                  dialogBackgroundColor: colorScheme.surface,
                  textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: colorScheme.onSurface,
                    displayColor: colorScheme.onSurface,
                  ),
                  colorScheme: colorScheme,
                ),
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: colorScheme.error,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Confirm Logout',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  content: Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.outline,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          );
          if (shouldLogout == true) {
            final authProvider = Provider.of<AuthProvider>(
              context,
              listen: false,
            );
            final profileProvider = Provider.of<ProfileDataProvider>(
              context,
              listen: false,
            );
            await authProvider.logout();
            profileProvider.clearAllData();
            if (context.mounted) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          }
        },
        icon: Icon(
          Icons.logout_rounded,
          color: Theme.of(context).colorScheme.error,
          size: 20,
        ),
        label: Text(
          'Logout',
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning,';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon,';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening,';
    } else {
      return 'Good Night,';
    }
  }
}

// Replace _HomeTab with a stateful version that loads user info
class _HomeTab extends StatefulWidget {
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  String? _username;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final localStorage = LocalStorageService();
    final username = await localStorage.getUsername();
    setState(() {
      _username = username;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final provider = Provider.of<ProfileDataProvider>(
          context,
          listen: false,
        );
        await provider.refreshProfileData();
        provider.logAllProfileData(pageName: 'HomeScreen (onRefresh)');
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 30),
              _buildNutritionOverview(context),
              SizedBox(height: 30),
              // _buildProfileCompletionSteps(context),
              // SizedBox(height: 30),
              _buildMealCategories(context),
              SizedBox(height: 30),
              _buildTodaysMeals(context),
              SizedBox(height: 30),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting(),
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  _loading ? '...' : (_username ?? 'User'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionOverview(BuildContext context) {
    final profile = Provider.of<ProfileDataProvider>(context, listen: true);
    final calories = profile.recommendedCalories;
    final protein = profile.protein;
    final carbs = profile.carbs;
    final fats = profile.fats;
    final bmr = profile.bmr;
    final tdee = profile.tdee;
    final bmi = profile.bmi;
    final goal = profile.goal;
    final planType = profile.mealPlanType;

    String formatDouble(double? value, {int decimals = 0, String? suffix}) {
      if (value == null) return '--';
      return value.toStringAsFixed(decimals) + (suffix ?? '');
    }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Nutrition',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  formatDouble(calories, decimals: 0, suffix: ' kcal'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildNutrientBar(
                  context,
                  'Protein',
                  (protein ?? 0) / 100,
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildNutrientBar(
                  context,
                  'Carbs',
                  (carbs ?? 0) / 100,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildNutrientBar(
                  context,
                  'Fats',
                  (fats ?? 0) / 100,
                  Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNutritionStat(
                context,
                'BMR',
                formatDouble(bmr, decimals: 0, suffix: ' kcal'),
              ),
              _buildNutritionStat(
                context,
                'TDEE',
                formatDouble(tdee, decimals: 0, suffix: ' kcal'),
              ),
              _buildNutritionStat(
                context,
                'BMI',
                formatDouble(bmi, decimals: 1),
              ),
            ],
          ),
          if (goal != null || planType != null) ...[
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (goal != null) _buildNutritionStat(context, 'Goal', goal),
                if (planType != null)
                  _buildNutritionStat(context, 'Plan', planType),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutrientBar(
    BuildContext context,
    String label,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionStat(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCompletionSteps(BuildContext context) {
    // Define the steps
    final steps = [
      {'label': 'Signup', 'icon': Icons.person_add_alt_1},
      {'label': 'Details', 'icon': Icons.info_outline},
      {'label': 'Preferences', 'icon': Icons.tune},
      {'label': 'Sample Meal', 'icon': Icons.restaurant_menu},
      {'label': 'Subscription', 'icon': Icons.subscriptions},
      {'label': 'Plan', 'icon': Icons.assignment_turned_in},
      {'label': 'Completed', 'icon': Icons.check_circle},
    ];
    final currentStep = Provider.of<ProfileDataProvider>(
      context,
      listen: true,
    ).currentProfileStep;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Completion',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
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
                        radius: 20,
                        backgroundColor: isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : isCurrent
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface,
                        child: Icon(
                          steps[index]['icon'] as IconData,
                          color: isCompleted || isCurrent
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        steps[index]['label'] as String,
                        style: TextStyle(
                          color: isCompleted || isCurrent
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (index != steps.length - 1)
                    Container(
                      width: 32,
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

  Widget _buildMealCategories(BuildContext context) {
    final profile = Provider.of<ProfileDataProvider>(context, listen: true);
    final mealTypes = profile.selectedMealTypes;
    final iconMap = {
      'breakfast': Icons.free_breakfast,
      'lunch': Icons.lunch_dining,
      'dinner': Icons.dinner_dining,
      'snack': Icons.local_cafe,
      // Add more mappings as needed
    };
    final colorMap = {
      'breakfast': Theme.of(context).colorScheme.primary,
      'lunch': Theme.of(context).colorScheme.secondary,
      'dinner': Theme.of(context).colorScheme.error,
      'snack': Theme.of(context).colorScheme.background,
      // Add more mappings as needed
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meal Categories',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Theme.of(
                  context,
                ).colorScheme.onBackground.withOpacity(0.1),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        if (mealTypes.isEmpty)
          Center(
            child: Text(
              'No meal types selected.',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onBackground.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: mealTypes.map((type) {
                final icon = iconMap[type.toLowerCase()] ?? Icons.restaurant;
                final color =
                    colorMap[type.toLowerCase()] ??
                    Theme.of(context).colorScheme.primary;
                return Row(
                  children: [
                    _buildCategoryCard(
                      context,
                      type[0].toUpperCase() + type.substring(1),
                      icon,
                      color,
                      '', // You can add meal count if available
                    ),
                    SizedBox(width: 16),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String count,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 160,
      height: 140,
      margin: EdgeInsets.all(4),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(24),
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryProductsScreen(
                  categoryName: title,
                  presentProducts: [],
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              // 3D gradient background
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        Theme.of(context).colorScheme.surface.withOpacity(0.8),
                        Theme.of(context).colorScheme.surface.withOpacity(0.6),
                      ]
                    : [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surface.withOpacity(0.9),
                      ],
              ),
              borderRadius: BorderRadius.circular(24),

              // 3D shadow effects
              boxShadow: [
                // Main shadow
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.grey.withOpacity(0.2),
                  offset: Offset(6, 6),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
                // Light highlight
                BoxShadow(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.8),
                  offset: Offset(-4, -4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
                // Inner glow
                BoxShadow(
                  color: color.withOpacity(0.1),
                  offset: Offset(0, 0),
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
              ],

              // Subtle border
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon container with enhanced 3D effect
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // Icon background gradient
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),

                    // Icon container shadow
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.white.withOpacity(0.7),
                        offset: Offset(-1, -1),
                        blurRadius: 2,
                        spreadRadius: 0,
                      ),
                    ],

                    // Icon container border
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Icon(icon, color: color.withOpacity(0.8), size: 26),
                ),

                // Text content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        count,
                        style: TextStyle(
                          color: color.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysMeals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced title with subtle shadow
        Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Text(
            'Today\'s Deliveries',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.onBackground.withOpacity(0.1),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),

        // Enhanced meal cards with 3D effects
        _buildEnhancedMealCard(
          context,
          'Breakfast',
          'Protein Pancakes',
          '420 kcal',
          Icons.free_breakfast,
          true,
          Colors.orange,
        ),
        SizedBox(height: 16),

        _buildEnhancedMealCard(
          context,
          'Lunch',
          'Grilled Chicken Salad',
          '380 kcal',
          Icons.lunch_dining,
          true,
          Colors.green,
        ),
        SizedBox(height: 16),

        _buildEnhancedMealCard(
          context,
          'Dinner',
          'Salmon & Vegetables',
          '520 kcal',
          Icons.dinner_dining,
          false,
          Colors.blue,
        ),
        SizedBox(height: 16),

        _buildEnhancedMealCard(
          context,
          'Snack',
          'Protein Smoothie',
          '180 kcal',
          Icons.local_cafe,
          false,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildEnhancedMealCard(
    BuildContext context,
    String mealType,
    String mealName,
    String calories,
    IconData icon,
    bool isCompleted,
    Color accentColor,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // 3D shadow effect
        boxShadow: [
          // Main shadow for depth
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.15),
            offset: Offset(0, 8),
            blurRadius: 16,
            spreadRadius: 0,
          ),
          // Inner highlight for 3D effect
          BoxShadow(
            color: isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.white.withOpacity(0.7),
            offset: Offset(0, 1),
            blurRadius: 0,
            spreadRadius: 0,
          ),
          // Subtle side shadow
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.08),
            offset: Offset(2, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle meal card tap
          },
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surface.withOpacity(0.8),
                      ]
                    : [
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surface.withOpacity(0.95),
                      ],
              ),
              // Inner border for glass effect
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Enhanced icon with background
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accentColor.withOpacity(0.2),
                        accentColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: accentColor.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.2),
                        offset: Offset(0, 2),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: accentColor, size: 28),
                ),

                SizedBox(width: 16),

                // Meal information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealType,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        mealName,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        calories,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status indicator with enhanced design
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isCompleted
                          ? [
                              Colors.green.withOpacity(0.8),
                              Colors.green.withOpacity(0.6),
                            ]
                          : [
                              Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.3),
                              Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.2),
                            ],
                    ),
                    boxShadow: isCompleted
                        ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              offset: Offset(0, 2),
                              blurRadius: 6,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                    border: Border.all(
                      color: isCompleted
                          ? Colors.green.withOpacity(0.4)
                          : Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: isCompleted
                      ? Icon(Icons.check, color: Colors.white, size: 18)
                      : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealCard(
    BuildContext context,
    String mealType,
    String mealName,
    String calories,
    IconData icon,
    bool completed,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: completed
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: completed
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  mealName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                calories,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (completed)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Meal Planner',
                Icons.calendar_today,
                Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                context,
                'Grocery List',
                Icons.shopping_cart,
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Recipe Search',
                Icons.search,
                Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                context,
                'Nutrition Log',
                Icons.bar_chart,
                Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Product List',
                Icons.list_alt,
                Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Top-left light shadow for 3D effect
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            offset: Offset(-2, -2),
            blurRadius: 2,
            spreadRadius: 0,
          ),
          // Bottom-right dark shadow for depth
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            offset: Offset(3, 3),
            blurRadius: 4,
            spreadRadius: 0,
          ),
          // Subtle inner highlight
          BoxShadow(
            color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
            offset: Offset(-1, -1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.1),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning,';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon,';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening,';
    } else {
      return 'Good Night,';
    }
  }
}
