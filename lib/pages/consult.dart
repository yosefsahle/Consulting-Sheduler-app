import 'package:flutter/material.dart';
import 'package:my_assignment/services/existancechecker.dart';
import 'package:my_assignment/services/getconsultingService.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Consult extends StatefulWidget {
  const Consult({Key? key});

  @override
  State<Consult> createState() => _ConsultState();
}

class _ConsultState extends State<Consult> {
  late List<String> consultingTypes;
  late List<String> availableDates;
  String? consultingTypesSelect;
  String? availableDatesSelect;
  bool isLoading = true;
  bool isSubmitting = false;
  bool _isOnChange = false;
  late bool onreview;
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    consultingTypes = [];
    availableDates = [];
    consultingTypesSelect = null;
    availableDatesSelect = null;
    fetchScheduleTypes();
  }

  _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? '0';
    });
    _checkExistance();
  }

  Future<void> featchSchduleTime(String type) async {
    try {
      List<String> times =
          await GetConsultingService().fetchAvailableConsultingDates(type);
      setState(() {
        availableDates = times;
        availableDatesSelect = availableDates[0];
        isLoading = false;
        _isOnChange = false;
      });
    } catch (e) {
      setState(() {
        _isOnChange = false;
      });
    }
  }

  Future<void> fetchScheduleTypes() async {
    try {
      List<String> types = await GetConsultingService().fetchConsultingType();
      setState(() {
        consultingTypes = types;
        consultingTypesSelect = consultingTypes[0];
        featchSchduleTime(consultingTypesSelect.toString());
      });
    } catch (e) {}
  }

  Future<void> _checkExistance() async {
    try {
      final checkExistance = ExistanceCheckerService();
      bool exists = await checkExistance.checkexistanceSchedule(userId);
      if (exists) {
        setState(() {
          onreview = true;
        });
      } else {
        setState(() {
          onreview = false;
        });
      }
    } catch (e) {}
  }

  Future<void> _submitSchedule(int Id, String type, String time) async {
    try {
      bool sucess = await GetConsultingService().submitSchedule(Id, type, time);
      if (sucess) {
        setState(() {
          isSubmitting = false;
          onreview = true;
        });
        print('Sucess Full');
      } else {
        print('Faild to Add');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Visibility(
                  visible: !onreview,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          const Image(
                            width: 200,
                            image: AssetImage('assets/images/schedule.jpg'),
                          ),
                          Text(
                            'Schedule',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary, // Use appropriate color
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Schedule your appointment',
                            style: TextStyle(
                                color: AppColors.warning, fontSize: 12),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Schedule Type:',
                                  style: TextStyle(
                                      fontSize: screenSize.width * 0.04),
                                ),
                                const SizedBox(width: 15),
                                DropdownButton<String>(
                                  value: consultingTypesSelect,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  items: consultingTypes.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: screenSize.width * 0.04,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      consultingTypesSelect = newValue;
                                      _isOnChange = true;
                                      availableDatesSelect = null;
                                      featchSchduleTime(newValue.toString());
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _isOnChange
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Available Dates:',
                                        style: TextStyle(
                                            fontSize: screenSize.width * 0.03),
                                      ),
                                      const SizedBox(width: 5),
                                      DropdownButton<String>(
                                        value: availableDatesSelect,
                                        items:
                                            availableDates.map((String item) {
                                          return DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize:
                                                    screenSize.width * 0.035,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            availableDatesSelect = newValue;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: availableDates.isEmpty,
                            child: Text(
                              'No Available Schedule',
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            width: screenSize.width * 0.5,
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    isSubmitting = true;
                                  });
                                  _submitSchedule(
                                      int.parse(userId),
                                      consultingTypesSelect.toString(),
                                      availableDatesSelect.toString());
                                },
                                icon: Icon(
                                  isSubmitting ? null : Icons.arrow_forward,
                                  color: AppColors.secondary,
                                ),
                                label: isSubmitting
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: AppColors.secondary),
                                      )),
                          )
                        ],
                      ),
                    ),
                  )),
              Visibility(
                visible: onreview,
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Image.asset(
                      'assets/images/onreview.png',
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Waiting',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 20, top: 10),
                      child: Text(
                        'Your schedule is Submitted Sucessful and you will be contacted very soon!',
                        style: TextStyle(color: AppColors.grey, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 20, top: 10),
                      child: Text(
                        '🎉 Thank You! 🎉',
                        style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          );
  }

  void _handleSubmit(BuildContext context) {
    // Implement logic to handle form submission
    // For example, validate form fields and submit data
    // This function is called when the submit button is pressed
  }
}
