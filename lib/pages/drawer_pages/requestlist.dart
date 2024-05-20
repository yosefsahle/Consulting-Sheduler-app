import 'package:flutter/material.dart';
import 'package:my_assignment/pages/others/requestdetailpermission.dart';
import 'package:my_assignment/services/getpermissionrequestService.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:my_assignment/widgets/permission/permissionrequestscard.dart';

class Requestes extends StatefulWidget {
  const Requestes({Key? key}) : super(key: key);

  @override
  State<Requestes> createState() => _RequestesState();
}

class _RequestesState extends State<Requestes> {
  late Future<List<Map<String, dynamic>>> _permissionRequestsFuture;

  @override
  void initState() {
    super.initState();
    _permissionRequestsFuture =
        GetPermissionRequestService().getPermissionRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _permissionRequestsFuture,
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
                  name: permissionRequest['name'] ?? '',
                  type: permissionRequest['Permission_type'] ?? '',
                  date: permissionRequest['date'] ?? '',
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PermissionRequestDetail(
                          id: int.parse(permissionRequest['User_Id']) ?? 0,
                          name: permissionRequest['name'] ?? '',
                          image: permissionRequest['image'] ?? '',
                          phone: permissionRequest['phone'] ?? '',
                          email: permissionRequest['email'] ?? '',
                          accountType: permissionRequest['user_type'] ?? '',
                          accountRole: permissionRequest['role'] ?? '',
                          requestedDate: permissionRequest['date'] ?? '',
                          requestedRole:
                              permissionRequest['Permission_type'] ?? '',
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
