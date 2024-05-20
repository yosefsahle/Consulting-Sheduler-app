import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_assignment/model/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = 'https://yosefsahle.gospelinacts.org/api/login/';

  Future<bool> login(LoginModel loginModel) async {
    final url = Uri.parse(_baseUrl); // Ensure to add .php
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginModel.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', responseBody['user']['user_id'].toString());
        prefs.setString('user_name', responseBody['user']['name']);
        prefs.setString('user_phone', responseBody['user']['phone']);
        prefs.setString('user_email', responseBody['user']['email']);
        prefs.setString('user_type', responseBody['user']['user_type']);
        prefs.setString('user_role', responseBody['user']['role']);
        prefs.setString('user_image', responseBody['user']['image']);
        return true;
      } else {
        // Optionally handle error message here
        return false;
      }
    } else {
      print('Server error: ${response.statusCode}');
      return false;
    }
  }
}
