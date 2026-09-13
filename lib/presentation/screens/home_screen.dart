import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notebook_editor/core/result.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/validation.dart';
import 'package:notebook_editor/models/create_content_dto.dart';
import 'package:notebook_editor/models/update_content_dto.dart';
import 'package:notebook_editor/presentation/components/app_button.dart';
import 'package:notebook_editor/presentation/components/app_scaffold.dart';
import 'package:notebook_editor/presentation/components/content_tile.dart';
import 'package:notebook_editor/presentation/components/main_content_body.dart';
import 'package:notebook_editor/presentation/components/main_content_section.dart';
import 'package:notebook_editor/presentation/components/main_content_title.dart';
import 'package:notebook_editor/providers/notebook_providers.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContentId = useState<int?>(null);
    final selectedContent = selectedContentId.value == null
        ? null
        : ref.watch(contentByIdProvider(selectedContentId.value!));
    final titleController = useTextEditingController();
    final bodyController = useTextEditingController();
    final titleFocusNode = useFocusNode();
    final bodyFocusNode = useFocusNode();
    final isEditingTitle = useState<bool>(false);
    final isEditingBody = useState<bool>(false);
    final contents = ref.watch(contentsProvider);
    final isEditingMenu = useState<bool>(false);
    final isPC = MediaQuery.sizeOf(context).aspectRatio > 1;
    final titleIsValid = useListenableSelector(
      titleController,
      () => TitleValidation.isValid(titleController.text),
    );
    final bodyIsValid = useListenableSelector(
      bodyController,
      () => BodyValidation.isValid(bodyController.text),
    );
    final content = selectedContent?.value;
    const fetchErrorMessage = "取得に失敗しました";

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

    Widget section({required Widget main, required List<Widget> actions}) {
      return isPC
          ? PCMainContentSection(main: main, actions: actions)
          : MobileMainContentSection(main: main, actions: actions);
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
                selected: selectedContentId.value == content.id,
                onTap: () {
                  if (!context.mounted) return;
                  Scaffold.maybeOf(context)?.closeDrawer();
                  selectedContentId.value = content.id;
                  titleController.text = content.title;
                  bodyController.text = content.body;
                },
                trailing: isEditingMenu.value
                    ? AppDeleteButton(
                        onPressed: () async {
                          final res = await ref
                              .read(contentsProvider.notifier)
                              .delete(content.id);
                          succeeded(res, "ページの削除に失敗しました");
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

    // モバイルではサイドバーが Drawer に隠れるため、開かなくても気づけるようメインエリアにも出す。
    final showsFetchErrorInMain =
        !isPC && !contents.hasValue && contents.hasError;

    final contentArea = content == null
        ? (showsFetchErrorInMain ? Text(fetchErrorMessage) : SizedBox.shrink())
        : Column(
            spacing: AppDimens.mainVerticalGap,
            children: [
              isEditingTitle.value
                  ? section(
                      main: MainContentTitle(
                        controller: titleController,
                        focusNode: titleFocusNode,
                        isEditing: true,
                        maxLength: TitleValidation.maxLength,
                      ),
                      actions: [
                        AppCancelButton(
                          onPressed: () {
                            isEditingTitle.value = false;
                            titleController.text = content.title;
                          },
                        ),
                        AppSaveButton(
                          onPressed: titleIsValid
                              ? () async {
                                  final res = await ref
                                      .read(contentsProvider.notifier)
                                      .save(
                                        selectedContentId.value!,
                                        UpdateContentDTO(
                                          title: titleController.text,
                                          body: content.body,
                                        ),
                                      );
                                  // 失敗時は入力を失わないよう、編集モードのまま残す。
                                  if (succeeded(res, "タイトルの保存に失敗しました")) {
                                    isEditingTitle.value = false;
                                  }
                                }
                              : null,
                        ),
                      ],
                    )
                  : section(
                      main: MainContentTitle(
                        controller: titleController,
                        isEditing: false,
                        maxLength: TitleValidation.maxLength,
                      ),
                      actions: [
                        AppEditButton(
                          onPressed: () {
                            isEditingTitle.value = true;
                            // 編集用のフィールドは次のビルドで作られるので、それを待ってからフォーカスする。
                            // autofocus だと、別のフィールドにフォーカスがあるときに無視される。
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => titleFocusNode.requestFocus(),
                            );
                          },
                        ),
                      ],
                    ),
              Expanded(
                child: isEditingBody.value
                    ? section(
                        main: MainContentBody(
                          controller: bodyController,
                          focusNode: bodyFocusNode,
                          isEditing: true,
                          maxLength: BodyValidation.maxLength,
                        ),
                        actions: [
                          AppCancelButton(
                            onPressed: () {
                              isEditingBody.value = false;
                              bodyController.text = content.body;
                            },
                          ),
                          AppSaveButton(
                            onPressed: bodyIsValid
                                ? () async {
                                    final res = await ref
                                        .read(contentsProvider.notifier)
                                        .save(
                                          selectedContentId.value!,
                                          UpdateContentDTO(
                                            title: content.title,
                                            body: bodyController.text,
                                          ),
                                        );
                                    if (succeeded(res, "本文の保存に失敗しました")) {
                                      isEditingBody.value = false;
                                    }
                                  }
                                : null,
                          ),
                        ],
                      )
                    : section(
                        main: MainContentBody(
                          controller: bodyController,
                          isEditing: false,
                          maxLength: BodyValidation.maxLength,
                        ),
                        actions: [
                          AppEditButton(
                            onPressed: () {
                              isEditingBody.value = true;
                              WidgetsBinding.instance.addPostFrameCallback(
                                (_) => bodyFocusNode.requestFocus(),
                              );
                            },
                          ),
                        ],
                      ),
              ),
            ],
          );

    return isPC
        ? PCAppScaffold(
            sideberBody: sideberBody,
            contentArea: contentArea,
            sideberFooter: sideberFooter(),
          )
        : MobileAppScaffold(
            sideberBody: sideberBody,
            contentArea: contentArea,
            sideberFooter: sideberFooter(),
          );
  }
}
