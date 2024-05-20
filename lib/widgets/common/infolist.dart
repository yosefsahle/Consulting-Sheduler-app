import 'package:flutter/material.dart';
import 'package:my_assignment/themes/colors.dart';

class InfoList extends StatelessWidget {
  const InfoList({super.key, required this.label, required this.data});

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: TextStyle(color: AppColors.black45, fontSize: 18),
        ),
        Text(
          data,
          style: TextStyle(fontSize: 18, color: AppColors.primary),
        )
      ],
    );
  }
}
