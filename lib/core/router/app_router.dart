import 'package:go_router/go_router.dart';
import '../utils/transitions.dart';
import '../../data/models/category_model.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/products/product_list_screen.dart';
import '../../features/product_detail/product_detail_screen.dart';
import '../../features/gallery/gallery_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/filters/filters_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/enquiry/enquiry_list_screen.dart';
import '../../features/enquiry/my_enquiries_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/about/about_screen.dart';
import '../../features/admin/admin_login_screen.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/admin/admin_products_screen.dart';
import '../../features/admin/admin_enquiries_screen.dart';
import '../../features/admin/admin_reports_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => AppTransitions.fadeThrough(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => AppTransitions.fadeThrough(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => AppTransitions.sharedAxisX(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/otp',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return AppTransitions.sharedAxisX(
            key: state.pageKey,
            child: OtpScreen(
              name: extra['name'] as String? ?? 'Customer',
              phone: extra['phone'] as String? ?? '9979079013',
            ),
          );
        },
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => AppTransitions.fadeThrough(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/categories',
        pageBuilder: (context, state) => AppTransitions.fadeThrough(
          key: state.pageKey,
          child: const CategoriesScreen(),
        ),
      ),
      GoRoute(
        path: '/products',
        pageBuilder: (context, state) {
          final cat = state.extra as CategoryModel?;
          return AppTransitions.sharedAxisX(
            key: state.pageKey,
            child: ProductListScreen(category: cat),
          );
        },
      ),
      GoRoute(
        path: '/product-detail/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return AppTransitions.sharedAxisX(
            key: state.pageKey,
            child: ProductDetailScreen(productId: id),
          );
        },
      ),
      GoRoute(
        path: '/gallery',
        pageBuilder: (context, state) => AppTransitions.fadeThrough(
          key: state.pageKey,
          child: const GalleryScreen(),
        ),
      ),
      GoRoute(
        path: '/search',
        pageBuilder: (context, state) => AppTransitions.sharedAxisY(
          key: state.pageKey,
          child: const SearchScreen(),
        ),
      ),
      GoRoute(
        path: '/filters',
        pageBuilder: (context, state) => AppTransitions.sharedAxisY(
          key: state.pageKey,
          child: const FiltersScreen(),
        ),
      ),
      GoRoute(
        path: '/favorites',
        pageBuilder: (context, state) => AppTransitions.sharedAxisX(
          key: state.pageKey,
          child: const FavoritesScreen(),
        ),
      ),
      GoRoute(
        path: '/enquiry',
        pageBuilder: (context, state) => AppTransitions.fadeThrough(
          key: state.pageKey,
          child: const EnquiryListScreen(),
        ),
      ),
      GoRoute(
        path: '/my-enquiries',
        pageBuilder: (context, state) => AppTransitions.sharedAxisX(
          key: state.pageKey,
          child: const MyEnquiriesScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => AppTransitions.fadeThrough(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (context, state) => AppTransitions.fadeThrough(
          key: state.pageKey,
          child: const AboutScreen(),
        ),
      ),

      // Admin Routes
      GoRoute(
        path: '/admin/login',
        pageBuilder: (context, state) => AppTransitions.sharedAxisY(
          key: state.pageKey,
          child: const AdminLoginScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/dashboard',
        pageBuilder: (context, state) => AppTransitions.fadeThrough(
          key: state.pageKey,
          child: const AdminDashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/products',
        pageBuilder: (context, state) => AppTransitions.sharedAxisX(
          key: state.pageKey,
          child: const AdminProductsScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/enquiries',
        pageBuilder: (context, state) => AppTransitions.sharedAxisX(
          key: state.pageKey,
          child: const AdminEnquiriesScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/reports',
        pageBuilder: (context, state) => AppTransitions.sharedAxisX(
          key: state.pageKey,
          child: const AdminReportsScreen(),
        ),
      ),
    ],
  );
}
