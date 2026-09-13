import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';

/// 各スタイルが [fontFamily] を個別に持っているのは、`Theme` を経由せず
/// `style:` に直接渡した箇所が既定フォントに落ちるのを防ぐため。
/// 「フォントはすべて Noto Sans JP」が課題の要件のため冗長を許容している。
abstract final class AppTextStyles {
  static const fontFamily = 'NotoSansJP';

  static const title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 40 / 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textRegular,
  );

  /// 実データに line-height の指定が無いため [height] を持たせていない。
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: AppColors.textRegular,
  );

  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    color: AppColors.textLight,
  );

  /// `labelSmall` に登録しているが読む箇所は無い。[A02] の文字サイズの一覧を写したものとして残している。
  static const minimum = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    color: AppColors.textLight,
  );

  /// 文字色はバリアントごとに異なるため持たせていない。
  static const buttonLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    height: 1,
    fontWeight: FontWeight.bold,
  );

  static const menuItem = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    color: AppColors.textRegular,
  );

  static const menuItemSelected = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.selectedMenuText,
  );

  /// 実データのフォントは Gotham だが配布されていないため Noto Sans JP で代替している。
  static const serviceName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 1,
    fontWeight: FontWeight.bold,
    color: AppColors.serviceName,
  );
}
