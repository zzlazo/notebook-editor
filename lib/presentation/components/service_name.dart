import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/theme/app_text_styles.dart';
import 'package:notebook_editor/presentation/components/app_icon.dart';

/// サイドバー左上のロゴとサービス名。
class ServiceName extends StatelessWidget {
  const ServiceName({super.key});

  /// 実在のサービス名が与えられていないため、デザイン仕様の文字列をそのまま使う。
  /// 呼び出し側から差し替える必要が出るまでは引数にしない。
  static const label = 'ServiceName';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 円と S の 2 色で構成されているため [AppIcon] は通さない。
        // 単色で塗り替えると S が背景に溶けて消える。
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
