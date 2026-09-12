import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';

class MainContentBodyForm extends StatelessWidget {
  const MainContentBodyForm({
    super.key,
    this.controller,
    required this.maxLength,
  });

  final TextEditingController? controller;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 30),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.brand, width: 1),
        ),
      ),
    );
  }
}
