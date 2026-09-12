import 'package:notebook_editor/core/result.dart';
import 'package:notebook_editor/models/content.dart';
import 'package:notebook_editor/models/create_content_dto.dart';
import 'package:notebook_editor/models/update_content_dto.dart';
import 'package:notebook_editor/repositories/notebook_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notebook_providers.g.dart';

@riverpod
class ContentsNotifier extends _$ContentsNotifier {
  @override
  Future<List<Content>> build() async {
    final res = await ref.read(notebookRepositoryProvider).getContents();
    return switch (res) {
      Ok(:final value) => value,
      Err(:final error) => throw error,
    };
  }

  Future<void> create(CreateContentDTO createContentDTO) async {
    final res = await ref
        .read(notebookRepositoryProvider)
        .createContent(createContentDTO);
    if (res case Ok(:final value)) {
      state = AsyncData([...?state.value, value]);
    }
  }

  Future<void> save(int id, UpdateContentDTO updateContentDTO) async {
    final res = await ref
        .read(notebookRepositoryProvider)
        .updateContent(id, updateContentDTO);
    if (res case Ok()) {
      state = AsyncData([
        for (final content in state.value ?? <Content>[])
          if (content.id == id)
            content.copyWith(
              title: updateContentDTO.title,
              body: updateContentDTO.body,
            )
          else
            content,
      ]);
    }
  }

  Future<void> delete(int id) async {
    final res = await ref.read(notebookRepositoryProvider).deleteContent(id);
    if (res case Ok()) {
      state = AsyncData([...?state.value?.where((c) => c.id != id)]);
    }
  }
}

@riverpod
Future<Content?> contentById(Ref ref, int id) async {
  final contents = await ref.watch(contentsProvider.future);
  for (final content in contents) {
    if (content.id == id) return content;
  }
  return null;
}
