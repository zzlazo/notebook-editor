class Env {
  static const String _notebookAuthority = String.fromEnvironment(
    'NOTEBOOK_AUTHORITY',
  );

  static String get notebookAuthority {
    assert(
      _notebookAuthority.isNotEmpty,
      'NOTEBOOK_AUTHORITY が未設定です。'
      '--dart-define=NOTEBOOK_AUTHORITY=localhost:3000 を付けて起動してください。',
    );
    return _notebookAuthority;
  }
}
