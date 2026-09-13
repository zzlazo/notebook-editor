import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notebook_editor/core/result.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/validation.dart';
import 'package:notebook_editor/models/content.dart';
import 'package:notebook_editor/models/update_content_dto.dart';
import 'package:notebook_editor/presentation/components/app_button.dart';
import 'package:notebook_editor/presentation/components/main_content_body.dart';
import 'package:notebook_editor/presentation/components/main_content_section.dart';
import 'package:notebook_editor/presentation/components/main_content_title.dart';
import 'package:notebook_editor/presentation/hooks/use_content_editing_state.dart';
import 'package:notebook_editor/providers/notebook_providers.dart';

const fetchErrorMessage = "取得に失敗しました";

class ContentScreen extends HookConsumerWidget {
  const ContentScreen({super.key, required this.contentId});

  final int? contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contents = ref.watch(contentsProvider);
    final id = contentId;
    final content = id == null
        ? null
        : ref.watch(contentByIdProvider(id)).value;

    // 一覧が届くまでエディタを作らない。controller は初期値を一度しか受け取らないため、
    // 届く前に作ると空のまま残る。
    if (content != null) {
      // go_router のページキーはパスのパターン（`/contents/:id`）なので、ID が変わってもページは使い回される。
      // ID を key にして、編集状態と controller をページごとに作り直す。
      return _ContentEditor(key: ValueKey(content.id), content: content);
    }

    final isPC = MediaQuery.sizeOf(context).aspectRatio > 1;
    // モバイルではサイドバーが Drawer に隠れるため、開かなくても気づけるようメインエリアにも出す。
    final showsFetchError = !isPC && !contents.hasValue && contents.hasError;
    // 読み込み中と一覧が 0 件のときは、選べるものが無いので促さない。
    final message = showsFetchError
        ? fetchErrorMessage
        : contents.hasValue && contents.requireValue.isNotEmpty
        ? "ページを選択してください"
        : null;

    return message == null ? SizedBox.shrink() : Center(child: Text(message));
  }
}

class _ContentEditor extends HookConsumerWidget {
  const _ContentEditor({super.key, required this.content});

  final Content content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController(text: content.title);
    final bodyController = useTextEditingController(text: content.body);
    final bodyScrollController = useScrollController();
    final titleFocusNode = useFocusNode();
    final bodyFocusNode = useFocusNode();
    final editing = useContentEditingState();
    final isPC = MediaQuery.sizeOf(context).aspectRatio > 1;
    final titlePaddingHorizontal = isPC
        ? AppDimens.contentTitlePaddingHorizontal
        : AppDimens.mobileContentTitlePaddingHorizontal;
    final bodyPaddingHorizontal = isPC
        ? AppDimens.contentBodyPadding
        : AppDimens.mobileContentBodyPaddingHorizontal;
    final titleIsValid = useListenableSelector(
      titleController,
      () => TitleValidation.isValid(titleController.text),
    );
    final bodyIsValid = useListenableSelector(
      bodyController,
      () => BodyValidation.isValid(bodyController.text),
    );

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

    return Column(
      spacing: AppDimens.titleAndBodyGap,
      children: [
        editing.isEditingTitle
            ? section(
                main: MainContentTitle(
                  controller: titleController,
                  focusNode: titleFocusNode,
                  isEditing: true,
                  maxLength: TitleValidation.maxLength,
                  horizontalPadding: titlePaddingHorizontal,
                ),
                actions: [
                  AppCancelButton(
                    onPressed: () {
                      editing.finishEditingTitle();
                      titleController.text = content.title;
                    },
                  ),
                  AppSaveButton(
                    onPressed: titleIsValid
                        ? () async {
                            final res = await ref
                                .read(contentsProvider.notifier)
                                .save(
                                  content.id,
                                  UpdateContentDTO(
                                    title: titleController.text,
                                    body: content.body,
                                  ),
                                );
                            // 失敗時は入力を失わないよう、編集モードのまま残す。
                            if (succeeded(res, "タイトルの保存に失敗しました")) {
                              editing.finishEditingTitle();
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
                  horizontalPadding: titlePaddingHorizontal,
                ),
                actions: [
                  AppEditButton(
                    onPressed: () {
                      editing.startEditingTitle();
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
          child: editing.isEditingBody
              ? section(
                  main: MainContentBody(
                    controller: bodyController,
                    scrollController: bodyScrollController,
                    focusNode: bodyFocusNode,
                    isEditing: true,
                    maxLength: BodyValidation.maxLength,
                    horizontalPadding: bodyPaddingHorizontal,
                  ),
                  actions: [
                    AppCancelButton(
                      onPressed: () {
                        editing.finishEditingBody();
                        bodyController.text = content.body;
                      },
                    ),
                    AppSaveButton(
                      onPressed: bodyIsValid
                          ? () async {
                              final res = await ref
                                  .read(contentsProvider.notifier)
                                  .save(
                                    content.id,
                                    UpdateContentDTO(
                                      title: content.title,
                                      body: bodyController.text,
                                    ),
                                  );
                              if (succeeded(res, "本文の保存に失敗しました")) {
                                editing.finishEditingBody();
                              }
                            }
                          : null,
                    ),
                  ],
                )
              : section(
                  main: MainContentBody(
                    controller: bodyController,
                    scrollController: bodyScrollController,
                    isEditing: false,
                    maxLength: BodyValidation.maxLength,
                    horizontalPadding: bodyPaddingHorizontal,
                  ),
                  actions: [
                    AppEditButton(
                      onPressed: () {
                        editing.startEditingBody();
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
  }
}
