import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:my_assignment/pages/drawer_pages/consultcontact.dart';
import 'package:my_assignment/services/getconsultingService.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:my_assignment/widgets/common/infolist.dart';

class ConsultingContactDetail extends StatefulWidget {
  const ConsultingContactDetail({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.email,
    required this.accountType,
    required this.accountRole,
    required this.consultingType,
    required this.requestedDate,
    required this.scheduleFor,
  });

  final int id;
  final String name;
  final String image;
  final String phone;
  final String email;
  final String accountType;
  final String accountRole;
  final String consultingType;
  final String requestedDate;
  final String scheduleFor;

  @override
  State<ConsultingContactDetail> createState() =>
      _ConsultingContactDetailstState();
}

class _ConsultingContactDetailstState extends State<ConsultingContactDetail> {
  bool _isSubmitting = false;
  void _makePhoneCall(String phoneNumber) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (res != null) {
      // Check if the call was successful
      if (res) {
        print('Phone call successful');
      } else {
        print('Failed to make phone call');
      }
    }
  }

  Future<void> _rejectRequest() async {
    final consultingservice = GetConsultingService();

    try {
      await consultingservice.markascontacted(userId: widget.id);
      setState(() {
        _isSubmitting = false;
      });
      _showSucessDialog(context, 'Sucess', 'User Marked As Contacted');
    } catch (e) {
      print('Not Deleted');
    }
  }

  void _showSucessDialog(
    BuildContext context,
    String title,
    String message,
  ) {
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
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConsultingContact(),
                  ));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contact Detail'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.secondary,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: AppColors.secondary,
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Center(
              child: Container(
                width: screensize.width * 0.95,
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 40, bottom: 40),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          'https://yosefsahle.gospelinacts.org/api/registeruser/${widget.image}'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 25,
                          fontFamily: 'SanSerf',
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: screensize.width * 0.88,
                      padding:
                          const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                      decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoList(label: 'Name', data: widget.name),
                          const SizedBox(
                            height: 10,
                          ),
                          InfoList(label: 'Phone', data: widget.phone),
                          const SizedBox(
                            height: 10,
                          ),
                          InfoList(label: 'Email', data: widget.email),
                          const SizedBox(
                            height: 10,
                          ),
                          InfoList(
                              label: 'Account Type', data: widget.accountType),
                          const SizedBox(
                            height: 10,
                          ),
                          InfoList(
                              label: 'Account Role', data: widget.accountRole),
                          const SizedBox(
                            height: 10,
                          ),
                          InfoList(
                              label: 'Counsolting Type',
                              data: widget.consultingType),
                          const SizedBox(
                            height: 10,
                          ),
                          InfoList(
                              label: 'Scheduled For', data: widget.scheduleFor),
                          const SizedBox(
                            height: 10,
                          ),
                          InfoList(
                              label: 'Requested at',
                              data: widget.requestedDate),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: screensize.width * 0.77,
                            decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextButton.icon(
                                onPressed: () {
                                  print('object');
                                  _makePhoneCall(widget.phone);
                                },
                                icon: Icon(
                                  Icons.phone,
                                  color: AppColors.primary,
                                ),
                                label: Text(
                                  'Call Now',
                                  style: TextStyle(color: AppColors.primary),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: screensize.width * 0.77,
                            decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isSubmitting = true;
                                    _rejectRequest();
                                  });
                                },
                                child: _isSubmitting
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text(
                                        'Mark As Contacted',
                                        style: TextStyle(
                                            color: AppColors.secondary),
                                      )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
