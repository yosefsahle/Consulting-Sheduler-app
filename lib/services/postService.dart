import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_assignment/model/postModel.dart';

class PostService {
  static const String apiUrl =
      'https://yosefsahle.gospelinacts.org/api/viewpost/';
  final String deletpostapi =
      'https://yosefsahle.gospelinacts.org/api/deletpost/';

  Future<List<PostModel>> fetchPosts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>> deletpost({required int postId}) async {
    final url = Uri.parse(deletpostapi);
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'userId': postId,
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
