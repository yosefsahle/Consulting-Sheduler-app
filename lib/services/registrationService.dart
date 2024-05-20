import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class RegistrationService {
  static const String apiUrl =
      'https://yosefsahle.gospelinacts.org/api/registeruser/'; // Update with your actual server URL

  Future<bool> createUser(String name, String phone, String email,
      String password, String userType, String userRole, File image) async {
    var uri = Uri.parse(apiUrl);
    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['user_type'] = userType;
    request.fields['user_role'] = userRole;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();
    print('$name + $phone + $email + $password + $userType + $userRole ');
    print(response.statusCode);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
