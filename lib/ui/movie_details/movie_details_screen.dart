import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/movie_service.dart';
import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:cinebox/ui/core/themes/text_styles.dart';
import 'package:cinebox/ui/core/widgets/optimized_loading.dart';
import 'package:cinebox/data/services/favorites/favorites_provider.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  late Future<Map<String, dynamic>> _movieDetailsFuture;

  @override
  void initState() {
    super.initState();
    _movieDetailsFuture = _loadMovieDetails();
  }

  Future<Map<String, dynamic>> _loadMovieDetails() async {
    final movieService = ref.read(movieServiceProvider);
    return await movieService.getMovieDetails(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('MovieDetailsScreen: ${widget.movie.toJson()}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Imagem de fundo do filme
            Image.network(
              widget.movie.fullPosterPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.lightGrey,
                  child: const Icon(
                    Icons.movie,
                    size: 80,
                    color: AppColors.darkGrey,
                  ),
                );
              },
            ),
            // Gradiente escuro para melhorar legibilidade
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(70),
                  ],
                ),
              ),
            ),
            // Botão de voltar
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(50),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Botão de favorito
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: Consumer(
                builder: (context, ref, child) {
                  final favoritesAsync = ref.watch(favoritesNotifierProvider);

                  return favoritesAsync.when(
                    data: (favorites) {
                      final isFavorite = favorites.any(
                        (favorite) => favorite.id == widget.movie.id,
                      );

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(50),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () => _toggleFavorite(isFavorite),
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? AppColors.redColor
                                : Colors.white,
                          ),
                        ),
                      );
                    },
                    loading: () => Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(50),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const IconButton(
                        onPressed: null,
                        icon: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    error: (error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(50),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () => _toggleFavorite(false),
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Informações básicas do filme
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.redColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.movie.year,
                          style: AppTextStyles.regularSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (widget.movie.voteAverage > 0) ...[
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.movie.voteAverage.toStringAsFixed(1),
                          style: AppTextStyles.regularSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sinopse
            _buildSection(
              title: 'Sinopse',
              child: Text(
                widget.movie.overview.isNotEmpty
                    ? widget.movie.overview
                    : 'Sinopse não disponível.',
                style: AppTextStyles.regularSmall.copyWith(
                  color: AppColors.darkGrey,
                  height: 1.5,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Detalhes do filme
            FutureBuilder<Map<String, dynamic>>(
              future: _movieDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildSection(
                    title: 'Detalhes',
                    child: const OptimizedLoading(),
                  );
                }

                if (snapshot.hasError) {
                  return _buildSection(
                    title: 'Detalhes',
                    child: Text(
                      'Erro ao carregar detalhes: ${snapshot.error}',
                      style: AppTextStyles.regularSmall.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  );
                }

                final movieDetails = snapshot.data!;
                return Column(
                  children: [
                    // Gêneros
                    if (movieDetails['genres'] != null) ...[
                      _buildSection(
                        title: 'Gêneros',
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (movieDetails['genres'] as List)
                              .map(
                                (genre) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGrey,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    genre['name'] ?? '',
                                    style: AppTextStyles.regularSmall.copyWith(
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Informações técnicas
                    _buildSection(
                      title: 'Informações Técnicas',
                      child: Column(
                        children: [
                          _buildInfoRow(
                            'Duração',
                            movieDetails['runtime'] != null
                                ? '${movieDetails['runtime']} min'
                                : 'Não informado',
                          ),
                          _buildInfoRow(
                            'Status',
                            movieDetails['status'] ?? 'Não informado',
                          ),
                          _buildInfoRow(
                            'Data de Lançamento',
                            movieDetails['release_date'] ?? 'Não informada',
                          ),
                          _buildInfoRow(
                            'Orçamento',
                            movieDetails['budget'] != null &&
                                    movieDetails['budget'] > 0
                                ? '\$${(movieDetails['budget'] / 1000000).toStringAsFixed(1)}M'
                                : 'Não informado',
                          ),
                          _buildInfoRow(
                            'Receita',
                            movieDetails['revenue'] != null &&
                                    movieDetails['revenue'] > 0
                                ? '\$${(movieDetails['revenue'] / 1000000).toStringAsFixed(1)}M'
                                : 'Não informado',
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.boldMedium.copyWith(
            color: AppColors.darkGrey,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: AppTextStyles.boldSmall.copyWith(
                color: AppColors.lightGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.regularSmall.copyWith(
                color: AppColors.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(bool isFavorite) async {
    try {
      if (isFavorite) {
        await ref
            .read(favoritesNotifierProvider.notifier)
            .removeFromFavorites(widget.movie.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.movie.title} removido dos favoritos'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        await ref
            .read(favoritesNotifierProvider.notifier)
            .addToFavorites(widget.movie);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.movie.title} adicionado aos favoritos!'),
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
}
