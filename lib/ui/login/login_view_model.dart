import 'package:cinebox/ui/login/commands/login_with_google_command.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_view_model.g.dart';

class LoginViewModel {
  final LoginWithGoogleCommand _loginWithGoogleCommand;
  final Ref _ref;

  LoginViewModel({
    required LoginWithGoogleCommand loginWithGoogleCommand,
    required Ref ref,
  }) : _loginWithGoogleCommand = loginWithGoogleCommand,
       _ref = ref;

  void googleLogin() => _loginWithGoogleCommand.execute();

  // Usar watch para reatividade automática
  bool get isLoading => _ref.watch(loginWithGoogleCommandProvider).isLoading;

  bool get isSuccess => _ref.watch(loginWithGoogleCommandProvider).hasValue;

  bool get hasError => _ref.watch(loginWithGoogleCommandProvider).hasError;

  String? get errorMessage {
    final state = _ref.watch(loginWithGoogleCommandProvider);
    if (state.hasError) {
      return state.error.toString();
    }
    return null;
  }

  // Método para verificar se pode tentar login novamente
  bool get canRetry => !isLoading && hasError;

  // Método para tentar login novamente
  void retryLogin() {
    if (canRetry) {
      googleLogin();
    }
  }
}

@riverpod
LoginViewModel loginViewModel(Ref ref) {
  return LoginViewModel(
    loginWithGoogleCommand: ref.watch(loginWithGoogleCommandProvider.notifier),
    ref: ref,
  );
}
