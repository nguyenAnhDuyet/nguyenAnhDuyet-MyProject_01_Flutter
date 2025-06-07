import '../api/auth_api.dart';
import '../models/auth_model.dart';
import '../exceptions/auth_exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final AuthApi _authApi;
  final FlutterSecureStorage _secureStorage;
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  AuthRepository({
    AuthApi? authApi,
    FlutterSecureStorage? secureStorage,
  })  : _authApi = authApi ?? AuthApi(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authApi.login(
        email: email,
        password: password,
      );

      final authModel = AuthModel.fromJson(response);
      
      // Save tokens securely
      await _secureStorage.write(key: _tokenKey, value: authModel.token);
      if (authModel.refreshToken != null) {
        await _secureStorage.write(
          key: _refreshTokenKey,
          value: authModel.refreshToken,
        );
      }

      return authModel;
    } catch (e) {
      if (e is AuthException) rethrow;
      
      if (e.toString().contains('401')) {
        throw InvalidCredentialsException();
      } else if (e.toString().contains('network')) {
        throw NetworkException(originalError: e);
      } else {
        throw ServerException(originalError: e);
      }
    }
  }

  Future<void> logout() async {
    await Future.wait([
      _secureStorage.delete(key: _tokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
    ]);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: _tokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  void dispose() {
    _authApi.dispose();
  }
} 