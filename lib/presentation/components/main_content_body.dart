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
    required this.scrollController,
    this.focusNode,
    required this.isEditing,
    required this.maxLength,
  });

  final TextEditingController controller;

  /// 外側の [Scrollbar] と TextField 内部のスクロールを繋ぐために共有する。
  final ScrollController scrollController;

  final FocusNode? focusNode;
  final bool isEditing;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppDimens.radiusMedium);

    return ScrollbarTheme(
      data: ScrollbarTheme.of(context).copyWith(
        thumbColor: const WidgetStatePropertyAll(AppColors.scrollbar),
      ),
      // TextField 任せにせず外側で包むのは、フレームワークが自動で付けるのがデスクトップだけで、
      // Android では出ないため。また内側に付くと contentPadding の分だけカードの右端から離れる。
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        // 背景は filled ではなく Container で塗る。filled だとホバー時に hoverColor が重なる。
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isEditing ? null : AppColors.contentBodyBackground,
          ),
          child: ScrollConfiguration(
            behavior: const _NoScrollbarBehavior(),
            child: TextField(
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                required maxLength,
              }) => null,
              controller: controller,
              scrollController: scrollController,
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
            ),
          ),
        ),
      ),
    );
  }
}

// デスクトップで自動のスクロールバーが外側の Scrollbar と二重に出るのを止める。
// ScrollConfiguration.of(context).copyWith(scrollbars: false) では止まらない。
// EditableText が内部で copyWith(scrollbars: true) を重ねて上書きするため、buildScrollbar 自体を差し替えている。
class _NoScrollbarBehavior extends MaterialScrollBehavior {
  const _NoScrollbarBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}
