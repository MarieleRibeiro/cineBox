part of 'favorites_provider.dart';

@ProviderFor(favoritesService)
const favoritesServiceProvider = FavoritesServiceProvider._();

final class FavoritesServiceProvider
    extends
        $FunctionalProvider<
          FavoritesService,
          FavoritesService,
          FavoritesService
        >
    with $Provider<FavoritesService> {
  const FavoritesServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesServiceHash();

  @$internal
  @override
  $ProviderElement<FavoritesService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FavoritesService create(Ref ref) {
    return favoritesService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesService>(value),
    );
  }
}

String _$favoritesServiceHash() => r'6806cce8d303ca51f88e9f0bace53c3257d4976c';

@ProviderFor(FavoritesNotifier)
const favoritesNotifierProvider = FavoritesNotifierProvider._();

final class FavoritesNotifierProvider
    extends $AsyncNotifierProvider<FavoritesNotifier, List<Movie>> {
  const FavoritesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesNotifierHash();

  @$internal
  @override
  FavoritesNotifier create() => FavoritesNotifier();
}

String _$favoritesNotifierHash() => r'81829e8ad6f80d0b4fae7fe033f02f4c2cfc9e77';

abstract class _$FavoritesNotifier extends $AsyncNotifier<List<Movie>> {
  FutureOr<List<Movie>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Movie>>, List<Movie>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Movie>>, List<Movie>>,
              AsyncValue<List<Movie>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
