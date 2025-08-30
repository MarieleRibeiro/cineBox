import 'package:cinebox/core/result/result.dart';
import 'package:cinebox/data/repositories/repositories_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_with_google_command.g.dart';

@riverpod
class LoginWithGoogleCommand extends _$LoginWithGoogleCommand {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  @override
  AsyncValue<void> build() => AsyncData(null);

  Future<void> execute() async {
    state = const AsyncLoading();

    int retryCount = 0;

    while (retryCount < _maxRetries) {
      try {
        final authRepository = ref.read(authRepositoryProvider);
        final result = await authRepository.signIn();

        switch (result) {
          case Success<Unit>():
            state = AsyncData(null);
            return; // Sucesso, sair do loop
          case Failure<Unit>():
            retryCount++;
            if (retryCount >= _maxRetries) {
              // Última tentativa falhou
              state = AsyncError(
                'Falha no login após $retryCount tentativas. Verifique sua conexão.',
                StackTrace.current,
              );
              return;
            }
            // Aguardar antes da próxima tentativa
            await Future.delayed(_retryDelay * retryCount);
            break;
        }
      } catch (e, stackTrace) {
        retryCount++;
        if (retryCount >= _maxRetries) {
          state = AsyncError(
            'Erro inesperado: ${e.toString()}',
            stackTrace,
          );
          return;
        }
        // Aguardar antes da próxima tentativa
        await Future.delayed(_retryDelay * retryCount);
      }
    }
  }
}
