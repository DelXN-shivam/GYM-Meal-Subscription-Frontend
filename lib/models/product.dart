class Product {
  final String id;
  final String name;
  final List<String> type;
  final String measurement;
  final int quantity;
  final int calories;
  final int price;
  final List<String> dietaryPreference;
  final List<String> allergies;
  final String imageUrl;
  final String? createdAt;
  final String? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.measurement,
    required this.quantity,
    required this.calories,
    required this.price,
    required this.dietaryPreference,
    required this.allergies,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      type: List<String>.from(json['type'] ?? []),
      measurement: json['measurement'] ?? '',
      quantity: json['quantity'] ?? 0,
      calories: json['calories'] ?? 0,
      price: json['price'] ?? 0,
      dietaryPreference: List<String>.from(json['dietaryPreference'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
