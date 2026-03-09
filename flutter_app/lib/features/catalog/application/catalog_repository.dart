import '../../../core/models/brand.dart';
import '../../../core/models/product.dart';
import '../data/mock/mock_catalog_data.dart';

abstract class CatalogRepository {
  Future<List<Product>> fetchProducts();
  Future<List<Brand>> fetchBrands();
}

class MockCatalogRepository implements CatalogRepository {
  @override
  Future<List<Brand>> fetchBrands() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return mockBrands;
  }

  @override
  Future<List<Product>> fetchProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return mockProducts;
  }
}
