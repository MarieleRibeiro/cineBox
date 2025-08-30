import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/favorites/favorites_provider.dart';
import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:cinebox/ui/core/themes/resource.dart';
import 'package:cinebox/ui/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildFavoritesList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            'Favoritos',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
          const Spacer(),
          // Por enquanto mostrar dados estáticos
          Text(
            '0 filmes',
            style: AppTextStyles.regularSmall.copyWith(
              color: AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Consumer(
      builder: (context, ref, child) {
        final favoritesAsync = ref.watch(favoritesNotifierProvider);

        return favoritesAsync.when(
          data: (favorites) {
            if (favorites.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favorite = favorites[index];
                return _buildFavoriteMovieCard(favorite);
              },
            );
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
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Erro ao carregar favoritos',
                  style: AppTextStyles.boldMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: AppTextStyles.regularSmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64,
            color: AppColors.lightGrey,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum filme favorito',
            style: AppTextStyles.boldMedium.copyWith(
              color: AppColors.lightGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione filmes aos seus favoritos\npara vê-los aqui',
            style: AppTextStyles.regularSmall.copyWith(
              color: AppColors.lightGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteMovieCard(Movie favorite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              image: DecorationImage(
                image: favorite.posterPath.isNotEmpty
                    ? NetworkImage(favorite.fullPosterPath)
                    : AssetImage(R.ASSETS_IMAGES_NO_IMAGE_PNG) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favorite.title,
                    style: AppTextStyles.boldMedium.copyWith(
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.yellow,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        favorite.formattedVoteAverage,
                        style: AppTextStyles.regularSmall.copyWith(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        favorite.year,
                        style: AppTextStyles.lightGreySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _removeFromFavorites(favorite.id),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.redColor.withAlpha(10),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.redColor.withAlpha(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: AppColors.redColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Remover',
                            style: AppTextStyles.regularSmall.copyWith(
                              color: AppColors.redColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeFromFavorites(int movieId) {
    // Usar o provider real de favoritos
    ref.read(favoritesNotifierProvider.notifier).removeFromFavorites(movieId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filme removido dos favoritos'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
