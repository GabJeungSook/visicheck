import 'package:flutter/material.dart';
import 'package:visitor_management/components/news_list.dart';
import 'package:visitor_management/layout/sidebar.dart';
import 'package:visitor_management/layout/topbar.dart';
import 'package:visitor_management/pages/dashboard.dart';
import 'package:visitor_management/pages/department.dart';
import 'package:visitor_management/pages/home.dart';
import 'package:visitor_management/pages/users.dart';
import 'package:visitor_management/pages/visitors.dart';

import '../constaints.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  List<Widget> _pages = [
    Home(), 
    Department(), 
    Users(),
    Visitors(),
  ];

  int initial_page = 0;
  void changePageIndex(int index)
  {


    setState(() {
      initial_page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final _showDesktop = _size.width >= screenXxl;
    return Scaffold(
        body: SafeArea(
      child: Row(
        children: [
          SideBar(changePageIndex: changePageIndex, activeIndex: initial_page),
          Expanded(
            child: _pages[initial_page],
          ),
          Container(
            width: _showDesktop ? newsPageWidth : 0,
            child: NewsList(_showDesktop),
          )
        ],
      ),
    ));
  }
}
