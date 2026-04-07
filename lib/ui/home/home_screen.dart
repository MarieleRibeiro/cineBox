import 'dart:async';

import 'package:cinebox/data/models/genre.dart';
import 'package:cinebox/data/models/home_movies_state.dart';
import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/movie_service.dart';
import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:cinebox/ui/core/themes/resource.dart';
import 'package:cinebox/ui/core/themes/text_styles.dart';
import 'package:cinebox/ui/core/widgets/movie_card.dart';
import 'package:cinebox/ui/core/widgets/movie_list_section.dart';
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

  // Controle de busca
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
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
                data: (moviesData) {
                  return _buildContent(moviesData);
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

  /// Filtra filmes por gênero selecionado
  List<Movie> _filterByGenre(List<Movie> movies) {
    if (_selectedGenre == null) return movies;

    final genreId = MovieGenres.getGenreId(_selectedGenre!);
    if (genreId == null) return movies;

    return movies.where((movie) => movie.genreIds.contains(genreId)).toList();
  }

  // Métodos de busca com debounce
  void _onSearchChanged(String query) {
    final trimmed = query.trim();

    // Cancelar timer anterior
    _debounceTimer?.cancel();

    if (trimmed.isEmpty) {
      _clearSearch();
      return;
    }

    setState(() {
      _searchQuery = trimmed;
    });

    // Disparar busca após 500ms sem digitar
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(trimmed);
    });
  }

  void _onSearchSubmitted(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    _performSearch(trimmed);
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });

    try {
      final movieService = ref.read(movieServiceProvider);
      final searchResponse = await movieService.searchMovies(query);
      if (mounted && _searchQuery == query) {
        setState(() {
          _searchResults = searchResponse.results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
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
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchResults.clear();
      _isSearching = false;
    });
    _searchController.clear();
  }

  Widget _buildContent(HomeMoviesState moviesData) {
    final filteredPopular = _filterByGenre(moviesData.popular);
    final filteredTop = _filterByGenre(moviesData.top);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilters(),

          if (_searchQuery.isNotEmpty) ...[
            _buildSearchResults(),
          ] else ...[
            MovieListSection(
              title: 'Mais populares',
              movies: filteredPopular,
            ),
            MovieListSection(
              title: 'Top filmes',
              movies: filteredTop,
            ),
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
          Image.asset(
            R.ASSETS_IMAGES_SMALL_BANNER_PNG,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.black.withAlpha(50),
          ),
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
              Flexible(
                child: Text(
                  '"$_searchQuery"',
                  style: AppTextStyles.boldMedium.copyWith(
                    color: AppColors.redColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
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
                return MovieCard(movie: _searchResults[index]);
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
