import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// 選択中のページとメニュー編集モードは持たせていない。
// ShellRoute に移すと、前者は URL、後者はページを切り替えても残る shell 側に移り、生存期間がここと異なるため。
class ContentEditingState {
  const ContentEditingState._(this._isEditingTitle, this._isEditingBody);

  final ValueNotifier<bool> _isEditingTitle;
  final ValueNotifier<bool> _isEditingBody;

  bool get isEditingTitle => _isEditingTitle.value;
  bool get isEditingBody => _isEditingBody.value;

  void startEditingTitle() => _isEditingTitle.value = true;
  void finishEditingTitle() => _isEditingTitle.value = false;
  void startEditingBody() => _isEditingBody.value = true;
  void finishEditingBody() => _isEditingBody.value = false;

  // ShellRoute に移したら不要になる。go_router のページキーはパスのパターン（`/contents/:id`）なので
  // ID が変わってもページは使い回されるが、子ルートの Widget に ID の key を付ければ状態ごと作り直せる。
  void reset() {
    _isEditingTitle.value = false;
    _isEditingBody.value = false;
  }
}

ContentEditingState useContentEditingState() {
  final isEditingTitle = useState(false);
  final isEditingBody = useState(false);
  return ContentEditingState._(isEditingTitle, isEditingBody);
}
