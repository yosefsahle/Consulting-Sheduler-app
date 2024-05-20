import 'package:flutter/material.dart';
import 'package:my_assignment/services/getconsultingService.dart';
import 'package:my_assignment/themes/colors.dart';

class ConsultingType extends StatefulWidget {
  const ConsultingType({super.key});

  @override
  State<ConsultingType> createState() => _ConsultingTypeState();
}

class _ConsultingTypeState extends State<ConsultingType> {
  late List<String> consultingType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScheduleTypes();
  }

  Future<void> fetchScheduleTypes() async {
    try {
      List<String> types = await GetConsultingService().fetchConsultingType();
      setState(() {
        consultingType = types;
        _isLoading = false;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Consulting Type'),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.secondary,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: screensize.width * 0.7,
                  height: 50,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Consulting Type'),
                      hintText: 'Consulting Type',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email or phone';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: AppColors.primary),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ],
            ),
            _isLoading
                ? Center(
                    child: LinearProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: consultingType.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  consultingType[index],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColors.error,
                                    ))
                              ],
                            ),
                          );
                        }))
          ],
        ));
  }
}
