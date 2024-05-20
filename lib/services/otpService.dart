import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_assignment/model/otpResponseModel.dart';

class OTPService {
  static const String _baseUrl =
      'https://yosefsahle.gospelinacts.org/api/otpcode/';

  Future<OtpResponse> sendOtp(String phoneNumber) async {
    final Uri apiUrl = Uri.parse(_baseUrl);

    final response = await http.post(
      apiUrl,
      body: json.encode({'phoneNumber': phoneNumber}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return OtpResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send OTP');
    }
  }
}
