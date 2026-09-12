import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';

class MainContentTitleForm extends StatelessWidget {
  const MainContentTitleForm({
    super.key,
    this.controller,
    required this.maxLength,
  });

  final TextEditingController? controller;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      maxLines: 1,
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.brand, width: 1),
        ),
      ),
    );
  }
}
