import 'package:flutter/material.dart';

/// 値は `Design/DesignSpec/index.html` のレイヤーデータから取得している。
abstract final class AppColors {
  // ── [A01] カラースキーム ──────────────────────────────

  static const brand = Color(0xFF4CB3F8);
  static const textRegular = Color(0xFF333333);
  static const textLight = Color(0xFF4D4D4D);
  static const buttonNormal = Color(0xFFB3B3B3);
  static const backgroundLight = Color(0xFFF5F8FA);
  static const backgroundDark = Color(0xFFC8E6FA);
  static const contentBodyBackground = Color(0xFFFFFFFF);

  // ── 実画面にのみ現れる値 ──────────────────────────────

  static const surface = Color(0xFFFFFFFF);
  static const selectedMenuText = Color(0xFF32A8F8);
  static const serviceName = Color(0xFF1A1A1A);
  static const scrollbar = Color(0xFFB3B3B3);

  /// 実データは `#F6F8FA` だが、[backgroundLight] と R が 1 違うだけで
  /// 目視では区別できないため、配色の統一を優先して [A01] の値に合わせている。
  static const divider = Color(0xFFF5F8FA);

  // ── [A03] ボタンの状態 ────────────────────────────────

  static const brandHovered = Color(0xFF3C8EC4);
  static const brandPressed = Color(0xFF347CAB);

  static const secondaryHovered = Color(0xFFCCCCCC);
  static const secondaryPressed = Color(0xFFB3B3B3);

  static const normalHovered = Color(0xFF999999);
  static const normalPressed = Color(0xFF808080);

  /// アイコンのみのボタンは通常時に背景を持たないため、background に対応する値がない。
  static const iconHovered = Color(0xFFE6E6E6);
  static const iconPressed = Color(0xFFCCCCCC);

  /// アイコンのみのボタンのアイコン自体の色。
  static const iconForeground = Color(0xFFB3B3B3);

  // ── サイドバーの一覧項目 ──────────────────────────────
  // hover と押下は仕様に定義が無い。[A01] の背景色 2 色の範囲で表現している。

  static const menuTileSelected = Color(0xFFF5F8FA);
  static const menuTileHovered = Color(0xFFF5F8FA);
  static const menuTilePressed = Color(0xFFC8E6FA);

  /// disabled は色を差し替えず不透明度で表現する。バリアント共通。
  static const disabledOpacity = 0.25;
}
