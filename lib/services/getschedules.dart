import 'dart:convert';
import 'package:http/http.dart' as http;

class GetConsultingRequestService {
  static const String apiUrl =
      'https://yosefsahle.gospelinacts.org/api/getconsultingrequestes/index.php'; // Replace with your actual API URL

  Future<List<Map<String, dynamic>>> getPermissionRequests(
      String consultingType) async {
    final url = Uri.parse('$apiUrl?consultingType=$consultingType');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => data as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load permission requests');
    }
  }
}
