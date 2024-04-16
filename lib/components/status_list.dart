import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:visitor_management/model.dart';
import 'package:visitor_management/widgets/status_card.dart';
import '../constaints.dart';

class StatusList extends StatefulWidget {
  @override
  _StatusListState createState() => _StatusListState();
}

class _StatusListState extends State<StatusList> {
  int userCount = 0;
  int visitorCount = 0;
  StreamSubscription<QuerySnapshot<Object?>>? _userSubscription;
  StreamSubscription<QuerySnapshot<Object?>>? _visitorSubscription;

  @override
  void initState() {
    super.initState();
    try {
      _fetchData();
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _fetchData() async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final visitorCollection = FirebaseFirestore.instance.collection('visitors');

    _userSubscription = userCollection.snapshots().listen((snapshot) {
      setState(() {
        userCount = snapshot.docs.length;
      });
    });

    _visitorSubscription = visitorCollection.snapshots().listen((snapshot) {
      setState(() {
        visitorCount = snapshot.docs.length;
      });
    });
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _visitorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final List<BussinessStatus> statusList = [
      BussinessStatus('Users', userCount.toString(), Icons.people_outline_outlined),
      BussinessStatus('Visitors', visitorCount.toString(), Icons.people_outline_outlined),
    ];
    return Column(
      children: [
        const SizedBox(
          height: componentPadding,
        ),
        StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: componentPadding,
          crossAxisSpacing: componentPadding,
          itemCount: statusList.length,
          itemBuilder: (context, index) => StatusCard(statusList[index]),
          staggeredTileBuilder: (index) =>
              _size.width > screenXxl ? const StaggeredTile.fit(1) : const StaggeredTile.fit(2),
        ),
      ],
    );
  }
}