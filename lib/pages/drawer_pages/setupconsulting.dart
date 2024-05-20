import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_assignment/services/setupscheduleService.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetUpConsulting extends StatefulWidget {
  const SetUpConsulting({
    Key? key,
  }) : super(key: key);

  @override
  State<SetUpConsulting> createState() => _SetUpConsultingState();
}

class _SetUpConsultingState extends State<SetUpConsulting> {
  late String userName;
  late String userEmail;
  late String userRole;
  late String userId;
  bool isSubmitting = false;

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> timeSlots = [
    '2:00-4:00 LT',
    '4:00-6:00 LT',
    '7:00-9:00 LT',
    '9:00-12:00 LT',
  ];

  late String selectedDay;
  late String selectedTime;
  List<String> selectedValues = [];
  bool isLoading = true;
  bool showSubmitButton = false; // Track whether to show the submit button

  @override
  void initState() {
    super.initState();
    selectedDay = days.first;
    selectedTime = timeSlots.first;
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userEmail = prefs.getString('user_email') ?? 'Email';
      userRole = prefs.getString('role') ?? 'User';
      userId = prefs.getString('user_id') ?? '0';
    });
    _fetchSchedule();
  }

  final SetUpScheduleService scheduleService = SetUpScheduleService();
  _fetchSchedule() async {
    try {
      List<dynamic> schedule =
          await scheduleService.fetchMySchedule(int.parse(userId));
      schedule.forEach((value) {
        selectedValues.add(value.toString());
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to update the schedule
  void _updateSchedule() async {
    print(selectedValues);
    try {
      bool updated = await scheduleService.updateSchedule(
          int.parse(userId), selectedValues);
      if (updated) {
        setState(() {
          isSubmitting = false;
          selectedValues = [];
          _fetchSchedule();
          showSubmitButton = false;
        });
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set Up Schedule',
          style: TextStyle(color: AppColors.secondary),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Schedule: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: screenSize.width * 0.25,
                  child: DropdownButton<String>(
                    value: selectedDay,
                    onChanged: (value) {
                      setState(() {
                        selectedDay = value!;
                      });
                    },
                    items: days
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: screenSize.width * 0.35,
                  child: DropdownButton<String>(
                    value: selectedTime,
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value!;
                      });
                    },
                    items: timeSlots
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4)),
                  height: screenSize.width * 0.1,
                  width: screenSize.width * 0.2,
                  child: TextButton(
                      onPressed: () {
                        // Check if the selected value already exists
                        String newValue = '$selectedDay - $selectedTime';
                        if (!selectedValues.contains(newValue)) {
                          setState(() {
                            selectedValues.add(newValue);
                            showSubmitButton = true;
                          });
                        } else {
                          // If value already exists, show a popup
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: AppColors.white,
                                title: const Center(
                                  child: Text('Schedule Already Added'),
                                ),
                                content: const Text(
                                    'The selected value is already in the list. try again with another value'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: screenSize.width * 0.04),
                      )),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Selected Values:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedValues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selectedValues[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          selectedValues.removeAt(index);
                          showSubmitButton = true;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            if (showSubmitButton) // Show button conditionally
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4)),
                    height: screenSize.width * 0.1,
                    width: screenSize.width * 0.7,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isSubmitting = true;
                          });
                          _updateSchedule();
                        },
                        child: isSubmitting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                'Update',
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: screenSize.width * 0.04),
                              ),
                      ),
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
