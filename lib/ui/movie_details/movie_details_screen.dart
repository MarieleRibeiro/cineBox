import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/models/movie_details.dart';
import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:cinebox/ui/core/themes/text_styles.dart';
import 'package:cinebox/ui/core/widgets/optimized_loading.dart';
import 'package:cinebox/ui/core/mixins/favorite_actions.dart';
import 'package:cinebox/data/services/favorites/favorites_provider.dart';
import 'package:cinebox/ui/movie_details/movie_details_view_model.dart';

class MovieDetailsScreen extends ConsumerWidget with FavoriteActions {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, ref),
          _buildContent(context, ref),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, WidgetRef ref) {
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
              movie.fullPosterPath,
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
              child: _buildFavoriteButton(context, ref),
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
                    movie.title,
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
                          movie.year,
                          style: AppTextStyles.regularSmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (movie.voteAverage > 0) ...[
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
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

  Widget _buildFavoriteButton(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesNotifierProvider);

    return favoritesAsync.when(
      data: (favorites) {
        final isFavorite = favorites.any(
          (favorite) => favorite.id == movie.id,
        );

        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(50),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            onPressed: () => toggleFavorite(context, ref, movie, isFavorite),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.redColor : Colors.white,
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ),
      error: (_, __) => Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(50),
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          onPressed: () => toggleFavorite(context, ref, movie, false),
          icon: const Icon(
            Icons.favorite_border,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final movieDetailsAsync = ref.watch(movieDetailsProvider(movie.id));

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
                movie.overview.isNotEmpty
                    ? movie.overview
                    : 'Sinopse não disponível.',
                style: AppTextStyles.regularSmall.copyWith(
                  color: AppColors.darkGrey,
                  height: 1.5,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Detalhes do filme via Riverpod
            movieDetailsAsync.when(
              data: (details) => _buildDetailsSection(details),
              loading: () => _buildSection(
                title: 'Detalhes',
                child: const OptimizedLoading(),
              ),
              error: (error, _) => _buildSection(
                title: 'Detalhes',
                child: Text(
                  'Erro ao carregar detalhes: $error',
                  style: AppTextStyles.regularSmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(MovieDetails details) {
    return Column(
      children: [
        // Gêneros
        if (details.genres.isNotEmpty) ...[
          _buildSection(
            title: 'Gêneros',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: details.genres
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
                        genre.name,
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
              _buildInfoRow('Duração', details.formattedRuntime),
              _buildInfoRow('Status', details.status ?? 'Não informado'),
              _buildInfoRow(
                'Data de Lançamento',
                details.releaseDate.isNotEmpty
                    ? details.releaseDate
                    : 'Não informada',
              ),
              _buildInfoRow('Orçamento', details.formattedBudget),
              _buildInfoRow('Receita', details.formattedRevenue),
            ],
          ),
        ),
      ],
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
}
