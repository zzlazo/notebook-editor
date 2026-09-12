import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_text_styles.dart';

abstract final class AppTheme {
  static final light = ThemeData(
    fontFamily: AppTextStyles.fontFamily,
    scaffoldBackgroundColor: AppColors.surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      primary: AppColors.brand,
      surface: AppColors.surface,
    ),
    dividerColor: AppColors.divider,

    // 素の Text は bodyMedium を参照するため、Body をそこに割り当てている。
    textTheme: const TextTheme(
      headlineSmall: AppTextStyles.title,
      bodyMedium: AppTextStyles.body,
      bodySmall: AppTextStyles.caption,
      labelSmall: AppTextStyles.minimum,
    ),
  );
}
