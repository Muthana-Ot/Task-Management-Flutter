import 'package:flutter/material.dart';

class TabItemWidget extends StatelessWidget {
  final String title;
  const TabItemWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          )
        ]
      ),
    );
  }
}