import 'package:flutter/material.dart';

class EducationInfoScreen extends StatefulWidget {
  const EducationInfoScreen({super.key});

  @override
  State<EducationInfoScreen> createState() => _EducationInfoScreenState();
}

class _EducationInfoScreenState extends State<EducationInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Education Screen "),
      ),
    );
  }
}