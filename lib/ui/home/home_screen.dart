import 'package:cinebox/data/models/genre.dart';
import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/favorites/favorites_provider.dart';
import 'package:cinebox/data/services/movie_service.dart';
import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:cinebox/ui/core/themes/resource.dart';
import 'package:cinebox/ui/core/themes/text_styles.dart';
import 'package:cinebox/ui/home/home_view_model.dart';
import 'package:cinebox/ui/movie_details/movie_details_screen.dart';
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

  // Controle de busca
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Movie> _searchResults = [];
  bool _isSearching = false;

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

  void _toggleFavorite(Movie movie, bool isFavorite) async {
    try {
      if (isFavorite) {
        // Remover dos favoritos
        await ref
            .read(favoritesNotifierProvider.notifier)
            .removeFromFavorites(movie.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${movie.title} removido dos favoritos'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Adicionar aos favoritos
        await ref
            .read(favoritesNotifierProvider.notifier)
            .addToFavorites(movie);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${movie.title} adicionado aos favoritos!'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao ${isFavorite ? 'remover' : 'adicionar'} favorito: $e',
          ),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _navigateToMovieDetails(Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }

  // Métodos de busca
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
      if (_searchQuery.isEmpty) {
        _clearSearch();
      }
    });
  }

  void _onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final movieService = ref.read(movieServiceProvider);
      final searchResponse = await movieService.searchMovies(query.trim());
      setState(() {
        _searchResults = searchResponse.results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro na busca: $e'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchResults.clear();
      _isSearching = false;
    });
    _searchController.clear();
  }

  Widget _buildContent(Map<String, List<Movie>> movies) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilters(),

          if (_searchQuery.isNotEmpty) ...[
            _buildSearchResults(),
          ] else ...[
            _buildPopularMovies(_filteredPopularMovies),
            _buildTopMovies(_filteredTopMovies),
          ],

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
                _buildSearchBar(),
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
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Procurar filme...',
                hintStyle: AppTextStyles.subtitleSmall,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTextStyles.regularSmall.copyWith(
                color: AppColors.darkGrey,
              ),
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              onPressed: _clearSearch,
              icon: Icon(
                Icons.clear,
                color: AppColors.lightGrey,
                size: 20,
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

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Resultados para: ',
                style: AppTextStyles.boldMedium.copyWith(
                  color: Colors.black,
                ),
              ),
              Text(
                '"$_searchQuery"',
                style: AppTextStyles.boldMedium.copyWith(
                  color: AppColors.redColor,
                ),
              ),
              const Spacer(),
              Text(
                '${_searchResults.length} ${_searchResults.length == 1 ? 'filme' : 'filmes'}',
                style: AppTextStyles.regularSmall.copyWith(
                  color: AppColors.lightGrey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (_isSearching) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ] else if (_searchResults.isEmpty && _searchQuery.isNotEmpty) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: AppColors.lightGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum filme encontrado',
                    style: AppTextStyles.boldMedium.copyWith(
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tente uma busca diferente',
                    style: AppTextStyles.regularSmall.copyWith(
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults[index];
                return _buildMovieCard(movie);
              },
            ),
          ),
        ],
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
              GestureDetector(
                onTap: () => _navigateToMovieDetails(movie),
                child: Container(
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
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Consumer(
                  builder: (context, ref, child) {
                    final favoritesAsync = ref.watch(favoritesNotifierProvider);

                    return favoritesAsync.when(
                      data: (favorites) {
                        final isFavorite = favorites.any(
                          (favorite) => favorite.id == movie.id,
                        );

                        return GestureDetector(
                          onTap: () => _toggleFavorite(movie, isFavorite),
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
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: isFavorite
                                  ? AppColors.redColor
                                  : AppColors.lightGrey,
                            ),
                          ),
                        );
                      },
                      loading: () => Container(
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
                        child: const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (error, stackTrace) => Container(
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
                          color: AppColors.lightGrey,
                        ),
                      ),
                    );
                  },
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
