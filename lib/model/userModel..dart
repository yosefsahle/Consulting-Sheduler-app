import 'dart:io';

class User {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final String accountType;
  final String phone;
  final File? image;

  User({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.accountType,
    required this.phone,
    this.image,
  });
}
