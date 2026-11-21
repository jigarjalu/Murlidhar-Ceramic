import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class CatalogRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts({String? categoryId});
  Future<List<ProductModel>> getPopularProducts();
  Future<List<ProductModel>> getFeaturedProducts();
  Future<ProductModel?> getProductById(String id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<void> addProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}
