import 'package:flutter/material.dart';
import 'package:my_assignment/themes/colors.dart';

class RequestesCard extends StatefulWidget {
  const RequestesCard(
      {super.key,
      required this.name,
      required this.date,
      required this.type,
      required this.ontap});

  final String name;
  final String date;
  final String type;
  final Function ontap;

  @override
  State<RequestesCard> createState() => _RequestesCardState();
}

class _RequestesCardState extends State<RequestesCard> {
  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    return Center(
        child: Container(
      padding: EdgeInsets.all(5),
      child: Container(
        width: screensize.width * 0.98,
        height: 70,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.type,
                  style: TextStyle(color: AppColors.grey),
                ),
                Text(
                  widget.date,
                  style: TextStyle(color: AppColors.grey),
                )
              ],
            ),
            Container(
              height: 35,
              decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(4)),
              child: TextButton(
                  onPressed: () {
                    widget.ontap();
                  },
                  child: Text('Detail')),
            )
          ],
        ),
      ),
    ));
  }
}
