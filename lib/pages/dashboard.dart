import 'package:flutter/material.dart';
import 'package:visitor_management/components/charts.dart';
import 'package:visitor_management/components/status_list.dart';
import 'package:visitor_management/constaints.dart';
import 'package:visitor_management/layout/main_layout.dart';
import '../components/order_table.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StatusList(),
        // Charts(),
        SizedBox(
          height: componentPadding,
        ),
        OrderTable(),
      ],
    ));
  }
}
