import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 課題で配布されている `Design/img/icon` の SVG。
abstract final class AppIcons {
  static const edit = 'assets/icons/edit.svg';
  static const save = 'assets/icons/save.svg';
  static const cancel = 'assets/icons/cancel.svg';
  static const done = 'assets/icons/done.svg';
  static const delete = 'assets/icons/delete.svg';
  static const plus = 'assets/icons/plus.svg';

  /// 2 色で構成されているため [AppIcon] では塗り替えられない。
  static const logo = 'assets/icons/logo.svg';
}

/// [IconTheme] の色とサイズを [SvgPicture] に橋渡しする。
/// SVG は単色前提で、元の塗りは無視して上書きする。
class AppIcon extends StatelessWidget {
  const AppIcon(this.asset, {super.key});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final color = theme.color;

    return SvgPicture.asset(
      asset,
      width: theme.size,
      height: theme.size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
