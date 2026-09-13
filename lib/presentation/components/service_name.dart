import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/theme/app_text_styles.dart';
import 'package:notebook_editor/presentation/components/app_icon.dart';

class ServiceName extends StatelessWidget {
  const ServiceName({super.key});

  static const label = 'ServiceName';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          AppIcons.logo,
          width: AppDimens.logoSize,
          height: AppDimens.logoSize,
        ),
        const SizedBox(width: AppDimens.serviceNameGap),
        const Text(label, style: AppTextStyles.serviceName),
      ],
    );
  }
}
