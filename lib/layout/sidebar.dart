import 'package:flutter/material.dart';
import 'package:visitor_management/constaints.dart';
import 'package:visitor_management/widgets/sidebar_menu_item.dart';

import '../model.dart';

final List<MenuItem> menuItems = [
  MenuItem('Dashboard', Icons.dashboard_outlined),
  MenuItem('Department', Icons.person),
  MenuItem('Users', Icons.person_add_alt_outlined),
  MenuItem('Visitors', Icons.person_add_alt_outlined),
];

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final bool _isDesktop = _size.width >= screenLg;
    return Container(
      decoration: BoxDecoration(color: primary),
      width: _isDesktop ? sideBarDesktopWidth : sideBarMobileWidth,
      padding:
          EdgeInsets.symmetric(vertical: 24, horizontal: _isDesktop ? 10 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: primaryAncient),
            width: 240,
            height: 60,
            child: Center(
              child: Text(
                'VisiCheck',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                menuItems.map((e) => SideBarMenuItem(e, _isDesktop)).toList(),
          ))
        ],
      ),
    );
  }
}
