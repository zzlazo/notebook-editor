import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';

class PCMainContentSection extends StatelessWidget {
  const PCMainContentSection({
    super.key,
    required this.main,
    required this.actions,
  });

  final Widget main;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppDimens.mainBoxAndButtonGap,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: main),
        Row(spacing: AppDimens.buttonGap, children: actions),
      ],
    );
  }
}

class MobileMainContentSection extends StatelessWidget {
  const MobileMainContentSection({
    super.key,
    required this.main,
    required this.actions,
  });

  final Widget main;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppDimens.mainBoxAndButtonGap,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: main),
        if (actions.isNotEmpty)
          Row(
            spacing: AppDimens.buttonGap,
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions,
          ),
      ],
    );
  }
}
