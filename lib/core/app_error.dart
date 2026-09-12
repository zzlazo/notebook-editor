/// 全レイヤー共通のエラー型
sealed class AppError {
  const AppError();
}

/// 通信そのものが成立しなかった（サーバー未起動、ネットワーク断など）。
final class NetworkError extends AppError {
  const NetworkError(this.cause);

  final Object cause;
}

/// 対象のリソースが存在しない。
final class NotFoundError extends AppError {
  const NotFoundError();
}

/// サーバーが 2xx 以外を返した。[statusCode] は表示・ログ用の付加情報。
final class ServerError extends AppError {
  const ServerError(this.statusCode);

  final int statusCode;
}

/// レスポンスが期待した形式ではなかった。
final class ParseError extends AppError {
  const ParseError(this.cause);

  final Object cause;
}
