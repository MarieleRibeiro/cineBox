import 'package:cinebox/ui/core/themes/resource.dart';
import 'package:cinebox/ui/core/widgets/loader_message.dart';
import 'package:cinebox/ui/splash/commands/check_user_logged_command.dart';
import 'package:cinebox/ui/splash/splash_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with LoaderAndMessage {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashViewModelProvider).checkLoginAndRedirect();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(checkUserLoggedCommandProvider, (_, next) {
      next.whenOrNull(
        data: (data) {
          final path = switch (data) {
            true => '/home',
            false => '/login',
            _ => '',
          };
          if (path.isNotEmpty && context.mounted) {
            Navigator.pushNamedAndRemoveUntil(context, path, (route) => false);
          }
        },
        error: (error, _) {
          showErrorMessage(
            'Error ao verificar login: $error',
          );
          Navigator.pushNamedAndRemoveUntil(
            // tira toda a pilha de rotas se ouver
            context,
            '/login',
            (route) => false,
          );
        },
      );
    });
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            R.ASSETS_IMAGES_BG_LOGIN_PNG,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            constraints: BoxConstraints.expand(),
            color: Colors.black.withAlpha(170),
          ),
          Center(
            child: Image.asset(
              R.ASSETS_IMAGES_LOGO_PNG,
            ),
          ),
        ],
      ),
    );
  }
}
