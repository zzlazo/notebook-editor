/// 値は `Design/DesignSpec/index.html` のレイヤーデータから取得している。
abstract final class AppDimens {
  // ── サイドバー ────────────────────────────────────────

  static const sidebarPaddingLeft = 40.0;
  static const sidebarPaddingTop = 30.0;
  static const logoSize = 32.0;

  /// ロゴとサービス名の間隔。
  static const serviceNameGap = 4.0;

  static const sideberVerticalGap = 20.0;

  static const menuTileWidth = 240.0;
  static const menuTileHeight = 44.0;

  /// タイルの左右の内側余白。
  static const menuTilePadding = 10.0;

  /// タイトルと右端のウィジェットの間隔。
  static const menuTileGap = 10.0;

  static const dividerWidth = 1.0;

  /// Edit ボタンを置く下部領域の高さ。
  static const sideberFooterHeight = 60.0;
  static const sideberFooterPadding = 10.0;

  // ── メインエリア ──────────────────────────────────────

  static const contentAreaMarginTop = 30.0;
  static const contentAreaMarginLeft = 40.0;
  static const contentAreaMarginRight = 40.0;
  static const contentAreaPadding = 30.0;
  static const mainBoxAndButtonGap = 20.0;

  static const contentAreaFooterHorizontalMargin = 40.0;
  static const contentAreaFooterHeight = 60.0;

  /// タイトル行 → 本文カード。
  static const titleAndBodyGap = 20.0;

  // ── メインエリア（モバイル） ──────────────────────────
  // 仕様書は PC のみ。PC の値のままだと本文が 1 行 15 文字ほどしか入らないため、横だけ PC の半分にしている。
  // 縦は詰めると読みにくくなるため PC のトークンをそのまま使う。

  static const mobileContentAreaMarginLeft = 20.0;
  static const mobileContentAreaMarginRight = 20.0;
  static const mobileContentAreaPaddingHorizontal = 15.0;
  static const mobileContentTitlePaddingHorizontal = 15.0;
  static const mobileContentBodyPaddingHorizontal = 15.0;

  /// 外側カード → フッター。PC はフッターの高さの中で間隔を取っているため持たない。
  static const mobileContentAreaFooterGap = 20.0;

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

  // ── アイコンのみのボタン ──────────────────────────────

  static const iconButtonSize = 24.0;
  static const iconButtonIconSize = 20.0;

  // ── 入力欄 ────────────────────────────────────────────

  static const inputBorderWidth = 1.0;

  static const contentBodyPadding = 30.0;
  static const contentTitlePaddingHorizontal = 30.0;
}
