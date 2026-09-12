// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notebook_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContentsNotifier)
final contentsProvider = ContentsNotifierProvider._();

final class ContentsNotifierProvider
    extends $AsyncNotifierProvider<ContentsNotifier, List<Content>> {
  ContentsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentsNotifierHash();

  @$internal
  @override
  ContentsNotifier create() => ContentsNotifier();
}

String _$contentsNotifierHash() => r'410f8cc8b741227ceb9374a419f542b8e9158172';

abstract class _$ContentsNotifier extends $AsyncNotifier<List<Content>> {
  FutureOr<List<Content>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Content>>, List<Content>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Content>>, List<Content>>,
              AsyncValue<List<Content>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(contentById)
final contentByIdProvider = ContentByIdFamily._();

final class ContentByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Content?>, Content?, FutureOr<Content?>>
    with $FutureModifier<Content?>, $FutureProvider<Content?> {
  ContentByIdProvider._({
    required ContentByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'contentByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$contentByIdHash();

  @override
  String toString() {
    return r'contentByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Content?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Content?> create(Ref ref) {
    final argument = this.argument as int;
    return contentById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ContentByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$contentByIdHash() => r'6f3ffda3db080214b93151dea012d75655b4de16';

final class ContentByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Content?>, int> {
  ContentByIdFamily._()
    : super(
        retry: null,
        name: r'contentByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ContentByIdProvider call(int id) =>
      ContentByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'contentByIdProvider';
}
