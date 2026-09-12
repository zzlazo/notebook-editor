// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notebook_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notebookApiClient)
final notebookApiClientProvider = NotebookApiClientProvider._();

final class NotebookApiClientProvider
    extends
        $FunctionalProvider<
          NotebookApiClient,
          NotebookApiClient,
          NotebookApiClient
        >
    with $Provider<NotebookApiClient> {
  NotebookApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notebookApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notebookApiClientHash();

  @$internal
  @override
  $ProviderElement<NotebookApiClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotebookApiClient create(Ref ref) {
    return notebookApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotebookApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotebookApiClient>(value),
    );
  }
}

String _$notebookApiClientHash() => r'9cc5710cab67b06c107d291cec9fb5bb7ef02296';
