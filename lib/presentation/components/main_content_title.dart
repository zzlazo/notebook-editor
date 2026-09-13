import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';

// 閲覧時も readOnly の TextField で描画している理由は MainContentBody と同じ。
class MainContentTitle extends StatelessWidget {
  const MainContentTitle({
    super.key,
    required this.controller,
    this.focusNode,
    required this.isEditing,
    required this.maxLength,
    required this.minLength,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool isEditing;
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
      controller: controller,
      focusNode: focusNode,
      readOnly: !isEditing,
      maxLength: maxLength,
      maxLines: 1,
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimens.contentTitlePaddingHorizontal,
        ),
        // 閲覧時の枠の理由は MainContentBody と同じ。
        border: isEditing
            ? null
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                gapPadding: 0,
                borderSide: BorderSide.none,
              ),
      ),
      validator: (value) {
        if (value == null || value.length < minLength) {
          return "$minLength文字以上にしてください";
        } else if (value.length > maxLength) {
          return "$maxLength文字以下にしてください";
        }
        return null;
      },
    );
  }
}
