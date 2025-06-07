import '../api/auth_api.dart';
import '../models/auth_model.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final AuthApi _authApi;
  AuthModel? _currentUser;

  AuthService({AuthApi? authApi}) : _authApi = authApi ?? AuthApi();

  AuthModel? get currentUser => _currentUser;

  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authApi.login(
        email: email,
        password: password,
      );
      
      debugPrint('Login response: $response');

      _currentUser = AuthModel.fromJson(response);
      return _currentUser!;
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  void logout() {
    _currentUser = null;
  }

  void dispose() {
    _authApi.dispose();
  }
} 