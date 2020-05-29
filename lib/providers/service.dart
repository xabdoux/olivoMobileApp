import 'package:flutter/material.dart';
import '../providers/customer.dart';

class Service {
  final String id;
  Customer customer;
  int tour;
  // bool isPrincipale;
  //final int rendement;
  final DateTime createdAt;
  DateTime deletedAt;

  Service({
    @required this.id,
    @required this.customer,
    @required this.tour,
    // @required this.isPrincipale,
    // this.rendement,
    @required this.createdAt,
    this.deletedAt,
  });
}
