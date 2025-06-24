import 'package:gym_app_user_1/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:gym_app_user_1/providers/profile_data_provider.dart';
import 'package:gym_app_user_1/providers/auth_provider.dart';

import 'meals_screen.dart';
import 'workouts_screen.dart';
import 'progress_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _HomeTab(),
    MealsScreen(),
    WorkoutsScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  final List<String> _pageTitles = [
    'Home',
    'Meals',
    'Workouts',
    'Progress',
    'Profile',
  ];

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
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(
          _pageTitles[_selectedIndex],
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF181818),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF2D5BFF)),
              accountName: Text(
                'Alex',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text('alex@email.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF2D5BFF), size: 40),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home_rounded, color: Colors.white),
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () => _onDrawerItemTapped(0),
              selected: _selectedIndex == 0,
              selectedTileColor: Color(0xFF232323),
            ),
            ListTile(
              leading: Icon(Icons.fastfood_rounded, color: Colors.white),
              title: Text('Meals', style: TextStyle(color: Colors.white)),
              onTap: () => _onDrawerItemTapped(1),
              selected: _selectedIndex == 1,
              selectedTileColor: Color(0xFF232323),
            ),
            ListTile(
              leading: Icon(Icons.directions_run_rounded, color: Colors.white),
              title: Text('Workouts', style: TextStyle(color: Colors.white)),
              onTap: () => _onDrawerItemTapped(2),
              selected: _selectedIndex == 2,
              selectedTileColor: Color(0xFF232323),
            ),
            ListTile(
              leading: Icon(Icons.trending_up_rounded, color: Colors.white),
              title: Text('Progress', style: TextStyle(color: Colors.white)),
              onTap: () => _onDrawerItemTapped(3),
              selected: _selectedIndex == 3,
              selectedTileColor: Color(0xFF232323),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_rounded, color: Colors.white),
              title: Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () => _onDrawerItemTapped(4),
              selected: _selectedIndex == 4,
              selectedTileColor: Color(0xFF232323),
            ),
            Divider(color: Colors.grey[700]),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.white),
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                // TODO: Implement settings navigation
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Settings coming soon!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () async {
                Navigator.pop(context);
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
                  final authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                }
              },
            ),
          ],
        ),
      ),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF121212),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
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
            icon: Icon(Icons.directions_run_rounded),
            label: 'Workouts',
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
}

// The original Home tab content as a separate widget
class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 30),
            _buildNutritionOverview(),
            SizedBox(height: 30),
            _buildProfileCompletionSteps(context),
            SizedBox(height: 30),
            _buildMealCategories(),
            SizedBox(height: 30),
            _buildTodaysMeals(),
            SizedBox(height: 30),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Alex',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionOverview() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D5BFF), Color(0xFF1A42CC)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2D5BFF).withOpacity(0.3),
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
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '2,450 kcal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildNutrientBar('Protein', 0.7, Color(0xFF00FF88)),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildNutrientBar('Carbs', 0.5, Color(0xFFFFAA00)),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildNutrientBar('Fats', 0.3, Color(0xFFFF5555)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientBar(String label, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
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
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
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
            color: Colors.white,
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
                            ? Color(0xFF00FF88)
                            : isCurrent
                            ? Color(0xFF2D5BFF)
                            : Color(0xFF232323),
                        child: Icon(
                          steps[index]['icon'] as IconData,
                          color: isCompleted || isCurrent
                              ? Colors.white
                              : Colors.grey[500],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        steps[index]['label'] as String,
                        style: TextStyle(
                          color: isCompleted || isCurrent
                              ? Colors.white
                              : Colors.grey[500],
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
                          ? Color(0xFF00FF88)
                          : Color(0xFF232323),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMealCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meal Categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF2D5BFF),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryCard(
                'Pre-Workout',
                Icons.fitness_center,
                Color(0xFF00FF88),
                '12 meals',
              ),
              SizedBox(width: 16),
              _buildCategoryCard(
                'Post-Workout',
                Icons.sports_gymnastics,
                Color(0xFFFFAA00),
                '18 meals',
              ),
              SizedBox(width: 16),
              _buildCategoryCard(
                'High Protein',
                Icons.emoji_food_beverage,
                Color(0xFFFF5555),
                '24 meals',
              ),
              SizedBox(width: 16),
              _buildCategoryCard(
                'Low Carb',
                Icons.eco,
                Color(0xFF9C27B0),
                '15 meals',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    String title,
    IconData icon,
    Color color,
    String count,
  ) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(count, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTodaysMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Meals',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        _buildMealCard(
          'Breakfast',
          'Protein Pancakes',
          '420 kcal',
          Icons.free_breakfast,
          true,
        ),
        SizedBox(height: 12),
        _buildMealCard(
          'Lunch',
          'Grilled Chicken Salad',
          '380 kcal',
          Icons.lunch_dining,
          true,
        ),
        SizedBox(height: 12),
        _buildMealCard(
          'Dinner',
          'Salmon & Vegetables',
          '520 kcal',
          Icons.dinner_dining,
          false,
        ),
        SizedBox(height: 12),
        _buildMealCard(
          'Snack',
          'Protein Smoothie',
          '180 kcal',
          Icons.local_cafe,
          false,
        ),
      ],
    );
  }

  Widget _buildMealCard(
    String mealType,
    String mealName,
    String calories,
    IconData icon,
    bool completed,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: completed
                  ? Color(0xFF00FF88).withOpacity(0.1)
                  : Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: completed ? Color(0xFF00FF88) : Colors.grey[400],
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
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  mealName,
                  style: TextStyle(
                    color: Colors.white,
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
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (completed)
                Icon(Icons.check_circle, color: Color(0xFF00FF88), size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Meal Planner',
                Icons.calendar_today,
                Color(0xFF2D5BFF),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                'Grocery List',
                Icons.shopping_cart,
                Color(0xFF00FF88),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Recipe Search',
                Icons.search,
                Color(0xFFFFAA00),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                'Nutrition Log',
                Icons.bar_chart,
                Color(0xFFFF5555),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder ProfileScreen
class _ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
