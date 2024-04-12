import 'package:flutter/material.dart';
import 'package:visitor_management/constaints.dart';
import 'package:visitor_management/pages/news.dart';

class TopBar extends StatelessWidget {
  final bool _showDesktop;
  const TopBar([this._showDesktop = false]);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: topBarHeight,
      padding: EdgeInsets.symmetric(horizontal: componentPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ),
                Positioned(
                  child: Container(
                    height: 4,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  bottom: 0,
                  left: 0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
