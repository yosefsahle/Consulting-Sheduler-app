import 'dart:convert';
import 'package:http/http.dart' as http;

class GetConsultingService {
  static const String apiUrl =
      'https://yosefsahle.gospelinacts.org/api/consultingtypes/';
  final String avilabelTimeUrl =
      'https://yosefsahle.gospelinacts.org/api/avilabelscheduletime/';
  final String submittapiUrl =
      'https://yosefsahle.gospelinacts.org/api/addschedule/';
  final String markascontactedApiUrl =
      'https://yosefsahle.gospelinacts.org/api/markascontacted/';
  final String addconsultingtypeUrl =
      'https://yosefsahle.gospelinacts.org/api/addconsultingtype/';
  final String deletconsultingtypeapi =
      'https://yosefsahle.gospelinacts.org/api/deletconsultingtype/index.php';

  Future<List<String>> fetchConsultingType() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load schedule types');
    }
  }

  Future<bool> addConsultingType(String type) async {
    final response = await http.post(
      Uri.parse(addconsultingtypeUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'type': type,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteConsultingType(String type) async {
    final response = await http.post(
      Uri.parse(deletconsultingtypeapi),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'type': type,
      }),
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<String>> fetchAvailableConsultingDates(
      String scheduleType) async {
    print(scheduleType);
    try {
      final response = await http
          .get(Uri.parse('$avilabelTimeUrl?scheduleType=$scheduleType'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<String> availableDates =
            data.map((date) => date.toString()).toList();
        return availableDates;
      } else {
        throw Exception('Failed to load available consulting dates');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<bool> submitSchedule(
    int userid,
    String selectedType,
    String selectedTime,
  ) async {
    try {
      // Create a JSON object with the selected type and time
      Map<String, dynamic> requestBody = {
        'userId': userid,
        'selected_type': selectedType,
        'selected_time': selectedTime,
      };

      // Convert the JSON object to a string
      String requestBodyJson = jsonEncode(requestBody);

      // Send a POST request to the API endpoint
      http.Response response = await http.post(
        Uri.parse(submittapiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBodyJson,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        return true;
        print('Response: ${response.body}');
      } else {
        // If the request was not successful, print an error message
        print('Failed to submit schedule. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to submit schedule');
      }
    } catch (error) {
      // If an error occurs during the request, print the error message
      print('Error submitting schedule: $error');
      throw Exception('Error submitting schedule');
    }
  }

  Future<Map<String, dynamic>> markascontacted({required int userId}) async {
    final url = Uri.parse(markascontactedApiUrl);
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
