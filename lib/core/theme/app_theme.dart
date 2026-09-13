import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  static final _colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.brand,
    primary: AppColors.brand,
    surface: AppColors.surface,
  );

  static final light = ThemeData(
    visualDensity: VisualDensity.standard,
    fontFamily: AppTextStyles.fontFamily,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: _colorScheme,
    dividerColor: AppColors.divider,

    // 素の Text は bodyMedium を参照するため、Body をそこに割り当てている。
    textTheme: const TextTheme(
      headlineSmall: AppTextStyles.title,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
      labelSmall: AppTextStyles.minimum,
    ),

    // 普通の InputBorder を渡すと、M3 では borderSide が既定値（フォーカス時 2px など）に差し替えられる。
    // WidgetStateInputBorder で返した枠だけは差し替えられないので、線の色と太さを固定するためにこれを使っている。
    // InputDecorationThemeData.outlineBorder は filled でない枠では参照されないため使えない。
    inputDecorationTheme: InputDecorationThemeData(
      border: WidgetStateInputBorder.resolveWith(
        (states) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          // タイトルと本文の左端を contentPadding だけで揃えるため 0 にしている。
          gapPadding: 0,
          borderSide: BorderSide(
            color: states.contains(WidgetState.error)
                ? _colorScheme.error
                : AppColors.brand,
            width: AppDimens.inputBorderWidth,
          ),
        ),
      ),
    ),
  );
}
