import 'dart:convert';
import 'package:http/http.dart' as http;

class ExistanceCheckerService {
  static const String apiUrl =
      'https://yosefsahle.gospelinacts.org/api/checkrequestexist/';
  static const String apiUrlSchedule =
      'https://yosefsahle.gospelinacts.org/api/checkscheduleexist/';

  Future<bool> checkexistance(String userId) async {
    final url = Uri.parse(apiUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'userId': userId});

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkexistanceSchedule(String userId) async {
    final url = Uri.parse(apiUrlSchedule);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'userId': userId});

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
