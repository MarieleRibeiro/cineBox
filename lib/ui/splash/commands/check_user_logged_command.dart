import 'package:cinebox/core/result/result.dart';
import 'package:cinebox/data/repositories/repositories_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_user_logged_command.g.dart';

@riverpod
class CheckUserLoggedCommand extends _$CheckUserLoggedCommand {
  @override
  Future<bool?> build() async => null;

  Future<bool?> execute() async {
    state = const AsyncLoading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final result = await authRepository.isLogged();
      final isLogged = switch (result) {
        Success<bool>(value: final v) => v,
        Failure<bool>() => false,
      };
      state = AsyncData(isLogged);
      return isLogged;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return false;
    }
  }
}
