import 'package:cinebox/data/models/movie.dart';
import 'package:cinebox/data/services/favorites/favorites_provider.dart';
import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mixin para ações de favoritos compartilhadas entre telas.
/// Evita duplicação de lógica de toggle + SnackBar.
mixin FavoriteActions {
  void toggleFavorite(
    BuildContext context,
    WidgetRef ref,
    Movie movie,
    bool isFavorite,
  ) async {
    try {
      if (isFavorite) {
        await ref
            .read(favoritesNotifierProvider.notifier)
            .removeFromFavorites(movie.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${movie.title} removido dos favoritos'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        await ref
            .read(favoritesNotifierProvider.notifier)
            .addToFavorites(movie);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${movie.title} adicionado aos favoritos!'),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
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
}
