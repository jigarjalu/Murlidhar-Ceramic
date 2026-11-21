import '../mock_catalog.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'catalog_repository.dart';

class MockCatalogRepository implements CatalogRepository {
  final List<ProductModel> _products = List.from(MockCatalog.products);
  final List<CategoryModel> _categories = List.from(MockCatalog.categories);

  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_categories);
  }

  @override
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (categoryId != null && categoryId.isNotEmpty) {
      return _products.where((p) => p.categoryId == categoryId).toList();
    }
    return List.unmodifiable(_products);
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _products.where((p) => p.isPopular).toList();
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _products.where((p) => p.isFeatured).toList();
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    return _products.where((p) {
      return p.nameEnglish.toLowerCase().contains(q) ||
          p.nameGujarati.toLowerCase().contains(q) ||
          p.sizes.any((s) => s.toLowerCase().contains(q)) ||
          p.finishes.any((f) => f.toLowerCase().contains(q)) ||
          p.colors.any((c) => c.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _products.add(product);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final idx = _products.indexWhere((p) => p.id == product.id);
    if (idx != -1) {
      _products[idx] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _products.removeWhere((p) => p.id == id);
  }
}
