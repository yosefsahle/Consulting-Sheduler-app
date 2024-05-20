import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class MakePostService {
  static const String apiUrl =
      'https://yosefsahle.gospelinacts.org/api/createpost/'; // Update with your actual server URL

  Future<bool> createPost(
    int posterId,
    String title,
    String description,
    File image,
    String date,
  ) async {
    var uri = Uri.parse(apiUrl);
    var request = http.MultipartRequest('POST', uri);

    request.fields['poster_id'] = posterId.toString();
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['date'] = date;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
