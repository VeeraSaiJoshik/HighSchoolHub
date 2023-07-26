import 'package:flutter/material.dart';
import 'package:highschoolhub/globalInfo.dart';
class School{
  String address = "";
  String name;
  String image;
  List<int> grades = [];
  List<int> attendedGrades = [];
  School({this.name = "", this.image = "",});
}