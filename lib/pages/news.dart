import 'package:flutter/material.dart';
import 'package:visitor_management/components/news_list.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NewsList(),
    );
  }
}
