import 'dart:convert';
import 'package:http/http.dart' as http;

class SetUpScheduleService {
  final String baseUrl =
      'https://yosefsahle.gospelinacts.org/api/getMySchedule/';
  final String updateapiUrl =
      'https://yosefsahle.gospelinacts.org/api/updatemyschedule/';

  Future<List<dynamic>> fetchMySchedule(int userId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({'id': userId}),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      String selectedValuesJsonString = responseData['selected_values'][0];

      List<dynamic> registeredValues = jsonDecode(selectedValuesJsonString);
      return registeredValues;
    } else {
      print(response.statusCode);
      throw Exception('Failed to load schedule times');
    }
  }

  Future<bool> updateSchedule(int id, List<String> selectedValues) async {
    // Create a JSON object with the required fields
    Map<String, dynamic> requestBody = {
      'id': id,
      'selected_values': selectedValues,
    };

    // Convert the JSON object to a string
    String requestBodyJson = jsonEncode(requestBody);

    try {
      // Send an HTTP POST request to the API endpoint
      http.Response response = await http.post(
        Uri.parse(updateapiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBodyJson,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Print the response body (for demonstration)
        print('Response: ${response.body}');
        return true;
      } else {
        // If the request was not successful, print an error message
        print('Failed to update schedule. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
        throw Exception('Failed to update schedule');
      }
    } catch (error) {
      // If an error occurs during the request, print the error message
      print('unsent');
      print('Error updating schedule: $error');
      return false;
      throw Exception('Error updating schedule');
    }
  }
}
