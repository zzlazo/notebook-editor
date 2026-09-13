import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
}

ContentEditingState useContentEditingState() {
  final isEditingTitle = useState(false);
  final isEditingBody = useState(false);
  return ContentEditingState._(isEditingTitle, isEditingBody);
}
