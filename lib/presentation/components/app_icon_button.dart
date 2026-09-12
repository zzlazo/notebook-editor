import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/presentation/components/app_button_style.dart';

/// ラベルを持たない小さなボタン。削除アイコンに使う。
///
/// [AppButton] とは寸法も構造も異なるため別コンポーネントにしているが、
/// 状態ごとの色解決は [AppButtonStyle] を共有している。
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.style = AppButtonStyle.icon,
  });

  /// 色とサイズは [IconTheme] で与えるため、呼び出し側は色を指定しない。
  final Widget icon;

  /// null を渡すと disabled になる。
  final VoidCallback? onPressed;

  final AppButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          style.resolveBackground,
        ),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        side: WidgetStatePropertyAll(style.border),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppDimens.radiusSmall),
            ),
          ),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        fixedSize: const WidgetStatePropertyAll(
          Size.square(AppDimens.iconButtonSize),
        ),
        minimumSize: const WidgetStatePropertyAll(
          Size.square(AppDimens.iconButtonSize),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: style.foreground,
          size: AppDimens.iconButtonIconSize,
        ),
        child: SizedBox.square(
          dimension: AppDimens.iconButtonIconSize,
          child: icon,
        ),
      ),
    );

    return onPressed == null
        ? Opacity(opacity: AppColors.disabledOpacity, child: button)
        : button;
  }
}
