import 'package:flutter/material.dart';
import 'package:my_assignment/pages/drawer_pages/requestlist.dart';
import 'package:my_assignment/services/getconsultingService.dart';
import 'package:my_assignment/services/permissionService.dart';
import 'package:my_assignment/themes/colors.dart';
import 'package:my_assignment/widgets/common/infolist.dart';

class PermissionRequestDetail extends StatefulWidget {
  const PermissionRequestDetail({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.phone,
    required this.email,
    required this.accountRole,
    required this.requestedDate,
    required this.requestedRole,
    required this.accountType,
  });

  final int id;
  final String name;
  final String image;
  final String phone;
  final String email;
  final String accountType;
  final String accountRole;
  final String requestedDate;
  final String requestedRole;

  @override
  State<PermissionRequestDetail> createState() =>
      _PermissionRequestDetailState();
}

class _PermissionRequestDetailState extends State<PermissionRequestDetail> {
  late String _selectedDropdownValue;
  List<String> _selectedItems = [];
  List<String> _dropDownItems = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchScheduleTypes();
  }

  Future<void> fetchScheduleTypes() async {
    try {
      List<String> types = await GetConsultingService().fetchConsultingType();
      setState(() {
        _dropDownItems = types;
        _selectedDropdownValue = _dropDownItems[0];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {});
      // Handle the error appropriately
      print('Failed to load schedule types: $e');
    }
  }

  void _showAlertDialog(
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
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
                    builder: (context) => Requestes(),
                  ));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _rejectRequest() async {
    setState(() {
      _isSubmitting = true;
    });
    final userService = UserService();

    try {
      await userService.rejectUser(userId: widget.id);
      setState(() {
        _isSubmitting = false;
      });
      _showSucessDialog(context, 'Sucess', 'Sucessfuly Deleted');
    } catch (e) {
      _showAlertDialog(context, 'Error', 'Faild to Reject Try Again');
    }
  }

  Future<void> _approveUser() async {
    setState(() {
      _isSubmitting = true;
    });
    final userService = UserService();
    try {
      if (widget.requestedRole == 'Media Manager') {
        await userService.approveConsultantUser(
            id: widget.id,
            role: widget.requestedRole,
            selectedValues: _selectedItems);
      } else {
        await userService.approveConsultantUser(
          id: widget.id, // Assuming `name` is the user ID. Adjust if needed.
          role: widget
              .requestedRole, // Assuming role is an int. Adjust if needed.
          selectedValues: _selectedItems,
        );
      }
      print(widget.requestedRole);
      _showSucessDialog(context, 'Success', 'User approved successfully.');
    } catch (e) {
      _showAlertDialog(context, 'Error', 'Failed to approve user: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Detail'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, bottom: 20),
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
                                  label: 'Account Type',
                                  data: widget.accountType),
                              const SizedBox(
                                height: 10,
                              ),
                              InfoList(
                                  label: 'Account Role',
                                  data: widget.accountRole),
                              const SizedBox(
                                height: 10,
                              ),
                              InfoList(
                                  label: 'Requested at',
                                  data: widget.requestedDate),
                              const SizedBox(
                                height: 10,
                              ),
                              InfoList(
                                  label: 'Requested Role',
                                  data: widget.requestedRole),
                              const SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible:
                                    widget.requestedRole != 'Media Manager',
                                child: Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      DropdownButton<String>(
                                        dropdownColor: AppColors.secondary,
                                        value: _selectedDropdownValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedDropdownValue = newValue!;
                                          });
                                        },
                                        items: _dropDownItems
                                            .map<DropdownMenuItem<String>>(
                                              (String option) =>
                                                  DropdownMenuItem<String>(
                                                value: option,
                                                child: Text(
                                                  option,
                                                  style: TextStyle(
                                                      color: AppColors.primary),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        width: screensize.width * 0.2,
                                        height: screensize.width * 0.08,
                                        decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: TextButton(
                                          onPressed: () {
                                            if (_selectedItems.contains(
                                                _selectedDropdownValue)) {
                                              _showAlertDialog(
                                                context,
                                                'Already Added',
                                                'The selected option is already added.',
                                              );
                                            } else {
                                              setState(() {
                                                _selectedItems.add(
                                                    _selectedDropdownValue
                                                        .toString());
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Add',
                                            style: TextStyle(
                                                color: AppColors.secondary),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              // Display selected items below
                              if (_selectedItems.isNotEmpty)
                                ..._selectedItems.map((item) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          item,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: screensize.width * 0.04,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _selectedItems.remove(item);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              const SizedBox(
                                height: 10,
                              ),
                              _isSubmitting
                                  ? CircularProgressIndicator()
                                  : Container(
                                      width: screensize.width * 0.77,
                                      decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: TextButton(
                                        onPressed: () {
                                          if (_selectedItems.isEmpty &&
                                              widget.accountRole ==
                                                  'Consultant') {
                                            _showAlertDialog(context, 'Error',
                                                'You Must Add Atleast 1 Value');
                                          } else {
                                            _approveUser();
                                          }
                                        },
                                        child: Text(
                                          'Approve',
                                          style: TextStyle(
                                              color: AppColors.secondary),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              _isSubmitting
                                  ? CircularProgressIndicator()
                                  : Container(
                                      width: screensize.width * 0.77,
                                      decoration: BoxDecoration(
                                          color: AppColors.error,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: TextButton(
                                        onPressed: () {
                                          _rejectRequest();
                                        },
                                        child: Text(
                                          'Reject',
                                          style: TextStyle(
                                              color: AppColors.secondary),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
