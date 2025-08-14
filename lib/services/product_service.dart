import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static Future<List<Product>> fetchProductsByType(String type) async {
    final url =
        'https://gym-meal-subscription-backend.vercel.app/api/v1/product/filterProducts/?type=$type';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['filteredProducts'];
      return products.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Product>> fetchAllProducts({
    String? dietaryPreference,
    String? searchQuery,
  }) async {
    final url =
        'https://gym-meal-subscription-backend.vercel.app/api/v1/product/all';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];
      List<Product> productList = products
          .map((json) => Product.fromJson(json))
          .toList();
      // Filter by dietaryPreference if provided
      if (dietaryPreference != null && dietaryPreference.isNotEmpty) {
        productList = productList
            .where(
              (product) =>
                  product.dietaryPreference.contains(dietaryPreference),
            )
            .toList();
      }
      // Filter by searchQuery if provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        productList = productList
            .where(
              (product) =>
                  product.name.toLowerCase().contains(query) ||
                  product.type.any(
                    (type) => type.toLowerCase().contains(query),
                  ) ||
                  product.dietaryPreference.any(
                    (pref) => pref.toLowerCase().contains(query),
                  ),
            )
            .toList();
      }
      return productList;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
