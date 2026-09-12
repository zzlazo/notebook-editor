import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notebook_editor/core/app_error.dart';
import 'package:notebook_editor/core/env.dart';
import 'package:notebook_editor/core/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notebook_api_client.g.dart';

class NotebookApiClient {
  NotebookApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  final http.Client _client;

  Future<Result<Object?>> get(String path) =>
      _send(() => _client.get(_uri(path)));

  Future<Result<Object?>> post(String path, Map<String, Object?> body) => _send(
    () =>
        _client.post(_uri(path), headers: _jsonHeaders, body: jsonEncode(body)),
  );

  Future<Result<Object?>> put(String path, Map<String, Object?> body) => _send(
    () =>
        _client.put(_uri(path), headers: _jsonHeaders, body: jsonEncode(body)),
  );

  Future<Result<Object?>> delete(String path) =>
      _send(() => _client.delete(_uri(path)));

  void close() => _client.close();

  Uri _uri(String path) => Uri.http(Env.notebookAuthority, path);

  Future<Result<Object?>> _send(
    Future<http.Response> Function() request,
  ) async {
    final http.Response response;
    try {
      response = await request();
    } on Exception catch (e) {
      // dart:io の SocketException は Web でビルドできないため、
      // Exception でまとめて捕まえる。
      return Err(NetworkError(e));
    }

    final statusCode = response.statusCode;
    if (statusCode == 404) {
      return Err(const NotFoundError());
    }
    if (statusCode < 200 || statusCode >= 300) {
      return Err(ServerError(statusCode));
    }

    // DELETE は 204 でボディを返さない。
    if (response.bodyBytes.isEmpty) {
      return const Ok(null);
    }

    try {
      return Ok(jsonDecode(utf8.decode(response.bodyBytes)));
    } on FormatException catch (e) {
      return Err(ParseError(e));
    }
  }
}

@riverpod
NotebookApiClient notebookApiClient(Ref ref) => NotebookApiClient();
