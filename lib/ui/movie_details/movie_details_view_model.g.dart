// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(movieDetails)
const movieDetailsProvider = MovieDetailsFamily._();

final class MovieDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<MovieDetails>,
          MovieDetails,
          FutureOr<MovieDetails>
        >
    with $FutureModifier<MovieDetails>, $FutureProvider<MovieDetails> {
  const MovieDetailsProvider._({
    required MovieDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'movieDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$movieDetailsHash();

  @override
  String toString() {
    return r'movieDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MovieDetails> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MovieDetails> create(Ref ref) {
    final argument = this.argument as int;
    return movieDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MovieDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$movieDetailsHash() => r'7d0641e3ea70290345033982ee9fbd900bfee464';

final class MovieDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MovieDetails>, int> {
  const MovieDetailsFamily._()
    : super(
        retry: null,
        name: r'movieDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MovieDetailsProvider call(int movieId) =>
      MovieDetailsProvider._(argument: movieId, from: this);

  @override
  String toString() => r'movieDetailsProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
