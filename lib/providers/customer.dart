import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/palette.dart';

class Customer {
  String id;
  String fullName;
  String phoneNumber;
  List<Palette> palettes;

  Customer({
    @required this.id,
    @required this.fullName,
    @required this.phoneNumber,
    @required this.palettes,
  });
}
