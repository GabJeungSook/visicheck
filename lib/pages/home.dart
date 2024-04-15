import 'package:flutter/material.dart';
import 'package:visitor_management/components/order_table.dart';
import 'package:visitor_management/components/status_list.dart';
import 'package:visitor_management/constaints.dart';

class Home extends StatelessWidget {
const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
     return Container(
      padding: EdgeInsets.only(left: componentPadding, right: componentPadding, top: 50),
       child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusList(),
        // Charts(),
        SizedBox(
          height: componentPadding,
        ),
        OrderTable(),
      ],
    )
    );
  }
}