import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  final List<Product> presentProducts;
  // Remove moreProducts from constructor
  const CategoryProductsScreen({
    Key? key,
    required this.categoryName,
    required this.presentProducts,
  }) : super(key: key);

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String _searchQuery = '';
  List<Product> _moreProducts = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final products = await ProductService.fetchProductsByType(
        widget.categoryName.toLowerCase(),
      );
      setState(() {
        _moreProducts = products;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load products';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final present = widget.presentProducts
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final more = _moreProducts
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName), leading: BackButton()),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Text(_error!, style: TextStyle(color: Colors.red)),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    if (present.isNotEmpty) ...[
                      Text(
                        'My ${widget.categoryName}',
                        style: _sectionTitleStyle(context),
                      ),
                      const SizedBox(height: 8),
                      ...present.map(
                        (product) => _buildProductItem(
                          context,
                          product,
                          isPresent: true,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                    Text(
                      'Frequently Tracked Foods',
                      style: _sectionTitleStyle(context),
                    ),
                    const SizedBox(height: 8),
                    if (more.isNotEmpty)
                      ...more.map(
                        (product) => _buildProductItem(
                          context,
                          product,
                          isPresent: false,
                        ),
                      )
                    else
                      Text(
                        'No more products found.',
                        style: TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for food',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    Product product, {
    required bool isPresent,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: product.imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.fastfood),
                ),
              )
            : Icon(Icons.fastfood, size: 40),
        title: Text(
          product.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${product.measurement} • ${product.calories} Cal'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isPresent
                    ? Icons.remove_circle_outline
                    : Icons.add_circle_outline,
                color: isPresent
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                // Add or remove product logic
              },
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _sectionTitleStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onBackground,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}
