import 'package:cinebox/data/repositories/repositories_providers.dart';
import 'package:cinebox/data/services/favorites/favorites_provider.dart';
import 'package:cinebox/ui/core/themes/colors.dart';
import 'package:cinebox/ui/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildProfileInfo(ref),
                    _buildMenuOptions(context, ref),
                  ],
                ),
              ),
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
            'Perfil',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesNotifierProvider);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.lightGrey.withAlpha(30),
            child: Icon(
              Icons.person,
              size: 50,
              color: AppColors.darkGrey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Usuário Cinebox',
            style: AppTextStyles.boldMedium.copyWith(
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Conectado via Google',
            style: AppTextStyles.subtitleSmall,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              favoritesAsync.when(
                data: (favorites) =>
                    _buildProfileStat('Favoritos', '${favorites.length}'),
                loading: () => _buildProfileStat('Favoritos', '...'),
                error: (_, __) => _buildProfileStat('Favoritos', '0'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.boldLarge.copyWith(
            color: AppColors.redColor,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.lightGreyRegular,
        ),
      ],
    );
  }

  Widget _buildMenuOptions(BuildContext context, WidgetRef ref) {
    final menuItems = [
      {
        'icon': Icons.settings,
        'title': 'Configurações',
        'subtitle': 'Preferências do app',
      },
      {
        'icon': Icons.notifications,
        'title': 'Notificações',
        'subtitle': 'Gerenciar alertas',
      },
      {'icon': Icons.language, 'title': 'Idioma', 'subtitle': 'Português'},
      {'icon': Icons.help, 'title': 'Ajuda', 'subtitle': 'Suporte e FAQ'},
      {'icon': Icons.info, 'title': 'Sobre', 'subtitle': 'Versão 1.0.0'},
      {
        'icon': Icons.logout,
        'title': 'Sair',
        'subtitle': 'Fazer logout da conta',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: menuItems.map((item) {
          final isLogout = item['title'] == 'Sair';
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: isLogout ? AppColors.redColor : AppColors.darkGrey,
                  size: 24,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: AppTextStyles.boldSmall.copyWith(
                  color: isLogout ? AppColors.redColor : Colors.black,
                ),
              ),
              subtitle: Text(
                item['subtitle'] as String,
                style: AppTextStyles.lightGreyRegular,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: AppColors.lightGrey,
                size: 16,
              ),
              onTap: isLogout
                  ? () => _handleLogout(context, ref)
                  : () {},
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.redColor,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final authRepository = ref.read(authRepositoryProvider);
        await authRepository.signOut();
        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao fazer logout: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
