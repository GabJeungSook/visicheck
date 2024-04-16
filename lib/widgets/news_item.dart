import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:visitor_management/constaints.dart';
import 'package:visitor_management/model.dart';

class NewsItem extends StatelessWidget {
  final News data;
  const NewsItem(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            child: Image.asset('imgs/visitor.png'),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: primary,
                ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.name}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Purpose: ${data.purpose}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                 Text(
                  'Visitor Type: ${data.department}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
                 const SizedBox(
                  height: 4,
                ),
                 Text(
                  'Destination: ${data.department_type}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                ),
                 const SizedBox(
                  height: 4,
                ),
                Text(
                 data.timestamp != null
                  ? DateFormat('MMMM dd, yyyy hh:mm a').format(DateTime.parse(data.timestamp))
                  : '',
                  style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic,
                      fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
