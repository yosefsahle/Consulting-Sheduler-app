import 'package:flutter/material.dart';
import 'package:my_assignment/pages/auth/login.dart';
import 'package:my_assignment/pages/auth/register.dart';
import 'package:my_assignment/services/otpverifyService.dart';
import 'package:my_assignment/themes/colors.dart';

class OTPVerify extends StatefulWidget {
  final String token;
  final String phone;

  const OTPVerify({super.key, required this.token, required this.phone});

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  final TextEditingController _otpController = TextEditingController();
  final OTPVerifyService authService = OTPVerifyService();
  String errorMessage = '';

  void _verifyOtp() async {
    try {
      bool success = await authService.verifyOtp(
          widget.phone, widget.token, _otpController.text);
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => UserRegister(
              phone: widget.phone,
            ),
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Invalid OTP or verification failed.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error during OTP verification.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/images/verify.png'),
            Text(
              'VERIFY OTP',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
            ),
            const Text('Enter the OTP sent to your phone'),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: screensize.width * 0.8,
                height: 50,
                child: TextField(
                  controller: _otpController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('OTP'),
                    hintText: 'OTP',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: errorMessage.isNotEmpty,
              child: Text(
                errorMessage,
                style: TextStyle(color: AppColors.error),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: screensize.width * 0.8,
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5)),
              child: TextButton(
                onPressed: _verifyOtp,
                child: Text(
                  'VERIFY',
                  style: TextStyle(color: AppColors.secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}
