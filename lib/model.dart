import 'package:flutter/material.dart';

class MenuItem {
  final String name;
  final IconData icon;

  MenuItem(this.name, this.icon);
}

class Order {
  final IconData icon;
  final String name;
  final int packs;
  final String status;
  final String date;
  Order(this.icon, this.name, this.packs, this.status, this.date);
}

class News {
  final String department;
  final String department_type;
  final String imageUrl;
  final String name;
  final String purpose;
  final String timestamp;

  News({
    required this.department,
    required this.department_type,
    required this.imageUrl,
    required this.name,
    required this.purpose,
    required this.timestamp,
  });

  factory News.fromMap(Map<String, dynamic> data) => News(
        department: data['department'] ?? '', // Handle potential null values
        department_type: data['department_type'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        name: data['name'] ?? '',
        purpose: data['purpose'] ?? '',
         timestamp: data['timestamp'] ?? '',
      );
}

class BussinessStatus {
  final String name;
  final String value;
  final IconData icon;

  BussinessStatus(this.name, this.value, this.icon);
}
