import 'package:flutter_web_app/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<({AuthUser user, String accessToken, String refreshToken})> login({
    required String email,
    required String password,
  });

  Future<AuthUser> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<AuthUser?> validateToken(String token);
}
