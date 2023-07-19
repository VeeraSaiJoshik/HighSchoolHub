import 'package:flutter/material.dart';

class ClubInfoScreen extends StatefulWidget {
  const ClubInfoScreen({super.key});

  @override
  State<ClubInfoScreen> createState() => _ClubInfoScreenState();
}

class _ClubInfoScreenState extends State<ClubInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text("Club Screen "),
      ),
    );
  }
}