import 'package:flutter/material.dart';
import 'package:my_assignment/pages/auth/login.dart';
import 'package:my_assignment/themes/colors.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    String errorMessage = '';
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              'assets/images/forgetpassword.jpg',
            ),
            Text(
              'FORGET PASSWORD',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning),
            ),
            const Text('Reset Your Password'),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Your Phone Number',
              style: TextStyle(fontSize: 20, color: AppColors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                width: screensize.width * 0.8,
                height: 50,
                child: const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Phone'),
                      hintText: 'Phone'),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
                visible: true,
                child: Text(
                  errorMessage,
                  style: TextStyle(color: AppColors.error),
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: screensize.width * 0.8,
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'GET VERIFICATION CODE',
                    style: TextStyle(color: AppColors.secondary),
                  )),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const Login(),
                    ),
                  );
                },
                child: Text('Already have an account'))
          ],
        ),
      ),
    );
  }
}
