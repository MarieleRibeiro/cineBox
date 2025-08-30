import 'package:cinebox/data/models/genre.dart';
import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/favorites/favorites_provider.dart';
import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:cinebox/ui/core/themes/resource.dart';
import 'package:cinebox/ui/core/themes/text_styles.dart';
import 'package:cinebox/ui/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedGenre;
  List<Movie> _filteredPopularMovies = [];
  List<Movie> _filteredTopMovies = [];

  @override
  Widget build(BuildContext context) {
    final moviesState = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: moviesState.when(
                data: (movies) {
                  _updateFilteredMovies(movies);
                  return _buildContent(movies);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.redColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Erro ao carregar filmes',
                        style: AppTextStyles.boldMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: AppTextStyles.subtitleSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => ref.refresh(homeViewModelProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.redColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateFilteredMovies(Map<String, List<Movie>> movies) {
    final popularMovies = movies['popular'] ?? [];
    final topMovies = movies['top'] ?? [];

    if (_selectedGenre != null) {
      final genreId = MovieGenres.getGenreId(_selectedGenre!);
      if (genreId != null) {
        _filteredPopularMovies = popularMovies
            .where((movie) => movie.genreIds.contains(genreId))
            .toList();
        _filteredTopMovies = topMovies
            .where((movie) => movie.genreIds.contains(genreId))
            .toList();
      }
    } else {
      _filteredPopularMovies = popularMovies;
      _filteredTopMovies = topMovies;
    }
  }

  void _toggleFavorite(Movie movie) {
    // Usar o provider real de favoritos
    ref.read(favoritesNotifierProvider.notifier).addToFavorites(movie);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${movie.title} adicionado aos favoritos!'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.white,
          onPressed: () {
            ref
                .read(favoritesNotifierProvider.notifier)
                .removeFromFavorites(movie.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${movie.title} removido dos favoritos'),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, List<Movie>> movies) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilters(),
          _buildPopularMovies(_filteredPopularMovies),
          _buildTopMovies(_filteredTopMovies),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        children: [
          // Imagem de fundo (small_banner)
          Image.asset(
            R.ASSETS_IMAGES_SMALL_BANNER_PNG,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          // Overlay escuro para melhorar legibilidade
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.black.withAlpha(50),
          ),
          // Conteúdo do header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Spacer(),
                // Barra de pesquisa centralizada na parte inferior
                _buildSearchBar(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search,
            color: AppColors.lightGrey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Procurar filme',
              style: AppTextStyles.subtitleSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = [
      'Todos',
      'Ação',
      'Comédia',
      'Drama',
      'Romance',
      'Terror',
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 24, bottom: 24),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected =
              _selectedGenre == category ||
              (category == 'Todos' && _selectedGenre == null);

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (category == 'Todos') {
                    _selectedGenre = null;
                  } else {
                    _selectedGenre = category;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? AppColors.redColor : Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              child: Text(
                category,
                style: AppTextStyles.regularSmall.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularMovies(List<Movie> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Mais populares',
            style: AppTextStyles.boldMedium.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return _buildMovieCard(movie);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopMovies(List<Movie> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Top filmes',
            style: AppTextStyles.boldMedium.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return _buildMovieCard(movie);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: movie.posterPath.isNotEmpty
                        ? NetworkImage(movie.fullPosterPath)
                        : AssetImage(R.ASSETS_IMAGES_NO_IMAGE_PNG)
                              as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(movie),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      size: 16,
                      color: AppColors.redColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            style: AppTextStyles.boldSmall.copyWith(
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            movie.year,
            style: AppTextStyles.lightGreySmall,
          ),
        ],
      ),
    );
  }
}
