import 'package:flutter/material.dart';
import 'package:gym_app_user_1/constants.dart';
import 'package:gym_app_user_1/providers/auth_provider.dart';
import 'package:gym_app_user_1/providers/meal_plan_provider.dart';
import 'package:gym_app_user_1/screens/profile/profile_screen.dart';
import 'package:gym_app_user_1/screens/subscription/subscription_screen.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:gym_app_user_1/services/local_storage_service.dart';
import 'package:gym_app_user_1/config/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat();
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabAnimationController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final mealPlanProvider = Provider.of<MealPlanProvider>(
      context,
      listen: false,
    );

    if (authProvider.user != null) {
      await mealPlanProvider.loadUserMealPlan(authProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final mealPlanProvider = Provider.of<MealPlanProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      backgroundColor: const Color(0xFF0F0F23),
      drawer: _buildGlassmorphicDrawer(authProvider),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            // colors: [
            //   Color(0xFF6E6E80), // Dusty Gray (mid base tone)
            //   Color(0xFF5A5A70), // Dim Slate Gray
            //   Color(0xFF46465C), // Muted Dark Bluish Gray
            // ],
            colors: [
              Color(0xFFF3F3F8), // Light Grayish White
              Color(0xFFE9E9F0), // Slightly Deeper White
              Color(0xFFE0E0EA), // Subtle Cool White
              // Colors.white,
              // Colors.white,
            ],
          ),
        ),
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeTab(authProvider, mealPlanProvider),
            _buildMealPlanTab(),
            _buildSubscriptionTab(),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationBar(),
      floatingActionButton: _selectedIndex == 0 ? _buildQuantumFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildGlassmorphicDrawer(AuthProvider authProvider) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: BackdropFilter(
            filter: const ColorFilter.mode(
              Colors.transparent,
              BlendMode.multiply,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF6C63FF).withOpacity(0.1),
                    const Color(0xFF3F3FFF).withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Futuristic Header
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF6C63FF).withOpacity(0.3),
                          const Color(0xFF3F3FFF).withOpacity(0.2),
                          const Color(0xFF1A1A2E).withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        // Animated Profile Ring
                        AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationController.value * 2 * math.pi,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF6C63FF),
                                      const Color(0xFF3F3FFF),
                                      const Color(0xFF00D4FF),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.05),
                                        ],
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage:
                                          authProvider.user?.photoURL != null
                                          ? NetworkImage(
                                              authProvider.user!.photoURL!,
                                            )
                                          : null,
                                      child: authProvider.user?.photoURL == null
                                          ? const Icon(
                                              Icons.person_rounded,
                                              size: 40,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        // Glowing Name
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF6C63FF).withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6C63FF).withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            authProvider.user?.displayName ?? 'Neo User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF6C63FF),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          authProvider.user?.email ?? 'neo@matrix.com',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Cyber Menu Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children: [
                        _buildCyberMenuItem(
                          Icons.dashboard_rounded,
                          'Neural Dashboard',
                          () => Navigator.pop(context),
                        ),
                        _buildCyberMenuItem(
                          Icons.restaurant_menu_rounded,
                          'Nutrition Matrix',
                          () => Navigator.pop(context),
                        ),
                        _buildCyberMenuItem(
                          Icons.fitness_center_rounded,
                          'Training Protocol',
                          () => Navigator.pop(context),
                        ),
                        _buildCyberMenuItem(
                          Icons.analytics_rounded,
                          'Bio Analytics',
                          () => Navigator.pop(context),
                        ),
                        _buildCyberMenuItem(
                          Icons.shopping_cart_rounded,
                          'Supply Orders',
                          () => Navigator.pop(context),
                        ),
                        _buildCyberMenuItem(
                          Icons.subscriptions_rounded,
                          'Premium Access',
                          () => Navigator.pop(context),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                const Color(0xFF6C63FF).withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildCyberMenuItem(
                          Icons.settings_rounded,
                          'System Config',
                          () => Navigator.pop(context),
                        ),
                        _buildCyberMenuItem(
                          Icons.help_rounded,
                          'Support Matrix',
                          () => Navigator.pop(context),
                        ),
                        _buildCyberMenuItem(
                          Icons.logout_rounded,
                          'Disconnect',
                          () async {
                            // Clear local storage data
                            await LocalStorageService().clearLoginData();
                            // Navigate back to login screen
                            if (mounted) {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.login,
                              );
                            }
                          },
                          isDestructive: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCyberMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isDestructive
                    ? Colors.red.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: isDestructive
                          ? [
                              Colors.red.withOpacity(0.2),
                              Colors.red.withOpacity(0.1),
                            ]
                          : [
                              const Color(0xFF6C63FF).withOpacity(0.2),
                              const Color(0xFF3F3FFF).withOpacity(0.1),
                            ],
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? Colors.red : Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDestructive ? Colors.red : Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey, width: 2),
        boxShadow: [
          BoxShadow(
            // color: const Color(0xFF6C63FF).withOpacity(0.3),
            color: Colors.white,
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: const ColorFilter.mode(Colors.green, BlendMode.multiply),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
              if (index == 0) {
                _fabAnimationController.forward();
              } else {
                _fabAnimationController.reverse();
              }
            },
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            indicatorColor: navBarTertiaryColor.withOpacity(0.8),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            height: 70,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Colors.black),
                selectedIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [navBarSecondaryColor, navBarPrimaryColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                label: 'Neural Hub',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.restaurant_menu_outlined,
                  // color: Colors.white.withOpacity(0.6),
                  color: Colors.black,
                ),
                selectedIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [navBarSecondaryColor, navBarPrimaryColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: navBarTertiaryColor.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                label: 'Nutrition',
              ),
              NavigationDestination(
                icon: Icon(Icons.subscriptions_outlined, color: Colors.black),
                selectedIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [navBarSecondaryColor, navBarPrimaryColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.subscriptions_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                label: 'Premium',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded, color: Colors.black),
                selectedIcon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [navBarSecondaryColor, navBarPrimaryColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: navBarTertiaryColor.withOpacity(0.9),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantumFAB() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.1),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.8),
                  const Color(0xFF3F3FFF).withOpacity(0.6),
                  Colors.transparent,
                ],
                stops: [0.0, 0.7, 1.0],
              ),
            ),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.profile);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [navBarSecondaryColor, navBarPrimaryColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: navBarTertiaryColor.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeTab(
    AuthProvider authProvider,
    MealPlanProvider mealPlanProvider,
  ) {
    return CustomScrollView(
      slivers: [
        // Cyberpunk App Bar
        SliverAppBar(
          expandedHeight: 180,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.8),
                  const Color(0xFF3F3FFF).withOpacity(0.6),
                  const Color(0xFF1A1A2E).withOpacity(0.4),
                ],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
                ),
              ),
            ),
          ),
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: const Icon(Icons.menu_rounded, color: Colors.white),
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: authProvider.user?.photoURL != null
                        ? Image.network(
                            authProvider.user!.photoURL!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to the Matrix,',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authProvider.user?.displayName?.split(' ').first ??
                              'Neo',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Color(0xFF6C63FF), blurRadius: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + (_pulseController.value * 0.05),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: const Color(0xFF00D4FF).withOpacity(0.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00D4FF).withOpacity(0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.notifications_active_rounded,
                                color: const Color(0xFF00D4FF),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '3',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        // Content
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Quantum Summary
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildQuantumSummaryCard(mealPlanProvider),
                ),
              ),
              const SizedBox(height: 30),
              // Neural Actions
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildNeuralActions(),
              ),
              const SizedBox(height: 30),
              // Bio Rhythms
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildBioRhythms(),
              ),
              const SizedBox(height: 120),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantumSummaryCard(MealPlanProvider mealPlanProvider) {
    final mealPlan = mealPlanProvider.currentMealPlan;
    final userMetrics = mealPlanProvider.userMetrics;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: const ColorFilter.mode(
            Colors.transparent,
            BlendMode.multiply,
          ),
          child: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [navBarSecondaryColor, navBarPrimaryColor],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.5),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.analytics_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Neural Analytics',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'System operating at peak performance',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuantumMetric(
                        icon: Icons.local_fire_department_rounded,
                        label: 'Energy Core',
                        value:
                            '${mealPlan?['dailyCalories']?.toStringAsFixed(0) ?? '2450'}',
                        unit: 'kcal',
                        progress: 0.75,
                        color: const Color(0xFFFF6B6B),
                      ),
                    ),
                    Expanded(
                      child: _buildQuantumMetric(
                        icon: Icons.fitness_center_rounded,
                        label: 'Protein Matrix',
                        value:
                            '${mealPlan?['macros']?['protein']?.toStringAsFixed(0) ?? '120'}',
                        unit: 'g',
                        progress: 0.85,
                        color: const Color(0xFF4ECDC4),
                      ),
                    ),
                    Expanded(
                      child: _buildQuantumMetric(
                        icon: Icons.monitor_weight_rounded,
                        label: 'Bio Mass',
                        value:
                            '${userMetrics?['weight']?.toStringAsFixed(1) ?? '75.5'}',
                        unit: 'kg',
                        progress: 0.65,
                        color: const Color(0xFF45B7D1),
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

  Widget _buildQuantumMetric({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required double progress,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white.withOpacity(0.1),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.5), blurRadius: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeuralActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.3),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.flash_on_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            const Text(
              'Quick Actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _buildActionCard(
              icon: Icons.restaurant_menu_rounded,
              title: 'Today\'s Menu',
              subtitle: 'Neural nutrition plan',
              gradient: [const Color(0xFF6C63FF), const Color(0xFF3F3FFF)],
              onTap: () {},
            ),
            _buildActionCard(
              icon: Icons.fitness_center_rounded,
              title: 'Training Mode',
              subtitle: 'Activate workout',
              gradient: [const Color(0xFFFF6B6B), const Color(0xFFEE5A52)],
              onTap: () {},
            ),
            _buildActionCard(
              icon: Icons.shopping_cart_rounded,
              title: 'Supply Drop',
              subtitle: 'Order supplements',
              gradient: [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
              onTap: () {},
            ),
            _buildActionCard(
              icon: Icons.analytics_rounded,
              title: 'Progress Scan',
              subtitle: 'View bio data',
              gradient: [const Color(0xFFFFD93D), const Color(0xFF6BCF7F)],
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        // Responsive sizing calculations
        final isSmallScreen = screenWidth < 360;
        final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
        final isTablet = screenWidth >= 600;

        // Dynamic padding based on screen size
        final cardPadding = isSmallScreen
            ? EdgeInsets.all(screenWidth * 0.035)
            : isMediumScreen
            ? EdgeInsets.all(screenWidth * 0.04)
            : EdgeInsets.all(screenWidth * 0.025);

        // Dynamic border radius
        final borderRadius = isSmallScreen
            ? 16.0
            : isTablet
            ? 24.0
            : 20.0;

        // Dynamic icon container size and padding
        final iconContainerSize = isSmallScreen
            ? screenWidth * 0.10
            : isMediumScreen
            ? screenWidth * 0.09
            : screenWidth * 0.07;

        final iconSize = isSmallScreen
            ? screenWidth * 0.05
            : isMediumScreen
            ? screenWidth * 0.045
            : screenWidth * 0.035;

        // Dynamic text sizes
        final titleFontSize = isSmallScreen
            ? screenWidth * 0.035
            : isMediumScreen
            ? screenWidth * 0.038
            : screenWidth * 0.030;

        final subtitleFontSize = isSmallScreen
            ? screenWidth * 0.030
            : isMediumScreen
            ? screenWidth * 0.032
            : screenWidth * 0.025;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withOpacity(0.2),
                blurRadius: isTablet ? 20 : 15,
                spreadRadius: isTablet ? 2 : 1,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(
                padding: cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
                    Container(
                      width: iconContainerSize,
                      height: iconContainerSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          borderRadius * 0.75,
                        ),
                        gradient: LinearGradient(colors: gradient),
                        boxShadow: [
                          BoxShadow(
                            color: gradient.first.withOpacity(0.5),
                            blurRadius: isTablet ? 12 : 10,
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: iconSize),
                    ),

                    // Flexible spacer that takes available space
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Title with flexible sizing
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                height: 1.2, // Line height for better spacing
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Small spacing
                          SizedBox(height: screenWidth * 0.01),

                          // Subtitle with flexible sizing
                          Flexible(
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: subtitleFontSize,
                                height:
                                    1.3, // Line height for better readability
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBioRhythms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.3),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.timeline_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 15),
            const Text(
              'Bio Rhythms',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: const ColorFilter.mode(
                Colors.transparent,
                BlendMode.multiply,
              ),
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    _buildBioRhythmItem(
                      label: 'Hydration Level',
                      value: '78%',
                      progress: 0.78,
                      color: const Color(0xFF00D4FF),
                      icon: Icons.water_drop_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildBioRhythmItem(
                      label: 'Energy Status',
                      value: '92%',
                      progress: 0.92,
                      color: const Color(0xFFFFD93D),
                      icon: Icons.battery_charging_full_rounded,
                    ),
                    const SizedBox(height: 20),
                    _buildBioRhythmItem(
                      label: 'Recovery Rate',
                      value: '85%',
                      progress: 0.85,
                      color: const Color(0xFF4ECDC4),
                      icon: Icons.healing_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioRhythmItem({
    required String label,
    required String value,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
            ),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white.withOpacity(0.1),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                      boxShadow: [
                        BoxShadow(color: color.withOpacity(0.5), blurRadius: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealPlanTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
          ),
          child: Column(
            children: [
              Text(
                'Nutrition Matrix - Coming Soon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Nutrition Matrix - Coming Soon',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionTab() {
    return SubscriptionScreen();
  }

  Widget _buildProfileTab() {
    return ProfileScreen();
  }
}

// Gray Color for Background
// colors: [
//       Color(0xFF6E6E80), // Lightest among dark
//       Color(0xFF5A5A70), // Mid-point cool gray
//       Color(0xFF46465C), // Darker bluish slate
//     ],
