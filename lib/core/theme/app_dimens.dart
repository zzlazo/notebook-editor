/// 値は `Design/DesignSpec/index.html` のレイヤーデータから取得している。
abstract final class AppDimens {
  // ── サイドバー ────────────────────────────────────────

  /// 区切り線の 1px を含む。
  static const sidebarWidth = 280.0;

  static const sidebarPaddingLeft = 40.0;
  static const sidebarPaddingTop = 30.0;
  static const logoSize = 32.0;

  static const menuTileWidth = 240.0;
  static const menuTileHeight = 44.0;
  static const menuTileTextInset = 10.0;

  static const dividerWidth = 1.0;

  /// Edit ボタンを置く下部領域の高さ。
  static const footerHeight = 60.0;

  // ── メインエリア ──────────────────────────────────────

  static const contentMargin = 30.0;
  static const cardPadding = 30.0;

  // ── 角丸 ──────────────────────────────────────────────

  /// ボタン / メニュー項目
  static const radiusSmall = 4.0;

  /// 本文カード / タイトル入力欄
  static const radiusMedium = 8.0;

  /// 外側カード
  static const radiusLarge = 16.0;

  // ── ボタン [A03] ──────────────────────────────────────

  static const buttonHeight = 40.0;
  static const buttonWidth = 90.0;

  /// アイコンのみの場合。
  static const buttonMinWidth = 40.0;

  static const buttonIconSize = 24.0;
  static const buttonBorderWidth = 2.0;
  static const buttonGap = 10.0;

  /// アイコンとラベルは上寄せで、余りが下に来る。
  static const buttonPaddingTop = 2.0;
  static const buttonPaddingBottom = 4.0;

  // ── 入力欄 ────────────────────────────────────────────

  static const inputBorderWidth = 1.0;
}
