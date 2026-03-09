import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/product.dart';
import 'catalog_data_providers.dart';
import 'catalog_filter_providers.dart';

final featuredProductProvider = Provider<Product?>((ref) {
  final list = ref.watch(productsProvider).valueOrNull ?? const <Product>[];
  return list.where((p) => p.id == '5').firstOrNull;
});

final homeProductsProvider = Provider<List<Product>>((ref) {
  final tab = ref.watch(homeTabProvider);
  final list = ref.watch(productsProvider).valueOrNull ?? const <Product>[];
  return list.where((p) => p.tags.contains(tab)).toList();
});

final shopProductsProvider = Provider<List<Product>>((ref) {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final list = ref.watch(productsProvider).valueOrNull ?? const <Product>[];
  if (selectedCategory == 'all') {
    return list;
  }
  return list.where((p) => p.category == selectedCategory).toList();
});

final searchProductsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final list = ref.watch(productsProvider).valueOrNull ?? const <Product>[];
  if (query.isEmpty) {
    return const <Product>[];
  }
  return list
      .where(
        (p) =>
            p.name.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query),
      )
      .toList();
});

final productByIdProvider = Provider.family<Product?, String>((ref, productId) {
  final list = ref.watch(productsProvider).valueOrNull ?? const <Product>[];
  return list.where((p) => p.id == productId).firstOrNull;
});

final productsByBrandIdProvider = Provider.family<List<Product>, String>((
  ref,
  brandId,
) {
  final brands = ref.watch(brandsProvider).valueOrNull ?? const [];
  final products = ref.watch(productsProvider).valueOrNull ?? const <Product>[];
  final brand = brands.where((b) => b.id == brandId).firstOrNull;
  if (brand == null) {
    return const <Product>[];
  }
  return products.where((p) => p.brand == brand.name).toList();
});
