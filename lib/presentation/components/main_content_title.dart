import 'package:flutter/material.dart';

class MainContentTitle extends StatelessWidget {
  const MainContentTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
