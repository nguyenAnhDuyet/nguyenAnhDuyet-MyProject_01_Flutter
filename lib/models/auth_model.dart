class AuthModel {
  final String token;
  final String? refreshToken;
  final Map<String, dynamic>? user;

  AuthModel({
    required this.token,
    this.refreshToken,
    this.user,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    if (json['access_token'] == null) {
      throw FormatException('Access token is required but was null in the response');
    }
    
    return AuthModel(
      token: json['access_token'].toString(),
      refreshToken: json['refresh_token']?.toString(),
      user: json['user'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': token,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (user != null) 'user': user,
    };
  }
} 