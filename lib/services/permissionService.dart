import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String postApiUrl =
      'https://yosefsahle.gospelinacts.org/api/aproveMediaManager/';
  static const String consultApiUrl =
      'https://yosefsahle.gospelinacts.org/api/approveConsultantUser/';
  static const String rejectApiUrl =
      'https://yosefsahle.gospelinacts.org/api/rejectpermissionrequest/';

  Future<Map<String, dynamic>> approvePosterUser({
    required int userId,
    required String role,
  }) async {
    final url = Uri.parse(postApiUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'userId': userId,
      'role': role,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update user role: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> approveConsultantUser({
    required int id,
    required String role,
    required List<String> selectedValues,
  }) async {
    final url = Uri.parse(consultApiUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'id': id,
      'role': role,
      'selected_values': selectedValues,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> rejectUser({required int userId}) async {
    final url = Uri.parse(rejectApiUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'userId': userId,
    });

    final response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to reject user: ${response.body}');
    }
  }
}
