import 'package:flutter/material.dart';
import 'package:my_assignment/model/loginModel.dart';
import 'package:my_assignment/pages/auth/forgetpassword.dart';
import 'package:my_assignment/pages/auth/signup.dart';
import 'package:my_assignment/pages/navigations/mainnav.dart';
import 'package:my_assignment/services/loginService.dart';
import 'package:my_assignment/themes/colors.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool showpass = true;
  String errorMessage = '';
  final TextEditingController emailOrPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false; // Track if login process is loading

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Set isLoading to true when login process starts
      });

      final loginModel = LoginModel(
        emailOrPhone: emailOrPhoneController.text,
        password: passwordController.text,
      );

      bool success = await authService.login(loginModel);

      setState(() {
        isLoading =
            false; // Set isLoading to false when login process completes
      });

      if (success) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MyHomePage(), // Replace with your home screen
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Login failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset('assets/images/login.jpg'),
            Text(
              'SIGN IN',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary),
            ),
            const Text('Welcome back'),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: screensize.width * 0.8,
                      height: 80,
                      child: TextFormField(
                        controller: emailOrPhoneController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Email or Phone'),
                          hintText: 'Email or Phone',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email or phone';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 70,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: showpass,
                        decoration: InputDecoration(
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                showpass = !showpass;
                              });
                            },
                            icon: Icon(showpass
                                ? Icons.remove_red_eye_rounded
                                : Icons.hide_source_rounded),
                          ),
                          border: const OutlineInputBorder(),
                          label: const Text('Password'),
                          hintText: 'Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: errorMessage.isNotEmpty,
              child: Text(
                errorMessage,
                style: TextStyle(color: AppColors.error),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: screensize.width * 0.8,
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5)),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.secondary,
                      ),
                    )
                  : TextButton.icon(
                      onPressed: _login,
                      icon: Icon(
                        Icons.label_important_outlined,
                        color: AppColors.secondary,
                      ),
                      label: Text(
                        'SIGN IN',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ForgetPassword(),
                      ),
                    );
                  },
                  child: const Text('Forget Password?'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const SignUp(),
                      ),
                    );
                  },
                  child: const Text('Dont have an account?'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
