import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:visitor_management/model.dart';
import 'package:visitor_management/widgets/status_card.dart';
import '../constaints.dart';

final List<BussinessStatus> statusList = [
  BussinessStatus('Total Sales', '1123456 \$', Icons.show_chart_outlined),
  BussinessStatus('Total Profit', '11234 \$', Icons.attach_money_outlined),
  BussinessStatus('Orders', '1236', Icons.shopping_cart_outlined),
  BussinessStatus('Customers', '11234', Icons.people_outline_outlined),
];

class StatusList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(
          height: componentPadding,
        ),
        StaggeredGridView.countBuilder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: componentPadding,
            crossAxisSpacing: componentPadding,
            itemCount: statusList.length,
            itemBuilder: (context, index) => StatusCard(statusList[index]),
            staggeredTileBuilder: (index) {
              if (_size.width > screenXxl) return const StaggeredTile.fit(1);
              if (_size.width > screenSm) return const StaggeredTile.fit(2);
              return const StaggeredTile.fit(4);
            })
      ],
    );
  }
}
