import '../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<bool> sendOtp(String mobileNumber);
  Future<UserModel?> verifyOtp({
    required String mobileNumber,
    required String otp,
    required String fullName,
  });
  Future<UserModel> continueAsGuest();
  Future<bool> adminLogin({required String email, required String password});
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<bool> hasCompletedOnboarding();
  Future<void> setOnboardingCompleted();
}
