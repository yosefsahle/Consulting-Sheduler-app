import 'package:flutter/material.dart';
import 'package:my_assignment/pages/auth/login.dart';
import 'package:my_assignment/pages/auth/register.dart';
import 'package:my_assignment/pages/navigations/mainnav.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Login());
  }
}
