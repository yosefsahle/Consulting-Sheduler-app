import 'dart:convert';
import 'package:http/http.dart' as http;

class PermissionRequestService {
  static const String apiUrl =
      'https://yosefsahle.gospelinacts.org/api/requestpermission/'; // Replace with your actual API URL

  Future<Map<String, dynamic>> submitPermissionRequest({
    required String userId,
    required String selectedOption,
  }) async {
    final url = Uri.parse(apiUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'userId': userId,
      'selectedOption': selectedOption,
    });

    final response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to submit permission request');
    }
  }
}
