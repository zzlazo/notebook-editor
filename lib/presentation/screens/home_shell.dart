import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notebook_editor/core/result.dart';
import 'package:notebook_editor/core/router.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/models/create_content_dto.dart';
import 'package:notebook_editor/presentation/components/app_button.dart';
import 'package:notebook_editor/presentation/components/app_scaffold.dart';
import 'package:notebook_editor/presentation/components/content_tile.dart';
import 'package:notebook_editor/presentation/screens/content_screen.dart';
import 'package:notebook_editor/providers/notebook_providers.dart';

class HomeShell extends HookConsumerWidget {
  const HomeShell({
    super.key,
    required this.selectedContentId,
    required this.navigator,
  });

  final int? selectedContentId;
  final Widget navigator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contents = ref.watch(contentsProvider);
    final isEditingMenu = useState<bool>(false);
    final isPC = MediaQuery.sizeOf(context).aspectRatio > 1;

    // ListView の itemBuilder などは context を引数で上書きするため、
    // 削除で消えるタイルの context ではなく、画面の context を使うようにここで束縛する。
    bool succeeded(Result<void> res, String failureMessage) {
      if (res is Ok) return true;
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(failureMessage)));
      }
      return false;
    }

    void goHome() {
      if (context.mounted) const HomeRoute().go(context);
    }

    Widget sideberFooter() {
      return isEditingMenu.value
          ? Row(
              spacing: AppDimens.buttonGap,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppNewPageButton(
                  onPressed: () async {
                    final res = await ref
                        .read(contentsProvider.notifier)
                        .create(
                          CreateContentDTO(
                            title: "無題",
                            body: "ここに本文を入力してください。",
                          ),
                        );
                    succeeded(res, "ページの作成に失敗しました");
                  },
                ),
                AppDoneButton(
                  onPressed: () {
                    isEditingMenu.value = false;
                  },
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppEditButton(
                  onPressed: () {
                    isEditingMenu.value = true;
                  },
                ),
              ],
            );
    }

    final sideberBody = SizedBox(
      width: double.infinity,
      // 再取得中やエラー時でも前回の一覧を持っていればそれを優先する。
      child: switch (contents) {
        AsyncValue(hasValue: true, requireValue: final items) =>
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final content = items[index];
              return ContentTile(
                title: content.title,
                selected: selectedContentId == content.id,
                onTap: () {
                  if (!context.mounted) return;
                  Scaffold.maybeOf(context)?.closeDrawer();
                  // push の場合、同じページが履歴に重なって積まれるのを防ぐ。
                  if (selectedContentId == content.id) return;
                  ContentRoute(id: content.id).open(context);
                },
                trailing: isEditingMenu.value
                    ? AppDeleteButton(
                        onPressed: () async {
                          final res = await ref
                              .read(contentsProvider.notifier)
                              .delete(content.id);
                          if (succeeded(res, "ページの削除に失敗しました") &&
                              selectedContentId == content.id) {
                            goHome();
                          }
                        },
                      )
                    : null,
              );
            },
          ),
        // Riverpod 3 は取得失敗を自動リトライし、その間は AsyncLoading のまま error を持つ。
        // AsyncError で判定するとリトライを使い切るまで（約 40 秒）表示されない。
        AsyncValue(hasError: true) => Text(fetchErrorMessage),
        _ => SizedBox.shrink(),
      },
    );

    return isPC
        ? PCAppScaffold(
            sideberBody: sideberBody,
            contentArea: navigator,
            sideberFooter: sideberFooter(),
          )
        : MobileAppScaffold(
            sideberBody: sideberBody,
            contentArea: navigator,
            sideberFooter: sideberFooter(),
          );
  }
}
