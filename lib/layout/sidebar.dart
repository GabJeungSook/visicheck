// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:visitor_management/constaints.dart';
import 'package:visitor_management/login_page.dart';
import 'package:visitor_management/widgets/sidebar_menu_item.dart';

import '../model.dart';

final List<MenuItem> menuItems = [
  MenuItem('Dashboard', Icons.dashboard_outlined),
  MenuItem('Department', Icons.person),
  MenuItem('Users', Icons.person_add_alt_outlined),
  MenuItem('Visitors', Icons.person_add_alt_outlined),
];

class SideBar extends StatelessWidget {
  // const SideBar({Key? key}) : super(key: key);
  Function changePageIndex;
  int activeIndex;
   SideBar({
    Key? key,
    required this.changePageIndex,
    required this.activeIndex,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final bool _isDesktop = _size.width >= screenLg;
    return Container(
      decoration: const BoxDecoration(color: primary),
      width: _isDesktop ? sideBarDesktopWidth : sideBarMobileWidth,
      padding:
          EdgeInsets.symmetric(vertical: 24, horizontal: _isDesktop ? 10 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: primaryAncient),
            width: 240,
            height: 60,
            child: const Center(
              child: Text(
                'VisiCheck',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                menuItems.map((e) => GestureDetector(
                  onTap: () {
                     changePageIndex(menuItems.indexOf(e));
                     print(""+ menuItems.indexOf(e).toString()+""+activeIndex.toString());
                  
                  },
                  child: SideBarMenuItem(defaultColor:  menuItems.indexOf(e)==activeIndex ? [
                    Colors.white,
                    Colors.black,
                    ] : [
                      Colors.transparent,
                      Colors.black
                    ] , item: e, isDesktop: _isDesktop, isActive: menuItems.indexOf(e)==activeIndex,))).toList(),
          )),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () => _signOut(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout')
            ),
          )
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // After successful sign out, navigate back to login or any desired page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const LoginPage()), // Replace with desired page
      );

      // Optional: Show confirmation message (e.g., using a SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have been signed out.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle sign out errors (optional)
      print(e.message); // For debugging
    }
  }
}
