import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';

class MainContentTitleForm extends StatelessWidget {
  const MainContentTitleForm({
    super.key,
    this.controller,
    required this.maxLength,
    required this.minLength,
  });

  final TextEditingController? controller;
  final int maxLength;
  final int minLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      buildCounter: (
        context, {
        required currentLength,
        required isFocused,
        required maxLength,
      }) => null,
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
      validator: (value) {
        if (value == null || value.length < minLength) {
          return "$minLength文字以上にしてください";
        } else if (value.length > maxLength) {
          return "$minLength文字以下にしてください";
        }
        return null;
      },
    );
  }
}
