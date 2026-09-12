import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/theme/app_text_styles.dart';

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

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.style,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.width,
  });

  const AppButton.primary({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.width,
  }) : style = AppButtonStyle.primary;

  const AppButton.secondary({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.width,
  }) : style = AppButtonStyle.secondary;

  const AppButton.normal({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.width,
  }) : style = AppButtonStyle.normal;

  final AppButtonStyle style;

  /// 色とサイズは [IconTheme] で与えるため、呼び出し側は色を指定しない。
  final Widget icon;

  final String label;

  /// null を渡すと disabled になる。
  final VoidCallback? onPressed;

  /// 省略すると内容に合わせて縮む（最小 [AppDimens.buttonMinWidth]）。
  final double? width;

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(style.resolveBackground),
        foregroundColor: WidgetStatePropertyAll(style.foreground),
        side: WidgetStatePropertyAll(style.border),

        // 背景色を状態ごとに指定しているため、既定のインク効果が二重に乗らないよう消す。
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),

        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimens.radiusSmall),
            ),
          ),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        minimumSize: const WidgetStatePropertyAll(
          Size(AppDimens.buttonMinWidth, AppDimens.buttonHeight),
        ),
        fixedSize: width == null
            ? null
            : WidgetStatePropertyAll(Size(width!, AppDimens.buttonHeight)),

        // 既定では 48px の最小タップ領域が確保され、仕様の 40px を満たせない。
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,

        // 既定の adaptivePlatformDensity はデスクトップで寸法を縮める。
        visualDensity: VisualDensity.standard,
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppDimens.buttonPaddingTop,
          bottom: AppDimens.buttonPaddingBottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(
                color: style.foreground,
                size: AppDimens.buttonIconSize,
              ),
              child: SizedBox.square(
                dimension: AppDimens.buttonIconSize,
                child: icon,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.buttonLabel.copyWith(color: style.foreground),
            ),
          ],
        ),
      ),
    );

    // disabled は色を差し替えず不透明度で表現する仕様のため、全体を包む。
    return onPressed == null
        ? Opacity(opacity: AppColors.disabledOpacity, child: button)
        : button;
  }
}
