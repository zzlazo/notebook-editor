import 'package:notebook_editor/api_client/notebook_api_client.dart';
import 'package:notebook_editor/core/app_error.dart';
import 'package:notebook_editor/core/result.dart';
import 'package:notebook_editor/models/content.dart';
import 'package:notebook_editor/models/create_content_dto.dart';
import 'package:notebook_editor/models/update_content_dto.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notebook_repository.g.dart';

class NotebookRepository {
  final NotebookApiClient _api;
  NotebookRepository(this._api);
  Future<Result<List<Content>>> getContents() async {
    final res = await _api.get("content");
    return switch (res) {
      Ok(:final value) => _parseList(value),
      Err(:final error) => Err(error),
    };
  }

  Result<List<Content>> _parseList(Object? json) {
    try {
      return Ok(
        (json! as List)
            .map((e) => Content.fromJson(e as Map<String, Object?>))
            .toList(),
      );
    } on Object catch (e) {
      return Err(ParseError(e));
    }
  }

  Result<Content> _parseOne(Object? json) {
    try {
      return Ok(Content.fromJson(json! as Map<String, Object?>));
    } on Object catch (e) {
      return Err(ParseError(e));
    }
  }

  Future<Result<Content>> createContent(
    CreateContentDTO createContentDTO,
  ) async {
    final res = await _api.post("content", createContentDTO.toJson());
    return switch (res) {
      Ok(:final value) => _parseOne(value),
      Err(:final error) => Err(error),
    };
  }

  Future<Result<void>> updateContent(
    int id,
    UpdateContentDTO updateContentDTO,
  ) async {
    final res = await _api.put("content/$id", updateContentDTO.toJson());
    return switch (res) {
      Ok() => Ok(null),
      Err(:final error) => Err(error),
    };
  }

  Future<Result<void>> deleteContent(int id) async {
    final res = await _api.delete("content/$id");
    return switch (res) {
      Ok() => Ok(null),
      Err(:final error) => Err(error),
    };
  }
}

@riverpod
NotebookRepository notebookRepository(Ref ref) =>
    NotebookRepository(ref.read(notebookApiClientProvider));
