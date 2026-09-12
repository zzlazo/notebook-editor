import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';

class MainContentBody extends StatelessWidget {
  const MainContentBody({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      padding: EdgeInsets.all(30),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
