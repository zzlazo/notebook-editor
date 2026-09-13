import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:notebook_editor/api_client/notebook_api_client.dart';
import 'package:notebook_editor/core/app_error.dart';
import 'package:notebook_editor/core/result.dart';
import 'package:notebook_editor/models/content.dart';
import 'package:notebook_editor/models/create_content_dto.dart';
import 'package:notebook_editor/models/update_content_dto.dart';
import 'package:notebook_editor/providers/notebook_providers.dart';

const _timestamp = '2026-01-01T00:00:00.000Z';

Map<String, Object?> _contentJson(int id, String? title, String? body) => {
  'id': id,
  'title': title,
  'body': body,
  'createdAt': _timestamp,
  'updatedAt': _timestamp,
};

http.Response _jsonResponse(Object? json, int statusCode) =>
    http.Response.bytes(utf8.encode(jsonEncode(json)), statusCode);

final _initialContents = [
  _contentJson(1, 'こころ', 'こころの本文です。十文字以上'),
  _contentJson(2, '坊ちゃん', '坊ちゃんの本文です。十文字以上'),
];

const _validTitle = '新しいタイトル';
const _validBody = '新しい本文です。十文字以上あります。';

/// GET は常に [_initialContents] を返し、POST / PUT / DELETE は [mutationStatus] で成否を切り替える。
({ProviderContainer container, List<http.Request> requests}) _setUp({
  int getStatus = 200,
  int? mutationStatus,
}) {
  final requests = <http.Request>[];
  final client = MockClient((request) async {
    requests.add(request);
    if (request.method == 'GET') {
      return getStatus == 200
          ? _jsonResponse(_initialContents, 200)
          : http.Response('', getStatus);
    }
    if (mutationStatus != null) return http.Response('', mutationStatus);
    return switch (request.method) {
      'POST' => () {
        final body = jsonDecode(request.body) as Map<String, Object?>;
        return _jsonResponse(
          _contentJson(3, body['title'] as String, body['body'] as String),
          201,
        );
      }(),
      'PUT' => http.Response('', 200),
      'DELETE' => http.Response('', 204),
      _ => throw StateError('想定外のメソッド: ${request.method}'),
    };
  });

  final container = ProviderContainer.test(
    overrides: [
      notebookApiClientProvider.overrideWithValue(
        NotebookApiClient(client: client, authority: 'test.invalid'),
      ),
    ],
    // 既定では失敗時に自動リトライし、その間 .future が完了しないため、失敗のテストがタイムアウトする。
    retry: (_, _) => null,
  );

  return (container: container, requests: requests);
}

Future<List<Content>> _load(ProviderContainer container) =>
    container.read(contentsProvider.future);

final _isOk = isA<Ok<Object?>>();

Matcher _isErr<E extends AppError>() =>
    isA<Err<Object?>>().having((r) => r.error, 'error', isA<E>());

int _countOf(List<http.Request> requests, String method) =>
    requests.where((r) => r.method == method).length;

void main() {
  group('build', () {
    test('一覧を取得して state に持つ', () async {
      final (:container, :requests) = _setUp();

      final contents = await _load(container);

      expect(contents.map((c) => c.id), [1, 2]);
      expect(contents.first.title, 'こころ');
    });

    test('取得に失敗すると AppError を持つ AsyncError になる', () async {
      final (:container, :requests) = _setUp(getStatus: 500);

      await expectLater(_load(container), throwsA(isA<ServerError>()));
      expect(
        container.read(contentsProvider),
        isA<AsyncError<List<Content>>>(),
      );
    });
  });

  group('create', () {
    test('成功すると一覧の末尾に追加され、contentById で引ける', () async {
      final (:container, :requests) = _setUp();
      await _load(container);

      final res = await container
          .read(contentsProvider.notifier)
          .create(const CreateContentDTO(title: _validTitle, body: _validBody));

      expect(res, _isOk);
      final contents = container.read(contentsProvider).requireValue;
      expect(contents.map((c) => c.id), [1, 2, 3]);
      final created = await container.read(contentByIdProvider(3).future);
      expect(created?.title, _validTitle);
    });

    test('失敗すると Err を返し、一覧は変わらない', () async {
      final (:container, :requests) = _setUp(mutationStatus: 500);
      final before = await _load(container);

      final res = await container
          .read(contentsProvider.notifier)
          .create(const CreateContentDTO(title: _validTitle, body: _validBody));

      expect(res, _isErr<ServerError>());
      expect(container.read(contentsProvider).requireValue, before);
    });

    test('制約を満たさなければ ValidationError を返し、リクエストを送らない', () async {
      final (:container, :requests) = _setUp();
      final before = await _load(container);

      final res = await container
          .read(contentsProvider.notifier)
          .create(const CreateContentDTO(title: '', body: _validBody));

      expect(res, _isErr<ValidationError>());
      expect(_countOf(requests, 'POST'), 0);
      expect(container.read(contentsProvider).requireValue, before);
    });
  });

  group('save', () {
    // 画面が詳細を表示している状態を再現するため、操作の前から contentById を購読しておく。
    test('成功すると対象だけが更新され、購読中の contentById にも反映される', () async {
      final (:container, :requests) = _setUp();
      final before = await _load(container);
      final detail = container.listen(contentByIdProvider(1), (_, _) {});
      await container.read(contentByIdProvider(1).future);

      final res = await container
          .read(contentsProvider.notifier)
          .save(
            1,
            const UpdateContentDTO(title: _validTitle, body: _validBody),
          );

      expect(res, _isOk);
      final contents = container.read(contentsProvider).requireValue;
      expect(contents[0].title, _validTitle);
      expect(contents[0].body, _validBody);
      expect(contents[1], before[1]);
      await container.read(contentByIdProvider(1).future);
      expect(detail.read().requireValue?.title, _validTitle);
    });

    // サーバーは部分更新できないため、変えていない側も必ず送る。
    test('タイトルと本文をセットで送る', () async {
      final (:container, :requests) = _setUp();
      await _load(container);

      await container
          .read(contentsProvider.notifier)
          .save(
            1,
            const UpdateContentDTO(title: _validTitle, body: _validBody),
          );

      final put = requests.singleWhere((r) => r.method == 'PUT');
      expect(put.url.path, '/content/1');
      expect(jsonDecode(put.body), {'title': _validTitle, 'body': _validBody});
    });

    test('失敗すると Err を返し、一覧は変わらない', () async {
      final (:container, :requests) = _setUp(mutationStatus: 500);
      final before = await _load(container);

      final res = await container
          .read(contentsProvider.notifier)
          .save(
            1,
            const UpdateContentDTO(title: _validTitle, body: _validBody),
          );

      expect(res, _isErr<ServerError>());
      expect(container.read(contentsProvider).requireValue, before);
    });

    test('制約を満たさなければ ValidationError を返し、リクエストを送らない', () async {
      final (:container, :requests) = _setUp();
      final before = await _load(container);

      final res = await container
          .read(contentsProvider.notifier)
          .save(1, const UpdateContentDTO(title: _validTitle, body: '短い'));

      expect(res, _isErr<ValidationError>());
      expect(_countOf(requests, 'PUT'), 0);
      expect(container.read(contentsProvider).requireValue, before);
    });
  });

  group('delete', () {
    test('成功すると一覧から除かれ、購読中の contentById は null になる', () async {
      final (:container, :requests) = _setUp();
      await _load(container);
      final detail = container.listen(contentByIdProvider(1), (_, _) {});
      expect((await container.read(contentByIdProvider(1).future))?.id, 1);

      final res = await container.read(contentsProvider.notifier).delete(1);

      expect(res, _isOk);
      final contents = container.read(contentsProvider).requireValue;
      expect(contents.map((c) => c.id), [2]);
      await container.read(contentByIdProvider(1).future);
      expect(detail.read().requireValue, isNull);
    });

    test('失敗すると Err を返し、一覧は変わらない', () async {
      final (:container, :requests) = _setUp(mutationStatus: 500);
      final before = await _load(container);

      final res = await container.read(contentsProvider.notifier).delete(1);

      expect(res, _isErr<ServerError>());
      expect(container.read(contentsProvider).requireValue, before);
    });
  });
}
