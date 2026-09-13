import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';

// 閲覧時も Text ではなく readOnly の TextField で描画しているのは、編集と切り替えたときに
// 文字位置と折り返しを揃えるため。TextField は contentPadding とは別にカーソル幅などを内部で確保するので、
// Text では一致させられない。
class MainContentBody extends StatelessWidget {
  const MainContentBody({
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
    final borderRadius = BorderRadius.circular(AppDimens.radiusMedium);

    // 背景は filled ではなく Container で塗る。filled だとホバー時に hoverColor が重なる。
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: isEditing ? null : AppColors.contentBodyBackground,
      ),
      child: TextFormField(
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
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(AppDimens.contentBodyPadding),
          // 編集時の枠はテーマに任せる。
          // InputDecorator は OutlineInputBorder かどうかで内側の余白を変えるため、閲覧時も InputBorder.none ではなく
          // テーマと同じ形の枠を線なしで使っている。
          border: isEditing
              ? null
              : OutlineInputBorder(
                  borderRadius: borderRadius,
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
      ),
    );
  }
}
