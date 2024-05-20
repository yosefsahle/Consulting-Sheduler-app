import 'package:flutter/material.dart';
import 'package:my_assignment/themes/colors.dart';

class Feedback extends StatefulWidget {
  const Feedback({super.key});

  @override
  State<Feedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Back'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.secondary,
      ),
    );
  }
}
