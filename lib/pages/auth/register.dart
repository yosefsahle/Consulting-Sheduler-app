import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_assignment/pages/auth/login.dart';
import 'package:my_assignment/services/registrationService.dart';
import 'package:my_assignment/themes/colors.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key, required this.phone});

  final String phone;

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  String _errorMessage = '';
  String _selectedType = 'Personal';
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _registerUser() async {
    setState(() {
      _isLoading = true;
    });

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = widget.phone;
    final String password = _passwordController.text.trim();
    final String userType = _selectedType;
    final String userRole = 'User'; // Assuming a default user role here

    bool success = await RegistrationService().createUser(
      name,
      phone,
      email,
      password,
      userType,
      userRole,
      _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sucessful'),
            content: Text('You have Sucessfully registered.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const Login(),
                    ),
                  );
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _errorMessage = 'Failed to register user.';
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
            GestureDetector(
              onTap: _pickImage,
              child: _image == null
                  ? Column(
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 150,
                          color: Colors.grey,
                        ),
                        Text(
                          'Add Image Here',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    )
                  : CircleAvatar(
                      radius: 75,
                      backgroundImage: FileImage(_image!),
                    ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: screensize.width * 0.8,
                height: 50,
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Full Name'),
                    hintText: 'Full Name',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: screensize.width * 0.8,
                height: 50,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Email'),
                    hintText: 'Email',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: screensize.width * 0.8,
                height: 50,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffix: IconButton(
                        onPressed: () {}, icon: Icon(Icons.remove_red_eye)),
                    border: OutlineInputBorder(),
                    label: Text('Create Password'),
                    hintText: 'Create Password',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SizedBox(
                width: screensize.width * 0.8,
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    suffix: IconButton(
                        onPressed: () {}, icon: Icon(Icons.remove_red_eye)),
                    border: const OutlineInputBorder(),
                    label: const Text('Confirm Password'),
                    hintText: 'Confirm Password',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: screensize.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account Type'),
                    const SizedBox(height: 5),
                    DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedType,
                      items: <String>['Personal', 'Company']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: _isLoading,
              child: CircularProgressIndicator(),
            ),
            Visibility(
              visible: _errorMessage.isNotEmpty,
              child: Text(
                _errorMessage,
                style: TextStyle(color: AppColors.error),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: screensize.width * 0.8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                onPressed: _isLoading ? null : _registerUser,
                child: Text(
                  'REGISTER',
                  style: TextStyle(color: AppColors.secondary),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const Login(),
                  ),
                );
              },
              child: const Text('Already have an account'),
            ),
          ],
        ),
      ),
    );
  }
}
