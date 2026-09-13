import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/presentation/components/service_name.dart';

class PCAppScaffold extends StatelessWidget {
  const PCAppScaffold({
    super.key,
    required this.sideberBody,
    required this.sideberFooter,
    required this.contentArea,
  });

  final Widget sideberBody;
  final Widget sideberFooter;
  final Widget contentArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: AppDimens.sidebarPaddingLeft + AppDimens.menuTileWidth,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: AppDimens.sidebarPaddingTop,
                      left: AppDimens.sidebarPaddingLeft,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppDimens.sideberVerticalGap,
                      children: [
                        ServiceName(),
                        Expanded(child: sideberBody),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: AppDimens.sideberFooterHeight,
                  color: AppColors.backgroundLight,
                  padding: EdgeInsets.all(AppDimens.sideberFooterPadding),
                  child: sideberFooter,
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: AppDimens.dividerWidth,
            color: AppColors.divider,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusLarge,
                      ),
                    ),
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      top: AppDimens.contentAreaMarginTop,
                      left: AppDimens.contentAreaMarginLeft,
                      right: AppDimens.contentAreaMarginRight,
                    ),
                    padding: EdgeInsets.all(AppDimens.contentAreaPadding),
                    child: contentArea,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppDimens.contentAreaFooterHorizontalMargin,
                  ),
                  height: AppDimens.contentAreaFooterHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Copyright © 2021 Sample",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "運営会社",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MobileAppScaffold extends StatelessWidget {
  const MobileAppScaffold({
    super.key,
    required this.sideberBody,
    required this.sideberFooter,
    required this.contentArea,
  });

  final Widget sideberBody;
  final Widget sideberFooter;
  final Widget contentArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ServiceName()),
      // SafeArea を色の箱ごとに内側へ置き、ステータスバーの下は一覧の白、ジェスチャーバーの下は下部の帯の色で埋める。
      drawer: SizedBox(
        width: AppDimens.menuTileWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ColoredBox(
                color: AppColors.surface,
                child: SafeArea(bottom: false, child: sideberBody),
              ),
            ),
            ColoredBox(
              color: AppColors.backgroundLight,
              child: SafeArea(
                top: false,
                child: Container(
                  height: AppDimens.sideberFooterHeight,
                  padding: EdgeInsets.all(AppDimens.sideberFooterPadding),
                  child: sideberFooter,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: AppDimens.mobileContentAreaFooterGap,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                ),
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: AppDimens.contentAreaMarginTop,
                  left: AppDimens.mobileContentAreaMarginLeft,
                  right: AppDimens.mobileContentAreaMarginRight,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.mobileContentAreaPaddingHorizontal,
                  vertical: AppDimens.contentAreaPadding,
                ),
                child: contentArea,
              ),
            ),
            SizedBox(
              height: AppDimens.contentAreaFooterHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Copyright © 2021 Sample",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text("運営会社", style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
