import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/presentation/components/service_name.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.sideberBody,
    required this.contentTitleArea,
    required this.contentBodyArea,
  });

  final Widget sideberBody;
  final Widget contentTitleArea;
  final Widget contentBodyArea;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30, left: 40, right: 10),
          child: Column(
            spacing: AppDimens.sideberVerticalGap,
            children: [
              ServiceName(),
              Expanded(child: sideberBody),
            ],
          ),
        ),
        VerticalDivider(width: 1, color: AppColors.divider),
        Container(
          color: AppColors.backgroundLight,
          margin: EdgeInsets.only(top: 30, left: 40, right: 40),
          padding: EdgeInsets.all(30),
          child: Column(
            spacing: AppDimens.mainVerticalGap,
            children: [
              SizedBox(height: 40, child: contentTitleArea),
              Expanded(child: contentBodyArea),
              SizedBox(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      ],
    );
  }
}
