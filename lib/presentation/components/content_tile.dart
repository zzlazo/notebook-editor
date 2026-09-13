import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/theme/app_text_styles.dart';

class ContentTile extends StatelessWidget {
  const ContentTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String title;
  final bool selected;
  final VoidCallback? onTap;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;

    return SizedBox(
      height: AppDimens.menuTileHeight,
      width: AppDimens.menuTileWidth,
      child: Material(
        color: selected ? AppColors.menuTileSelected : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),

          splashColor: Colors.transparent,
          hoverColor: AppColors.menuTileHovered,
          highlightColor: AppColors.menuTilePressed,

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.menuTilePadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    // タイトルは最大 50 文字で、タイル幅には収まらない。
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: selected
                        ? AppTextStyles.menuItemSelected
                        : AppTextStyles.menuItem,
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppDimens.menuTileGap),
                  trailing,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
