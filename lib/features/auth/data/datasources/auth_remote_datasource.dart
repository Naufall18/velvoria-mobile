import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/logger.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
});

/// Authentication remote data source interface
abstract class AuthRemoteDataSource {
  /// Login with email and password
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  /// Logout current user
  Future<void> logout();

  /// Get current authenticated user
  Future<UserModel> getCurrentUser();

  /// Forgot password
  Future<void> forgotPassword({required String email});

  /// Reset password
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Verify email with OTP
  Future<void> verifyEmail({required String otp});

  /// Resend verification email
  Future<void> resendVerificationEmail();
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl(this._apiClient);

  /// Maps the backend auth payload ({user, token, token_type}) onto the shape
  /// expected by AuthResponseModel ({user, access_token, ...}).
  Map<String, dynamic> _normalizeAuth(Map<String, dynamic> data) {
    return {
      'user': data['user'],
      'access_token': data['token'] ?? data['access_token'],
      'refresh_token': data['refresh_token'],
      'token_type': data['token_type'],
    };
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      Logger.debug('Login request for email: $email', tag: 'AuthDataSource');

      final response = await _apiClient.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      Logger.debug('Login successful', tag: 'AuthDataSource');
      return AuthResponseModel.fromJson(_normalizeAuth(response.data['data']));
    } on DioException catch (e) {
      Logger.error(
        'Login failed',
        tag: 'AuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      Logger.debug('Register request for email: $email', tag: 'AuthDataSource');

      final response = await _apiClient.post(
        '/register',
        data: {
          'email': email,
          'password': password,
          'password_confirmation': password,
          'name': name,
          if (phoneNumber != null) 'phone': phoneNumber,
        },
      );

      Logger.debug('Registration successful', tag: 'AuthDataSource');
      return AuthResponseModel.fromJson(_normalizeAuth(response.data['data']));
    } on DioException catch (e) {
      Logger.error(
        'Registration failed',
        tag: 'AuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      Logger.debug('Logout request', tag: 'AuthDataSource');

      await _apiClient.post('/logout');

      Logger.debug('Logout successful', tag: 'AuthDataSource');
    } on DioException catch (e) {
      Logger.error(
        'Logout failed',
        tag: 'AuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      Logger.debug('Get current user request', tag: 'AuthDataSource');

      final response = await _apiClient.get('/me');

      Logger.debug('Get current user successful', tag: 'AuthDataSource');
      // Backend shape: { data: { user: {...} } }
      final data = response.data['data'];
      final userJson = (data is Map && data['user'] != null) ? data['user'] : data;
      return UserModel.fromJson(userJson as Map<String, dynamic>);
    } on DioException catch (e) {
      Logger.error(
        'Get current user failed',
        tag: 'AuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      Logger.debug('Forgot password request', tag: 'AuthDataSource');

      await _apiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      Logger.debug('Forgot password successful', tag: 'AuthDataSource');
    } on DioException catch (e) {
      Logger.error(
        'Forgot password failed',
        tag: 'AuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      Logger.debug('Reset password request', tag: 'AuthDataSource');

      await _apiClient.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': newPassword,
        },
      );

      Logger.debug('Reset password successful', tag: 'AuthDataSource');
    } on DioException catch (e) {
      Logger.error(
        'Reset password failed',
        tag: 'AuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<void> verifyEmail({required String otp}) async {
    try {
      Logger.debug('Verify email request', tag: 'AuthDataSource');

      await _apiClient.post(
        '/auth/verify-email',
        data: {'otp': otp},
      );

      Logger.debug('Verify email successful', tag: 'AuthDataSource');
    } on DioException catch (e) {
      Logger.error(
        'Verify email failed',
        tag: 'AuthDataSource',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      Logger.debug('Resend verification email request', tag: 'AuthDataSource');

      await _apiClient.post('/auth/resend-verification');

      Logger.debug('Resend verification email successful', tag: 'AuthDataSource');
    } on DioException catch (e) {
      Logger.error(
        'Resend verification email failed',
        tag: 'AuthDataSource',
        error: e,
      );
      rethrow;
    }
  }
}
