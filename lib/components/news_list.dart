import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:visitor_management/constaints.dart';
import 'package:visitor_management/model.dart';
import 'package:visitor_management/widgets/news_item.dart';

class NewsList extends StatefulWidget {
  final bool showDesktop;
  const NewsList([this.showDesktop = false]);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<News> _news = []; // Store fetched visitor data
  
Stream<List<Map<String, dynamic>>> getVisitors() {
  final today = DateTime.now();
  final year = today.year;
  final month = today.month;
  final day = today.day;

  // Format the start and end date strings in YYYY-MM-DD format
  final startDateString = '$year-$month-$day';
  final endDateString = '${year}-${month}-${day+1}';

  final visitorsCollection = FirebaseFirestore.instance.collection('visitors');
  return visitorsCollection
    .where('timestamp', isGreaterThanOrEqualTo: startDateString)
    .where('timestamp', isLessThan: endDateString)
    .orderBy('timestamp', descending: true)
    .snapshots()
    .map((snapshot) {
      final visitorDocs = snapshot.docs;
      final visitors = visitorDocs.map((doc) => doc.data()).toList();
      return visitors;
    });
}

  Future<void> _fetchData() async {
    final collection = FirebaseFirestore.instance.collection('visitors');
    final snapshot = await collection.orderBy('timestamp', descending: true).get();
    final documents = snapshot.docs;

    _news = documents.map((doc) => News.fromMap(doc.data())).toList();
    setState(() {}); // Update UI with fetched data
  }

  @override
  void initState() {
    super.initState();
    //getVisitors(); // Fetch data on widget initialization
  }


  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: primaryLight.withAlpha(100),
      padding: EdgeInsets.symmetric(horizontal: componentPadding),
      child: Column(
        children: [
          Container(
            height: topBarHeight,
            child: Row(
              children: [
                widget.showDesktop
                    ? SizedBox.shrink()
                    : IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Visitor List',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(stream: FirebaseFirestore.instance.collection('visitors').snapshots(), builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final documents = snapshot.data!.docs;
                final visitors = documents.map((doc) => doc.data()).toList();
                return Column(
                  children: visitors.map((e) => NewsItem(News.fromMap(e as Map<String ,dynamic>))).toList(),
                );
              }),
            ),
          ),
          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Column( 
          //       children: _news.map((e) => NewsItem(e)).toList(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}