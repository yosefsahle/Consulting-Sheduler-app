import 'package:flutter/material.dart';
import 'package:my_assignment/pages/others/requestsdetail.dart';
import 'package:my_assignment/services/getschedules.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:my_assignment/widgets/permission/permissionrequestscard.dart';

class ConsultingContact extends StatefulWidget {
  const ConsultingContact({super.key});

  @override
  State<ConsultingContact> createState() => _ConsultingContactState();
}

class _ConsultingContactState extends State<ConsultingContact> {
  late Future<List<Map<String, dynamic>>> _CounsultRequestsFuture;

  @override
  void initState() {
    super.initState();
    _CounsultRequestsFuture =
        GetConsultingRequestService().getPermissionRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulting Contaccts'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _CounsultRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, dynamic>> permissionRequests =
                snapshot.data!;
            return ListView.builder(
              itemCount: permissionRequests.length,
              itemBuilder: (context, index) {
                final permissionRequest = permissionRequests[index];
                return RequestesCard(
                  name: permissionRequest['name'],
                  type: permissionRequest['schedule_type'],
                  date: permissionRequest['scheduled_date'],
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConsultingContactDetail(
                          id: int.parse(permissionRequest['user_id']),
                          name: permissionRequest['name'],
                          image: permissionRequest['image'],
                          phone: permissionRequest['phone'],
                          email: permissionRequest['email'],
                          accountType: permissionRequest['user_type'],
                          accountRole: permissionRequest['role'],
                          requestedDate: permissionRequest['scheduled_date'],
                          consultingType: permissionRequest['schedule_type'],
                          scheduleFor: permissionRequest['schedule_date'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
