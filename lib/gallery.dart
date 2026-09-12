import 'package:flutter/material.dart';
import 'package:notebook_editor/core/theme/app_colors.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/theme/app_theme.dart';
import 'package:notebook_editor/presentation/components/app_button.dart';
import 'package:notebook_editor/presentation/components/app_button_style.dart';
import 'package:notebook_editor/presentation/components/app_icon.dart';
import 'package:notebook_editor/presentation/components/app_icon_button.dart';
import 'package:notebook_editor/presentation/components/content_tile.dart';
import 'package:notebook_editor/presentation/components/service_name.dart';

/// コンポーネントの見た目を確認するための使い捨てのエントリポイント。
/// hover と pressed は実際にポインタを載せないと確認できないため Chrome で起動する。
///
///   fvm flutter run -d chrome -t lib/gallery.dart --dart-define-from-file=.env.local.web
// コンポーネントは Provider に依存しない方針のため ProviderScope を置かない。
// ignore: missing_provider_scope
void main() => runApp(const GalleryApp());

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      home: const Scaffold(backgroundColor: AppColors.surface, body: _Gallery()),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ServiceName / ロゴ 32px'),
          const SizedBox(height: 8),
          const ServiceName(),
          const SizedBox(height: 40),
          const _Row(
            title: 'primary / 幅 90',
            style: AppButtonStyle.primary,
            asset: AppIcons.edit,
            label: 'Edit',
            width: AppDimens.buttonWidth,
          ),
          const _Row(
            title: 'primary / 幅なし（最小 40）',
            style: AppButtonStyle.primary,
            asset: AppIcons.save,
            label: 'Save',
          ),
          const _Row(
            title: 'secondary / 幅 90',
            style: AppButtonStyle.secondary,
            asset: AppIcons.plus,
            label: 'Add',
            width: AppDimens.buttonWidth,
          ),
          const _Row(
            title: 'normal / 幅なし（最小 40）',
            style: AppButtonStyle.normal,
            asset: AppIcons.cancel,
            label: 'Cancel',
          ),
          const Text('AppIconButton（削除）/ 24px'),
          const SizedBox(height: 8),
          Row(
            children: [
              AppIconButton(
                icon: const AppIcon(AppIcons.delete),
                onPressed: () {},
              ),
              const SizedBox(width: 40),
              const AppIconButton(
                icon: AppIcon(AppIcons.delete),
                onPressed: null,
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text('ContentTile / 幅 240'),
          const SizedBox(height: 8),
          SizedBox(
            width: AppDimens.menuTileWidth,
            child: Column(
              children: [
                ContentTile(
                  title: 'こころ',
                  selected: false,
                  onTap: () {},
                ),
                ContentTile(
                  title: '坊ちゃん',
                  selected: true,
                  onTap: () {},
                ),
                ContentTile(
                  title: '我輩は猫である',
                  selected: false,
                  onTap: () {},
                  trailing: AppIconButton(
                    icon: const AppIcon(AppIcons.delete),
                    onPressed: () {},
                  ),
                ),
                ContentTile(
                  title: 'とても長いタイトルが入力された場合にどこで省略されるかの確認用',
                  selected: false,
                  onTap: () {},
                  trailing: AppIconButton(
                    icon: const AppIcon(AppIcons.delete),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Text('40px に収まっているかの確認（背景の帯がちょうど 40px）'),
          const SizedBox(height: 8),
          ColoredBox(
            color: AppColors.backgroundDark,
            child: SizedBox(
              height: AppDimens.buttonHeight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton.primary(
                    icon: const AppIcon(AppIcons.edit),
                    label: 'Edit',
                    onPressed: () {},
                    width: AppDimens.buttonWidth,
                  ),
                  const SizedBox(width: AppDimens.buttonGap),
                  AppButton.normal(
                    icon: const AppIcon(AppIcons.cancel),
                    label: 'Cancel',
                    onPressed: () {},
                  ),
                  const SizedBox(width: AppDimens.buttonGap),
                  AppButton.primary(
                    icon: const AppIcon(AppIcons.save),
                    label: 'Save',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.style,
    required this.asset,
    required this.label,
    this.width,
  });

  final String title;
  final AppButtonStyle style;
  final String asset;
  final String label;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Row(
            children: [
              _Labeled(
                caption: '通常 / hover / pressed はポインタで確認',
                child: AppButton(
                  style: style,
                  icon: AppIcon(asset),
                  label: label,
                  onPressed: () {},
                  width: width,
                ),
              ),
              const SizedBox(width: 40),
              _Labeled(
                caption: 'disabled',
                child: AppButton(
                  style: style,
                  icon: AppIcon(asset),
                  label: label,
                  onPressed: null,
                  width: width,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Labeled extends StatelessWidget {
  const _Labeled({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        const SizedBox(height: 4),
        Text(caption, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
