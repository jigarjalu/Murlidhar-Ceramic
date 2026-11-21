import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  static const String _prefUserKey = 'mc_logged_in_user_id';
  static const String _prefUserName = 'mc_logged_in_user_name';
  static const String _prefUserPhone = 'mc_logged_in_user_phone';
  static const String _prefIsGuest = 'mc_logged_in_is_guest';
  static const String _prefIsAdmin = 'mc_logged_in_is_admin';
  static const String _prefOnboardingDone = 'mc_onboarding_completed';

  UserModel? _cachedUser;

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_cachedUser != null) return _cachedUser;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_prefUserKey);
    if (userId == null) return null;

    final name = prefs.getString(_prefUserName) ?? 'Customer';
    final phone = prefs.getString(_prefUserPhone) ?? '';
    final isGuest = prefs.getBool(_prefIsGuest) ?? false;
    final isAdmin = prefs.getBool(_prefIsAdmin) ?? false;

    _cachedUser = UserModel(
      id: userId,
      name: name,
      phone: phone,
      isGuest: isGuest,
      isAdmin: isAdmin,
    );
    return _cachedUser;
  }

  @override
  Future<bool> sendOtp(String mobileNumber) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // Validates any 10-digit number
    final clean = mobileNumber.replaceAll(RegExp(r'\D'), '');
    return clean.length >= 10;
  }

  @override
  Future<UserModel?> verifyOtp({
    required String mobileNumber,
    required String otp,
    required String fullName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    // Mock accepts 123456 or any 6 digit OTP
    if (otp.length == 6) {
      final user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: fullName.trim().isEmpty ? 'Customer' : fullName.trim(),
        phone: mobileNumber,
        isGuest: false,
        isAdmin: false,
      );
      await _persistUser(user);
      _cachedUser = user;
      return user;
    }
    return null;
  }

  @override
  Future<UserModel> continueAsGuest() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final guest = UserModel.guest();
    await _persistUser(guest);
    _cachedUser = guest;
    return guest;
  }

  @override
  Future<bool> adminLogin({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (email.trim().toLowerCase() == 'admin@murlidhar.com' &&
        password == 'admin123') {
      const admin = UserModel(
        id: 'admin_master',
        name: 'Murlidhar Admin',
        phone: '+91 9979079013',
        isGuest: false,
        isAdmin: true,
      );
      await _persistUser(admin);
      _cachedUser = admin;
      return true;
    }
    return false;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefUserKey);
    await prefs.remove(_prefUserName);
    await prefs.remove(_prefUserPhone);
    await prefs.remove(_prefIsGuest);
    await prefs.remove(_prefIsAdmin);
    _cachedUser = null;
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await getCurrentUser();
    return user != null;
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefOnboardingDone) ?? false;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefOnboardingDone, true);
  }

  Future<void> _persistUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefUserKey, user.id);
    await prefs.setString(_prefUserName, user.name);
    await prefs.setString(_prefUserPhone, user.phone);
    await prefs.setBool(_prefIsGuest, user.isGuest);
    await prefs.setBool(_prefIsAdmin, user.isAdmin);
  }
}
