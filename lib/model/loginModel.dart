// models/login_model.dart
class LoginModel {
  final String emailOrPhone;
  final String password;

  LoginModel({required this.emailOrPhone, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'emailOrPhone': emailOrPhone,
      'password': password,
    };
  }
}
