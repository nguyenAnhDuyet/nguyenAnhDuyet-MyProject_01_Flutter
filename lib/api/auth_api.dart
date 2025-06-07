import 'api_client.dart';

class AuthApi {
  final ApiClient _apiClient;

  AuthApi({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return _apiClient.post(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );
  }

  void dispose() {
    _apiClient.dispose();
  }
} 