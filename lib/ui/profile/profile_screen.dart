import 'package:cinebox/ui/core/themes/colors.dart';

import 'package:cinebox/ui/core/themes/text_styles.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    _buildProfileInfo(),
                    _buildMenuOptions(),
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
          const Spacer(),
          Text(
            '9:41',
            style: AppTextStyles.regularSmall.copyWith(
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
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
            'usuario@cinebox.com',
            style: AppTextStyles.subtitleSmall,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProfileStat('Filmes', '24'),
              _buildProfileStat('Favoritos', '12'),
              _buildProfileStat('Avaliações', '8'),
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

  Widget _buildMenuOptions() {
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
                  color: item['title'] == 'Sair'
                      ? AppColors.redColor
                      : AppColors.darkGrey,
                  size: 24,
                ),
              ),
              title: Text(
                item['title'] as String,
                style: AppTextStyles.boldSmall.copyWith(
                  color: item['title'] == 'Sair'
                      ? AppColors.redColor
                      : Colors.black,
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
              onTap: () {
                // Implementar ações dos itens do menu
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
