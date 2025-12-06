import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  const AuthUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, email, firstName, lastName];
}
