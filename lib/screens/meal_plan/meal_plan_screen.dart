import 'package:flutter/material.dart';
import 'package:gym_app_user_1/providers/meal_plan_provider.dart';
import 'package:provider/provider.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mealPlanProvider = Provider.of<MealPlanProvider>(context);
    final mealPlan = mealPlanProvider.currentMealPlan;
    final userMetrics = mealPlanProvider.userMetrics;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Your Meal Plan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Breakfast'),
                Tab(text: 'Lunch'),
                Tab(text: 'Dinner'),
              ],
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Nutrition Summary
                _buildNutritionSummary(mealPlan),
                const SizedBox(height: 24),
                // Meal Plan Tabs
                SizedBox(
                  height: 600, // Adjust based on content
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMealTab('Breakfast'),
                      _buildMealTab('Lunch'),
                      _buildMealTab('Dinner'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary(Map<String, dynamic>? mealPlan) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Nutrition',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutritionItem(
                  icon: Icons.local_fire_department,
                  label: 'Calories',
                  value:
                      '${mealPlan?['dailyCalories']?.toStringAsFixed(0) ?? 0}',
                  unit: 'kcal',
                ),
                _buildNutritionItem(
                  icon: Icons.fitness_center,
                  label: 'Protein',
                  value:
                      '${mealPlan?['macros']?['protein']?.toStringAsFixed(0) ?? 0}',
                  unit: 'g',
                ),
                _buildNutritionItem(
                  icon: Icons.grain,
                  label: 'Carbs',
                  value:
                      '${mealPlan?['macros']?['carbs']?.toStringAsFixed(0) ?? 0}',
                  unit: 'g',
                ),
                _buildNutritionItem(
                  icon: Icons.water_drop,
                  label: 'Fat',
                  value:
                      '${mealPlan?['macros']?['fat']?.toStringAsFixed(0) ?? 0}',
                  unit: 'g',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          unit,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildMealTab(String mealType) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Example items
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  'https://picsum.photos/500/300?random=$index',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Meal Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal ${index + 1}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Description of the meal and its nutritional benefits. This is a sample text that would be replaced with actual meal details.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    // Nutrition Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMealNutritionItem('Calories', '350'),
                        _buildMealNutritionItem('Protein', '25g'),
                        _buildMealNutritionItem('Carbs', '45g'),
                        _buildMealNutritionItem('Fat', '12g'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMealActionButton(
                          icon: Icons.favorite_border,
                          label: 'Save',
                          onTap: () {
                            // TODO: Implement save functionality
                          },
                        ),
                        _buildMealActionButton(
                          icon: Icons.restaurant,
                          label: 'Order',
                          onTap: () {
                            // TODO: Implement order functionality
                          },
                        ),
                        _buildMealActionButton(
                          icon: Icons.info_outline,
                          label: 'Details',
                          onTap: () {
                            // TODO: Show meal details
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMealActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
