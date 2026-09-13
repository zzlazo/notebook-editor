import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:notebook_editor/api_client/notebook_api_client.dart';
import 'package:notebook_editor/core/app_error.dart';
import 'package:notebook_editor/core/result.dart';

const _authority = 'test.invalid';

NotebookApiClient _clientReturning(http.Response response) => NotebookApiClient(
  client: MockClient((_) async => response),
  authority: _authority,
);

Matcher _isOk(Object? value) =>
    isA<Ok<Object?>>().having((r) => r.value, 'value', value);

Matcher _isErr(Matcher error) =>
    isA<Err<Object?>>().having((r) => r.error, 'error', error);

void main() {
  group('成功レスポンス', () {
    test('JSON をデコードして返す', () async {
      final client = _clientReturning(http.Response('[{"id":1}]', 200));

      expect(
        await client.get('content'),
        _isOk([
          {'id': 1},
        ]),
      );
    });

    // charset が無いと http.Response.body は Latin-1 で読むため、それに頼っていないことを確かめる。
    test('charset が無くても日本語を UTF-8 として読む', () async {
      final client = _clientReturning(
        http.Response.bytes(
          utf8.encode('{"title":"坊ちゃん"}'),
          200,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(await client.get('content/1'), _isOk({'title': '坊ちゃん'}));
    });

    test('204 はボディをパースせず null を返す', () async {
      final client = _clientReturning(http.Response('', 204));

      expect(await client.delete('content/1'), _isOk(null));
    });

    test('200 でもボディが空なら null を返す', () async {
      final client = _clientReturning(http.Response('', 200));

      expect(await client.get('content/999'), _isOk(null));
    });
  });

  group('エラーレスポンス', () {
    test('404 は NotFoundError', () async {
      final client = _clientReturning(http.Response('', 404));

      expect(await client.get('content/1'), _isErr(isA<NotFoundError>()));
    });

    for (final statusCode in [400, 500]) {
      test('$statusCode は ServerError', () async {
        final client = _clientReturning(http.Response('', statusCode));

        expect(
          await client.get('content/1'),
          _isErr(
            isA<ServerError>().having(
              (e) => e.statusCode,
              'statusCode',
              statusCode,
            ),
          ),
        );
      });
    }

    test('JSON として読めないボディは ParseError', () async {
      final client = _clientReturning(http.Response('<html>', 200));

      expect(await client.get('content'), _isErr(isA<ParseError>()));
    });

    test('通信が成立しなければ NetworkError', () async {
      final client = NotebookApiClient(
        client: MockClient((_) async => throw http.ClientException('offline')),
        authority: _authority,
      );

      expect(await client.get('content'), _isErr(isA<NetworkError>()));
    });
  });

  group('リクエスト', () {
    test('POST は JSON ボディと Content-Type を付けて送る', () async {
      late http.Request sent;
      final client = NotebookApiClient(
        client: MockClient((request) async {
          sent = request;
          return http.Response('{}', 201);
        }),
        authority: _authority,
      );

      await client.post('content', {'title': '無題', 'body': '本文'});

      expect(sent.method, 'POST');
      expect(sent.url, Uri.http(_authority, 'content'));
      expect(sent.headers['Content-Type'], startsWith('application/json'));
      expect(jsonDecode(sent.body), {'title': '無題', 'body': '本文'});
    });

    test('PUT は JSON ボディと Content-Type を付けて送る', () async {
      late http.Request sent;
      final client = NotebookApiClient(
        client: MockClient((request) async {
          sent = request;
          return http.Response('', 200);
        }),
        authority: _authority,
      );

      await client.put('content/1', {'title': '無題', 'body': '本文'});

      expect(sent.method, 'PUT');
      expect(sent.url, Uri.http(_authority, 'content/1'));
      expect(sent.headers['Content-Type'], startsWith('application/json'));
      expect(jsonDecode(sent.body), {'title': '無題', 'body': '本文'});
    });
  });
}
