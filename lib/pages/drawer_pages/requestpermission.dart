import 'package:flutter/material.dart';
import 'package:my_assignment/services/existancechecker.dart';
import 'package:my_assignment/services/permissionrequestService.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPermission extends StatefulWidget {
  const RequestPermission({Key? key}) : super(key: key);

  @override
  State<RequestPermission> createState() => _RequestPermissionState();
}

class _RequestPermissionState extends State<RequestPermission> {
  bool show = true;
  String errorMsg = '';
  String _selectedOption = 'Media Manager';
  bool _isLoading = false;
  bool _isSubmitting = false;
  late String userId;
  late String userRole;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? '0';
      userRole = prefs.getString('user_role') ?? 'Username';
      _checkExistance(); // Check existence after loading user details
    });
  }

  Future<void> _checkExistance() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final checkExistance = ExistanceCheckerService();
      bool exists = await checkExistance.checkexistance(userId);
      setState(() {
        show = !exists;
      });
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to check permission existence';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _requestPermission() async {
    final permissionService = PermissionRequestService();
    try {
      await permissionService.submitPermissionRequest(
          userId: userId, selectedOption: _selectedOption);
      setState(() {
        _isSubmitting = false;
        show = false;
      });
    } catch (e) {
      _showAlertDialog(context, 'Error', 'Failed to submit permission request');
    }
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _validate() {
    if (userRole == _selectedOption) {
      _showAlertDialog(context, 'Error', 'You already have this permission');
    } else if (userRole == 'Admin') {
      _showAlertDialog(context, 'Error', 'You already have permission');
    } else {
      setState(() {
        _isSubmitting = true;
        _requestPermission();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Permission'),
        foregroundColor: AppColors.secondary,
        backgroundColor: AppColors.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: show,
                    child: Column(
                      children: [
                        const Image(
                          height: 250,
                          image: AssetImage('assets/images/permission.jpg'),
                        ),
                        Text(errorMsg),
                        Padding(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: Text(
                            'Here You Can Request To Post and Contact Scheduled User if you are permitted. Your Role will come on the Drawer',
                            style: TextStyle(color: AppColors.warning),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Request For:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: DropdownButton<String>(
                                value: _selectedOption,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedOption = newValue;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                items: <String>[
                                  'Media Manager',
                                  'Consultant',
                                  'Admin'
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          value,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(width: 24),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            onPressed: () {
                              _validate();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  AppColors.primary),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            child: _isSubmitting
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    'Request',
                                    style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 18),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !show,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/onreview.png',
                          height: 250,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'On Review',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, top: 10),
                          child: Text(
                            'Your request is submitted successfully and is under review for approval. Please be patient with us.',
                            style:
                                TextStyle(color: AppColors.grey, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
