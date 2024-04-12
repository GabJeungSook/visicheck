// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:visitor_management/constaints.dart';
import 'package:visitor_management/model.dart';

class SideBarMenuItem extends StatefulWidget {
  final MenuItem item;
  final bool isDesktop;
  final bool isActive;
  final List<Color> defaultColor;

  const SideBarMenuItem({
    Key? key,
    required this.item,
    required this.isDesktop,
    required this.isActive,
    required this.defaultColor,
  }) : super(key: key);


  // SideBarMenuItem(this.item, [this.isDesktop = false], this.isActive = false);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<SideBarMenuItem> {
  var _bgColor = Colors.transparent;
  var _iconColor = Colors.white;

  @override
  void initState() {
   
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        // onEnter: (e) {
        //   widget.isActive ? null:
        //   setState(() {
        //     _bgColor = Colors.white;
        //     _iconColor = primary;
        //   });
        // },
        // onExit: (e) {
        //             widget.isActive ? null:
        //   setState(() {
        //     _bgColor = Colors.transparent;
        //     _iconColor = Colors.white;
        //   });
        // },
        child: Container(
          width: widget.isDesktop ? null : 44,
          height: 44,
          padding: EdgeInsets.symmetric(horizontal: 8),
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              color: widget.defaultColor[0], borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: widget.isDesktop
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(
                widget.item.icon,
                size: 20,
                color: widget.defaultColor[1],
              ),
              if (widget.isDesktop) ...[
                SizedBox(
                  width: 16,
                ),
                Text(
                  widget.item.name,
                  style: TextStyle(
                    color: widget.defaultColor[1],
                  ),
                )
              ] else
                SizedBox.shrink(),
            ],
          ),
        ));
  }
}
