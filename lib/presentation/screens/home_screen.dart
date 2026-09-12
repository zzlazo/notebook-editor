import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notebook_editor/core/theme/app_dimens.dart';
import 'package:notebook_editor/core/validation.dart';
import 'package:notebook_editor/models/create_content_dto.dart';
import 'package:notebook_editor/models/update_content_dto.dart';
import 'package:notebook_editor/presentation/components/app_button.dart';
import 'package:notebook_editor/presentation/components/app_icon.dart';
import 'package:notebook_editor/presentation/components/app_icon_button.dart';
import 'package:notebook_editor/presentation/components/app_scaffold.dart';
import 'package:notebook_editor/presentation/components/content_tile.dart';
import 'package:notebook_editor/presentation/components/main_content_body.dart';
import 'package:notebook_editor/presentation/components/main_content_body_form.dart';
import 'package:notebook_editor/presentation/components/main_content_title.dart';
import 'package:notebook_editor/presentation/components/main_content_title_form.dart';
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
    final isEditingTitle = useState<bool>(false);
    final isEditingBody = useState<bool>(false);
    final contents = ref.watch(contentsProvider);
    final isEditingMenu = useState<bool>(false);
    final titleFormKey = useMemoized(() => GlobalKey<FormState>());
    final bodyFormKey = useMemoized(() => GlobalKey<FormState>());
    final isPC = MediaQuery.sizeOf(context).aspectRatio > 1;
    final titleIsValid = TitleValidation.isValid(titleController.text);
    final bodyIsValid = BodyValidation.isValid(bodyController.text);
    return AppScaffold(
      sideberBody: SizedBox(
        width: 100,
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
                              ? AppIconButton(
                                  icon: AppIcon(AppIcons.delete),
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
            isEditingMenu.value
                ? Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppButton.secondary(
                        icon: AppIcon(AppIcons.plus),
                        label: "New Page",
                        onPressed: () {
                          ref
                              .read(contentsProvider.notifier)
                              .create(
                                CreateContentDTO(
                                  title: "無題",
                                  body: "新しいページです。",
                                ),
                              );
                        },
                      ),
                      AppButton.primary(
                        icon: AppIcon(AppIcons.done),
                        label: "Done",
                        onPressed: () {
                          isEditingMenu.value = false;
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton.primary(
                        icon: AppIcon(AppIcons.edit),
                        label: "Edit",
                        onPressed: () {
                          isEditingMenu.value = true;
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
      contentArea: selectedContent?.value == null
          ? SizedBox.shrink()
          : Column(
              spacing: AppDimens.mainVerticalGap,
              children: [
                SizedBox(
                  height: 40,
                  child: isEditingTitle.value
                      ? Form(
                          key: titleFormKey,
                          child: isPC
                              ? Row(
                                  spacing: AppDimens.mainBoxAndButtonGap,
                                  children: [
                                    Expanded(
                                      child: MainContentTitleForm(
                                        maxLength: TitleValidation.maxLength,
                                        minLength: TitleValidation.minLength,
                                        controller: titleController,
                                      ),
                                    ),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        AppButton.normal(
                                          icon: const AppIcon(AppIcons.cancel),
                                          label: 'Cancel',
                                          onPressed: () {
                                            isEditingTitle.value = false;
                                            titleController.text =
                                                selectedContent!.value!.title;
                                          },
                                          width: AppDimens.buttonMinWidth,
                                        ),
                                        AppButton.primary(
                                          icon: const AppIcon(AppIcons.save),
                                          label: 'Save',
                                          onPressed:
                                              // ignore: prefer_is_empty
                                              titleIsValid
                                              ? () async {
                                                  if (!titleFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    return;
                                                  }
                                                  await ref
                                                      .read(
                                                        contentsProvider
                                                            .notifier,
                                                      )
                                                      .save(
                                                        selectedContentId
                                                            .value!,
                                                        UpdateContentDTO(
                                                          title: titleController
                                                              .text,
                                                          body: selectedContent!
                                                              .value!
                                                              .body,
                                                        ),
                                                      );
                                                  isEditingTitle.value = false;
                                                  titleController.text =
                                                      selectedContent
                                                          .value!
                                                          .title;
                                                }
                                              : null,
                                          width: AppDimens.buttonMinWidth,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  spacing: 20,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MainContentTitleForm(
                                      maxLength: TitleValidation.maxLength,
                                      minLength: TitleValidation.minLength,
                                      controller: titleController,
                                    ),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        AppButton.normal(
                                          icon: const AppIcon(AppIcons.cancel),
                                          label: 'Cancel',
                                          onPressed: () {
                                            isEditingTitle.value = false;
                                            titleController.text =
                                                selectedContent!.value!.title;
                                          },
                                          width: AppDimens.buttonMinWidth,
                                        ),
                                        AppButton.primary(
                                          icon: const AppIcon(AppIcons.save),
                                          label: 'Save',
                                          onPressed:
                                              // ignore: prefer_is_empty
                                              titleIsValid
                                              ? () async {
                                                  if (!titleFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    return;
                                                  }
                                                  await ref
                                                      .read(
                                                        contentsProvider
                                                            .notifier,
                                                      )
                                                      .save(
                                                        selectedContentId
                                                            .value!,
                                                        UpdateContentDTO(
                                                          title: titleController
                                                              .text,
                                                          body: selectedContent!
                                                              .value!
                                                              .body,
                                                        ),
                                                      );
                                                  isEditingTitle.value = false;
                                                  titleController.text =
                                                      selectedContent
                                                          .value!
                                                          .title;
                                                }
                                              : null,
                                          width: AppDimens.buttonMinWidth,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        )
                      : isPC
                      ? Row(
                          spacing: AppDimens.mainBoxAndButtonGap,
                          children: [
                            Expanded(
                              child: MainContentTitle(
                                title: selectedContent!.value!.title,
                              ),
                            ),
                            AppButton.primary(
                              icon: AppIcon(AppIcons.edit),
                              label: "Edit",
                              onPressed: () {
                                isEditingTitle.value = true;
                              },
                            ),
                          ],
                        )
                      : Column(
                          spacing: AppDimens.mainBoxAndButtonGap,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MainContentTitle(
                              title: selectedContent!.value!.title,
                            ),
                            AppButton.primary(
                              icon: AppIcon(AppIcons.edit),
                              label: "Edit",
                              onPressed: () {
                                isEditingTitle.value = true;
                              },
                            ),
                          ],
                        ),
                ),
                Expanded(
                  child: isEditingBody.value
                      ? Form(
                          key: bodyFormKey,
                          child: isPC
                              ? Row(
                                  spacing: 20,
                                  children: [
                                    Expanded(
                                      child: MainContentBodyForm(
                                        minLength: 5,
                                        maxLength: 2000,
                                        controller: bodyController,
                                      ),
                                    ),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        AppButton.normal(
                                          icon: const AppIcon(AppIcons.cancel),
                                          label: 'Cancel',
                                          onPressed: () {
                                            isEditingBody.value = false;
                                            bodyController.text =
                                                selectedContent!.value!.body;
                                          },
                                          width: AppDimens.buttonMinWidth,
                                        ),
                                        AppButton.primary(
                                          icon: const AppIcon(AppIcons.save),
                                          label: 'Save',
                                          onPressed: bodyIsValid
                                              ? () async {
                                                  if (!bodyFormKey.currentState!
                                                      .validate()) {
                                                    return;
                                                  }
                                                  await ref
                                                      .read(
                                                        contentsProvider
                                                            .notifier,
                                                      )
                                                      .save(
                                                        selectedContentId
                                                            .value!,
                                                        UpdateContentDTO(
                                                          title:
                                                              selectedContent!
                                                                  .value!
                                                                  .title,
                                                          body: bodyController
                                                              .text,
                                                        ),
                                                      );
                                                  isEditingBody.value = false;
                                                  bodyController.text =
                                                      selectedContent
                                                          .value!
                                                          .body;
                                                }
                                              : null,
                                          width: AppDimens.buttonMinWidth,
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  spacing: AppDimens.mainBoxAndButtonGap,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    MainContentBodyForm(
                                      minLength: 5,
                                      maxLength: 2000,
                                      controller: bodyController,
                                    ),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        AppButton.normal(
                                          icon: const AppIcon(AppIcons.cancel),
                                          label: 'Cancel',
                                          onPressed: () {
                                            isEditingBody.value = false;
                                            bodyController.text =
                                                selectedContent!.value!.body;
                                          },
                                          width: AppDimens.buttonMinWidth,
                                        ),
                                        AppButton.primary(
                                          icon: const AppIcon(AppIcons.save),
                                          label: 'Save',
                                          onPressed: bodyIsValid
                                              ? () async {
                                                  if (!bodyFormKey.currentState!
                                                      .validate()) {
                                                    return;
                                                  }
                                                  await ref
                                                      .read(
                                                        contentsProvider
                                                            .notifier,
                                                      )
                                                      .save(
                                                        selectedContentId
                                                            .value!,
                                                        UpdateContentDTO(
                                                          title:
                                                              selectedContent!
                                                                  .value!
                                                                  .title,
                                                          body: bodyController
                                                              .text,
                                                        ),
                                                      );
                                                  isEditingBody.value = false;
                                                  bodyController.text =
                                                      selectedContent
                                                          .value!
                                                          .body;
                                                }
                                              : null,
                                          width: AppDimens.buttonMinWidth,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        )
                      : isPC
                      ? Row(
                          children: [
                            Expanded(
                              child: MainContentBody(
                                text: selectedContent!.value!.body,
                              ),
                            ),
                            AppButton.primary(
                              icon: AppIcon(AppIcons.edit),
                              label: "Edit",
                              onPressed: () {
                                isEditingBody.value = true;
                              },
                            ),
                          ],
                        )
                      : Column(
                          spacing: AppDimens.mainBoxAndButtonGap,
                          children: [
                            Expanded(
                              child: MainContentBody(
                                text: selectedContent!.value!.body,
                              ),
                            ),
                            AppButton.primary(
                              icon: AppIcon(AppIcons.edit),
                              label: "Edit",
                              onPressed: () {
                                isEditingBody.value = true;
                              },
                            ),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
