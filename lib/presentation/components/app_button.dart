import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/theme/app_text_styles.dart';
import 'package:notebook_editor/presentation/components/app_button_style.dart';
import 'package:notebook_editor/presentation/components/app_icon.dart';
import 'package:notebook_editor/presentation/components/app_icon_button.dart';

// `default` は予約語で値名に使えないため regular にしている。
enum AppButtonSizeType {
  regular(AppDimens.buttonWidth),
  mini(AppDimens.buttonMinWidth);

  const AppButtonSizeType(this.width);

  final double width;
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.style,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.sizeType = AppButtonSizeType.regular,
  });

  const AppButton.primary({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.sizeType = AppButtonSizeType.regular,
  }) : style = AppButtonStyle.primary;

  const AppButton.secondary({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.sizeType = AppButtonSizeType.regular,
  }) : style = AppButtonStyle.secondary;

  const AppButton.normal({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.sizeType = AppButtonSizeType.regular,
  }) : style = AppButtonStyle.normal;

  final AppButtonStyle style;

  /// 色とサイズは [IconTheme] で与えるため、呼び出し側は色を指定しない。
  final Widget icon;

  final String label;

  /// null を渡すと disabled になる。
  final VoidCallback? onPressed;

  final AppButtonSizeType sizeType;

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          style.resolveBackground,
        ),
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
        fixedSize: WidgetStatePropertyAll(
          Size(sizeType.width, AppDimens.buttonHeight),
        ),

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
              style: AppTextStyles.buttonLabel.copyWith(
                color: style.foreground,
              ),
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

class AppEditButton extends StatelessWidget {
  const AppEditButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      icon: const AppIcon(AppIcons.edit),
      label: 'Edit',
      onPressed: onPressed,
    );
  }
}

class AppSaveButton extends StatelessWidget {
  const AppSaveButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      icon: const AppIcon(AppIcons.save),
      label: 'Save',
      onPressed: onPressed,
      sizeType: AppButtonSizeType.mini,
    );
  }
}

class AppCancelButton extends StatelessWidget {
  const AppCancelButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.normal(
      icon: const AppIcon(AppIcons.cancel),
      label: 'Cancel',
      onPressed: onPressed,
      sizeType: AppButtonSizeType.mini,
    );
  }
}

class AppNewPageButton extends StatelessWidget {
  const AppNewPageButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.secondary(
      icon: const AppIcon(AppIcons.plus),
      label: 'New page',
      onPressed: onPressed,
    );
  }
}

class AppDoneButton extends StatelessWidget {
  const AppDoneButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton.primary(
      icon: const AppIcon(AppIcons.done),
      label: 'Done',
      onPressed: onPressed,
    );
  }
}

class AppDeleteButton extends StatelessWidget {
  const AppDeleteButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: const AppIcon(AppIcons.delete),
      onPressed: onPressed,
    );
  }
}
