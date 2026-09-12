import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';

/// ボタンの配色。どのボタンかではなく、どの配色かを表す。
/// 実画面では同じ配色が別の用途で使い回されるため、役割名では分けない。
class AppButtonStyle {
  const AppButtonStyle({
    required this.background,
    required this.hovered,
    required this.pressed,
    required this.foreground,
    this.border = BorderSide.none,
  });

  /// 青塗り。Edit / Save / Done に使われている。
  static const primary = AppButtonStyle(
    background: AppColors.brand,
    hovered: AppColors.brandHovered,
    pressed: AppColors.brandPressed,
    foreground: AppColors.surface,
  );

  /// 白地に青枠。「＋」に使われている。
  static const secondary = AppButtonStyle(
    background: AppColors.surface,
    hovered: AppColors.secondaryHovered,
    pressed: AppColors.secondaryPressed,
    foreground: AppColors.brand,
    border: BorderSide(
      color: AppColors.brand,
      width: AppDimens.buttonBorderWidth,
    ),
  );

  /// グレー塗り。Cancel に使われている。
  static const normal = AppButtonStyle(
    background: AppColors.buttonNormal,
    hovered: AppColors.normalHovered,
    pressed: AppColors.normalPressed,
    foreground: AppColors.surface,
  );

  /// アイコンのみ。通常時は背景を持たない。削除ボタンに使われている。
  static const icon = AppButtonStyle(
    background: Colors.transparent,
    hovered: AppColors.iconHovered,
    pressed: AppColors.iconPressed,
    foreground: AppColors.iconForeground,
  );

  final Color background;
  final Color hovered;
  final Color pressed;
  final Color foreground;
  final BorderSide border;

  Color resolveBackground(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) return pressed;
    if (states.contains(WidgetState.hovered)) return hovered;
    return background;
  }
}
