class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    required this.category,
    required this.tags,
    this.description,
    this.sizes = const <String>[],
    this.colors = const <String>[],
    this.matchPercentage,
  });

  final String id;
  final String name;
  final String brand;
  final double price;
  final String image;
  final String category;
  final List<String> tags;
  final String? description;
  final List<String> sizes;
  final List<String> colors;
  final int? matchPercentage;
}
