import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application/demo_state_provider.dart';
import '../../../core/models/brand.dart';
import '../../../core/models/demo_state.dart';
import '../../../core/models/product.dart';
import 'catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((_) {
  return MockCatalogRepository();
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final mode = ref.watch(demoStateProvider);
  if (mode == DemoState.error) {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    throw Exception('Mock network error.');
  }
  if (mode == DemoState.empty) {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const <Product>[];
  }
  return ref.watch(catalogRepositoryProvider).fetchProducts();
});

final brandsProvider = FutureProvider<List<Brand>>((ref) async {
  return ref.watch(catalogRepositoryProvider).fetchBrands();
});
