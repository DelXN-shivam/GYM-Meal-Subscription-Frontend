import 'package:flutter/material.dart';
import 'package:gym_app_user_1/models/product.dart';
import 'package:gym_app_user_1/services/product_service.dart';
import 'package:gym_app_user_1/screens/home/product_details_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> _products = [];
  bool _loading = true;
  String _searchQuery = '';
  String? _selectedDietaryPreference;
  final List<String> _dietaryPreferences = ['veg', 'non-veg', 'vegan', 'other'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _loading = true);
    try {
      final products = await ProductService.fetchAllProducts(
        dietaryPreference: _selectedDietaryPreference,
        searchQuery: _searchQuery,
      );
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load products'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _fetchProducts();
  }

  void _onDietaryPreferenceChanged(String? value) {
    setState(() {
      _selectedDietaryPreference = value;
    });
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 30),
              _buildSearchAndFilter(context, isDark),
              SizedBox(height: 30),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : _products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 60,
                            color: Theme.of(
                              context,
                            ).colorScheme.onBackground.withOpacity(0.3),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onBackground.withOpacity(0.5),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: _products
                          .map(
                            (product) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildEnhancedProductCard(
                                context,
                                product,
                              ),
                            ),
                          )
                          .toList(),
                    ),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Browse and filter available products',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
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
            Icons.shopping_bag,
            color: Theme.of(context).colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => _onSearchChanged(),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            cursorColor: Theme.of(context).colorScheme.primary,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        // Dietary preference filter with enhanced chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(
                context,
                label: 'All',
                selected: _selectedDietaryPreference == null,
                onSelected: () => _onDietaryPreferenceChanged(null),
              ),
              SizedBox(width: 8),
              ..._dietaryPreferences.map(
                (pref) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildFilterChip(
                    context,
                    label: pref,
                    selected: _selectedDietaryPreference == pref,
                    onSelected: () => _onDietaryPreferenceChanged(pref),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected,
      onSelected: (_) => onSelected(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selected ? Colors.transparent : Theme.of(context).dividerColor,
        ),
      ),
      elevation: selected ? 2 : 0,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      showCheckmark: false,
    );
  }

  Widget _buildEnhancedProductCard(BuildContext context, Product product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: product),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image with enhanced styling
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: product.imageUrl.isNotEmpty
                        ? Image.network(
                            product.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: colorScheme.surface.withOpacity(0.5),
                                  child: Center(
                                    child: Icon(
                                      Icons.image_not_supported_rounded,
                                      color: colorScheme.onSurface.withOpacity(
                                        0.3,
                                      ),
                                      size: 40,
                                    ),
                                  ),
                                ),
                          )
                        : Container(
                            color: colorScheme.surface.withOpacity(0.5),
                            child: Center(
                              child: Icon(
                                Icons.image_rounded,
                                color: colorScheme.onSurface.withOpacity(0.3),
                                size: 40,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 16),
                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        product.name,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      // Product type
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: product.type.map((type) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 12),
                      // Nutrition and price row
                      Row(
                        children: [
                          // Calories
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_fire_department_rounded,
                                  size: 14,
                                  color: colorScheme.secondary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${product.calories} kcal',
                                  style: TextStyle(
                                    color: colorScheme.secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          // Price
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.currency_rupee_rounded,
                                  size: 14,
                                  color: colorScheme.tertiary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${product.price}',
                                  style: TextStyle(
                                    color: colorScheme.tertiary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Dietary preference
                      Wrap(
                        spacing: 8,
                        children: product.dietaryPreference.map((pref) {
                          Color bgColor;
                          Color textColor;
                          switch (pref.toLowerCase()) {
                            case 'veg':
                              bgColor = Colors.green.withOpacity(0.1);
                              textColor = Colors.green;
                              break;
                            case 'non-veg':
                              bgColor = Colors.red.withOpacity(0.1);
                              textColor = Colors.red;
                              break;
                            case 'vegan':
                              bgColor = Colors.teal.withOpacity(0.1);
                              textColor = Colors.teal;
                              break;
                            default:
                              bgColor = colorScheme.surface;
                              textColor = colorScheme.onSurface;
                          }
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: textColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              pref,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
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
  }
}
