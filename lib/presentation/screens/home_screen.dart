import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    final titleFormKey = useMemoized(() => GlobalKey<FormState>());
    final bodyFormKey = useMemoized(() => GlobalKey<FormState>());
    final isPC = MediaQuery.sizeOf(context).aspectRatio > 1;
    final titleIsValid = TitleValidation.isValid(titleController.text);
    final bodyIsValid = BodyValidation.isValid(bodyController.text);
    final content = selectedContent?.value;

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
                  onPressed: () {
                    ref
                        .read(contentsProvider.notifier)
                        .create(
                          CreateContentDTO(title: "無題", body: "新しいページです。"),
                        );
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
      child: Column(
        children: [
          Expanded(
            child: contents.value == null
                ? SizedBox.shrink()
                : ListView.builder(
                    itemCount: (contents.value!).length,
                    itemBuilder: (context, index) {
                      final content = contents.value![index];
                      return ContentTile(
                        title: content.title,
                        selected: selectedContentId.value == content.id,
                        onTap: () {
                          selectedContentId.value = content.id;
                          titleController.text = content.title;
                          bodyController.text = content.body;
                        },
                        trailing: isEditingMenu.value
                            ? AppDeleteButton(
                                onPressed: () {
                                  ref
                                      .read(contentsProvider.notifier)
                                      .delete(content.id);
                                },
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );

    final contentArea = content == null
        ? SizedBox.shrink()
        : Column(
            spacing: AppDimens.mainVerticalGap,
            children: [
              isEditingTitle.value
                  ? Form(
                      key: titleFormKey,
                      child: section(
                        main: MainContentTitle(
                          controller: titleController,
                          focusNode: titleFocusNode,
                          isEditing: true,
                          maxLength: TitleValidation.maxLength,
                          minLength: TitleValidation.minLength,
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
                                    if (!titleFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    await ref
                                        .read(contentsProvider.notifier)
                                        .save(
                                          selectedContentId.value!,
                                          UpdateContentDTO(
                                            title: titleController.text,
                                            body: content.body,
                                          ),
                                        );
                                    isEditingTitle.value = false;
                                  }
                                : null,
                          ),
                        ],
                      ),
                    )
                  : section(
                      main: MainContentTitle(
                        controller: titleController,
                        isEditing: false,
                        maxLength: TitleValidation.maxLength,
                        minLength: TitleValidation.minLength,
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
                    ? Form(
                        key: bodyFormKey,
                        child: section(
                          main: MainContentBody(
                            controller: bodyController,
                            focusNode: bodyFocusNode,
                            isEditing: true,
                            maxLength: BodyValidation.maxLength,
                            minLength: BodyValidation.minLength,
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
                                      if (!bodyFormKey.currentState!
                                          .validate()) {
                                        return;
                                      }
                                      await ref
                                          .read(contentsProvider.notifier)
                                          .save(
                                            selectedContentId.value!,
                                            UpdateContentDTO(
                                              title: content.title,
                                              body: bodyController.text,
                                            ),
                                          );
                                      isEditingBody.value = false;
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      )
                    : section(
                        main: MainContentBody(
                          controller: bodyController,
                          isEditing: false,
                          maxLength: BodyValidation.maxLength,
                          minLength: BodyValidation.minLength,
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
