import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';

class Lab12Pro3 extends StatelessWidget {
  Lab12Pro3({super.key});
  final DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Format'),
      ),
      body: Column(
        children: [
          Text(DateFormat('dd/MM/yyyy').format(currentDate)),
          Text(DateFormat('dd-MM-yyyy').format(currentDate)),
          Text(DateFormat('dd-MMM-yyyy').format(currentDate)),
          Text(DateFormat('dd-MM-yy').format(currentDate)),
          Text(DateFormat('dd MMM, yyyy').format(currentDate))

        ],
      ),
    );
  }
}
