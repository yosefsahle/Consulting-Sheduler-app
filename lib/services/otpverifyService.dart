import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPVerifyService {
  Future<bool> verifyOtp(String phone, String token, String otp) async {
    final Uri uri =
        Uri.parse('https://yosefsahle.gospelinacts.org/api/otpverify/');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone': phone,
        'token': token,
        'verification_code': otp,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
