import 'package:flutter/material.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:my_assignment/widgets/common/infolist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String userName;
  late String userEmail;
  late String userPhone;
  late String userType;
  late String userRole;
  late String userImage;
  late String userId;
  bool isLoading = true; // Track if data is loading

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to load user data from shared preferences
  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userEmail = prefs.getString('user_email') ?? 'Email';
      userPhone = prefs.getString('user_phone') ?? 'Phone';
      userType = prefs.getString('user_type') ?? 'Account Type';
      userRole = prefs.getString('user_role') ?? 'User Role';
      userImage = prefs.getString('user_image') ?? 'url';
      userId = prefs.getString('user_id') ?? '0';
      isLoading = false; // Set isLoading to false when data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child:
                CircularProgressIndicator(), // Show progress indicator while loading data
          )
        : Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: CircleAvatar(
                  foregroundImage: NetworkImage(
                      'https://yosefsahle.gospelinacts.org/api/registeruser/$userImage'),
                  radius: 70,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  userName,
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              ),
              Center(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_square,
                    size: 14,
                    color: AppColors.grey,
                  ),
                  label: Text(
                    'EditProfile',
                    style: TextStyle(fontSize: 14, color: AppColors.grey),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 1,
                color: AppColors.primary,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 40),
                child: Column(
                  children: [
                    InfoList(label: 'Phone', data: userPhone),
                    const SizedBox(
                      height: 10,
                    ),
                    InfoList(label: 'Email', data: userEmail),
                    const SizedBox(
                      height: 10,
                    ),
                    InfoList(label: 'Account Type', data: userType),
                    const SizedBox(
                      height: 10,
                    ),
                    InfoList(label: 'Account Role', data: userRole),
                  ],
                ),
              )
            ],
          );
  }
}
