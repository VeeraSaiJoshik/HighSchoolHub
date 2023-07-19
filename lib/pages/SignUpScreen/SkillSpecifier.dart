import 'package:flutter/material.dart';

class SkillInfoScreen extends StatefulWidget {
  const SkillInfoScreen({super.key});

  @override
  State<SkillInfoScreen> createState() => _SkillInfoScreenState();
}

class _SkillInfoScreenState extends State<SkillInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Skill Screen "),
      ),
    );
  }
}