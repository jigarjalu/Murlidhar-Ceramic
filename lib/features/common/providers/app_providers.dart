import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/enquiry_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../data/repositories/enquiry_repository.dart';
import '../../../data/repositories/mock_auth_repository.dart';
import '../../../data/repositories/mock_catalog_repository.dart';
import '../../../data/repositories/mock_enquiry_repository.dart';

// Repository Providers
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return MockCatalogRepository();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

final enquiryRepositoryProvider = Provider<EnquiryRepository>((ref) {
  return MockEnquiryRepository();
});

// Catalog Providers
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getCategories();
});

final popularProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getPopularProducts();
});

final featuredProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getFeaturedProducts();
});

final productsByCategoryProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, categoryId) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getProducts(categoryId: categoryId);
});

final productDetailProvider =
    FutureProvider.family<ProductModel?, String>((ref, id) async {
  final repo = ref.watch(catalogRepositoryProvider);
  return repo.getProductById(id);
});

// Auth & User State
class AuthStateNotifier extends StateNotifier<UserModel?> {
  final AuthRepository _authRepo;

  AuthStateNotifier(this._authRepo) : super(null) {
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await _authRepo.getCurrentUser();
    state = user;
  }

  Future<bool> sendOtp(String mobile) async {
    return _authRepo.sendOtp(mobile);
  }

  Future<bool> verifyOtp({
    required String mobile,
    required String otp,
    required String name,
  }) async {
    final user = await _authRepo.verifyOtp(
      mobileNumber: mobile,
      otp: otp,
      fullName: name,
    );
    if (user != null) {
      state = user;
      return true;
    }
    return false;
  }

  Future<void> continueAsGuest() async {
    final guest = await _authRepo.continueAsGuest();
    state = guest;
  }

  Future<bool> adminLogin(String email, String password) async {
    final ok = await _authRepo.adminLogin(email: email, password: password);
    if (ok) {
      state = await _authRepo.getCurrentUser();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _authRepo.logout();
    state = null;
  }
}

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, UserModel?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repo);
});

// Enquiry List Notifier (Cart of Enquiries)
class EnquiryCartNotifier extends StateNotifier<List<EnquiryItem>> {
  final EnquiryRepository _repo;

  EnquiryCartNotifier(this._repo) : super([]) {
    loadCart();
  }

  Future<void> loadCart() async {
    final items = await _repo.getEnquiryCartItems();
    state = items;
  }

  Future<void> addItem(EnquiryItem item) async {
    await _repo.addToEnquiryCart(item);
    state = await _repo.getEnquiryCartItems();
  }

  Future<void> removeItem(String productId, String size, String finish) async {
    await _repo.removeFromEnquiryCart(productId, size, finish);
    state = await _repo.getEnquiryCartItems();
  }

  Future<void> clearCart() async {
    await _repo.clearEnquiryCart();
    state = [];
  }

  bool isInCart(String productId, String size, String finish) {
    return state.any((e) =>
        e.productId == productId &&
        e.selectedSize == size &&
        e.selectedFinish == finish);
  }
}

final enquiryCartProvider =
    StateNotifierProvider<EnquiryCartNotifier, List<EnquiryItem>>((ref) {
  final repo = ref.watch(enquiryRepositoryProvider);
  return EnquiryCartNotifier(repo);
});

// Favorites Notifier (Persisted locally in SharedPreferences)
class FavoritesNotifier extends StateNotifier<Set<String>> {
  static const String _prefFavKey = 'mc_favorites_list';

  FavoritesNotifier() : super({}) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefFavKey) ?? [];
    state = list.toSet();
  }

  Future<void> toggleFavorite(String productId) async {
    final next = Set<String>.from(state);
    if (next.contains(productId)) {
      next.remove(productId);
    } else {
      next.add(productId);
    }
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefFavKey, next.toList());
  }

  bool isFavorite(String productId) => state.contains(productId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
