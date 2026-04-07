import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/favorites/favorites_provider.dart';
import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:cinebox/ui/core/themes/resource.dart';
import 'package:cinebox/ui/core/themes/text_styles.dart';
import 'package:cinebox/ui/core/mixins/favorite_actions.dart';
import 'package:cinebox/ui/movie_details/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieCard extends ConsumerWidget with FavoriteActions {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => _navigateToDetails(context),
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
                child: _buildFavoriteButton(context, ref),
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

  Widget _buildFavoriteButton(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesNotifierProvider);

    return favoritesAsync.when(
      data: (favorites) {
        final isFavorite = favorites.any(
          (favorite) => favorite.id == movie.id,
        );

        return GestureDetector(
          onTap: () => toggleFavorite(context, ref, movie, isFavorite),
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
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 16,
              color: isFavorite ? AppColors.redColor : AppColors.lightGrey,
            ),
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.favorite_border,
          size: 16,
          color: AppColors.lightGrey,
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(movie: movie),
      ),
    );
  }
}
