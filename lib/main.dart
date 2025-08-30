import 'package:cinebox/cinebox_main_app.dart';
import 'package:cinebox/config/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Google Sign-In de forma assíncrona com timeout
  try {
    await GoogleSignIn.instance
        .initialize(
          serverClientId: Env.googleApiKey,
        )
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('Timeout na inicialização do Google Sign-In');
          },
        );
  } catch (e) {
    debugPrint('Erro na inicialização do Google Sign-In: $e');
  }

  runApp(ProviderScope(child: CineboxMainApp()));
}
