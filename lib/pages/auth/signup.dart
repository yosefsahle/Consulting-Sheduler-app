import 'package:flutter/material.dart';
import 'package:my_assignment/pages/auth/login.dart';
import 'package:my_assignment/pages/auth/otpVerify.dart';
import 'package:my_assignment/services/otpService.dart';
import 'package:my_assignment/themes/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController phoneNumberController = TextEditingController();
  bool _isOtpSent = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset('assets/images/login.jpg'),
            Text(
              'SIGN UP',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
            ),
            const Text('Welcome back'),
            const SizedBox(
              height: 40,
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
                child: TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
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
                visible: _errorMessage.isNotEmpty,
                child: Text(
                  _errorMessage,
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
                  onPressed: _isOtpSent ? null : signUp,
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
                child: const Text('Already have an account'))
          ],
        ),
      ),
    );
  }

  Future<void> signUp() async {
    setState(() {
      _isOtpSent = true;
      _errorMessage = '';
    });

    try {
      final response = await OTPService().sendOtp(phoneNumberController.text);

      if (response.status == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => OTPVerify(
              token: response.token,
              phone: phoneNumberController.text,
            ),
          ),
        );
      } else {
        setState(() {
          _isOtpSent = false;
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      setState(() {
        _isOtpSent = false;
        _errorMessage = 'Failed to send OTP. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}
