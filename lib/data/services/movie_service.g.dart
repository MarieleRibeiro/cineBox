// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(movieService)
const movieServiceProvider = MovieServiceProvider._();

final class MovieServiceProvider
    extends $FunctionalProvider<MovieService, MovieService, MovieService>
    with $Provider<MovieService> {
  const MovieServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'movieServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$movieServiceHash();

  @$internal
  @override
  $ProviderElement<MovieService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MovieService create(Ref ref) {
    return movieService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MovieService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MovieService>(value),
    );
  }
}

String _$movieServiceHash() => r'45c696b19630c1eeb0bce258b1cbc84734fa78d5';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
