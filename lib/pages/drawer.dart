import 'package:flutter/material.dart';
import 'package:my_assignment/pages/auth/login.dart';
import 'package:my_assignment/pages/drawer_pages/consultcontact.dart';
import 'package:my_assignment/pages/drawer_pages/consultingtype.dart';
import 'package:my_assignment/pages/drawer_pages/makepost.dart';
import 'package:my_assignment/pages/drawer_pages/requestlist.dart';
import 'package:my_assignment/pages/drawer_pages/requestpermission.dart';
import 'package:my_assignment/pages/drawer_pages/setupconsulting.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String userName;
  late String userEmail;
  late String userRole;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userEmail = prefs.getString('user_email') ?? 'Email';
      userRole = prefs.getString('user_role') ?? 'User';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved preferences
    // After clearing preferences, navigate to login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const Login(),
      ),
    );
  }

  bool isAdmin(String role) {
    if (role == 'Admin') {
      return true;
    } else {
      return false;
    }
  }

  bool isMediaManager(String role) {
    if (role == 'Media Manager') {
      return true;
    } else {
      return false;
    }
  }

  bool isConsultant(String role) {
    if (role == 'Consultant') {
      return true;
    } else {
      return false;
    }
  }

  bool isSuper(String role) {
    if (role == 'Super Admin') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              accountName: Text(userName),
              accountEmail: Text(userEmail)),
          Visibility(
            visible: isMediaManager(userRole) ||
                isAdmin(userRole) ||
                isSuper(userRole),
            child: buildDrawerButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MakePost(),
                    ),
                  );
                },
                icon: Icons.post_add,
                label: 'Make Post'),
          ),
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: isConsultant(userRole) ||
                isAdmin(userRole) ||
                isSuper(userRole),
            child: buildDrawerButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConsultingType(),
                    ),
                  );
                },
                icon: Icons.add_to_photos_rounded,
                label: 'Add Consulting Type'),
          ),
          SizedBox(
            height: 5,
          ),
          Visibility(
            visible: isConsultant(userRole) ||
                isAdmin(userRole) ||
                isSuper(userRole),
            child: buildDrawerButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetUpConsulting(),
                    ),
                  );
                },
                icon: Icons.scoreboard_sharp,
                label: 'Set Up Counsulting'),
          ),
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: isConsultant(userRole) ||
                isAdmin(userRole) ||
                isSuper(userRole),
            child: buildDrawerButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConsultingContact(),
                    ),
                  );
                },
                icon: Icons.connect_without_contact_sharp,
                label: 'Consulting Contact'),
          ),
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: isSuper(userRole),
            child: buildDrawerButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Requestes(),
                    ),
                  );
                },
                icon: Icons.security_rounded,
                label: 'Permission Requestes'),
          ),
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: !isSuper(userRole) && !isAdmin(userRole),
            child: buildDrawerButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestPermission(),
                    ),
                  );
                },
                icon: Icons.security_rounded,
                label: 'Request Permission'),
          ),
          const SizedBox(
            height: 5,
          ),
          buildDrawerButton(
              onPressed: () {
                _logout();
              },
              icon: Icons.logout,
              label: 'Log Out'),
        ],
      ),
    );
  }

  Widget buildDrawerButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      height: 60,
      child: TextButton.icon(
        style: const ButtonStyle(
          alignment: AlignmentDirectional.centerStart,
        ),
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppColors.primary,
        ),
        label: Text(
          label,
          style: TextStyle(color: AppColors.primary),
        ),
      ),
    );
  }
}
