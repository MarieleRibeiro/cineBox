import 'dart:developer';
import 'dart:async';

import 'package:cinebox/core/result/result.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './google_signin_service.dart';

class GoogleSigninServiceImpl implements GoogleSigninService {
  // Cache para evitar verificações desnecessárias
  bool? _isSignedInCache;
  String? _cachedIdToken;
  DateTime? _cacheTimestamp;
  static const Duration _cacheValidity = Duration(minutes: 5);
  static const Duration _timeout = Duration(seconds: 10);

  @override
  Future<Result<String>> isSignedIn() async {
    // Verificar se o cache ainda é válido
    if (_isSignedInCache == true &&
        _cachedIdToken != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < _cacheValidity) {
      return Success(_cachedIdToken!);
    }

    try {
      // Adicionar timeout para evitar travamentos
      final logged = await GoogleSignIn.instance
          .attemptLightweightAuthentication()
          ?.timeout(_timeout);

      if (logged case GoogleSignInAccount(
        authentication: GoogleSignInAuthentication(
          :final idToken?,
        ),
      )) {
        // Atualizar cache com timestamp
        _isSignedInCache = true;
        _cachedIdToken = idToken;
        _cacheTimestamp = DateTime.now();
        return Success(idToken);
      }
      _isSignedInCache = false;
      _cacheTimestamp = DateTime.now();
      return Failure(Exception('User is not signed in Google'), null);
    } on TimeoutException {
      log('Timeout ao verificar login do Google', name: 'GoogleSigninService');
      return Failure(Exception('Timeout ao verificar login'), null);
    } catch (e, s) {
      _isSignedInCache = false;
      _cacheTimestamp = DateTime.now();
      log(
        'User is not signed in Google',
        name: 'GoogleSigninService',
        error: e,
        stackTrace: s,
      );
      return Failure(Exception('User is not signed in Google'), null);
    }
  }

  @override
  Future<Result<String>> signIn() async {
    try {
      // Adicionar timeout para evitar travamentos
      final auth = await GoogleSignIn.instance
          .authenticate(
            scopeHint: [
              'email',
              'profile',
              'openid',
            ],
          )
          .timeout(_timeout);

      if (auth.authentication case GoogleSignInAuthentication(
        idToken: final idToken?,
      )) {
        // Atualizar cache após login bem-sucedido
        _isSignedInCache = true;
        _cachedIdToken = idToken;
        _cacheTimestamp = DateTime.now();
        return Success(idToken);
      }
      return Failure(Exception('Failed to sign in with Google'), null);
    } on TimeoutException {
      log('Timeout ao fazer login com Google', name: 'GoogleSigninService');
      return Failure(Exception('Timeout ao fazer login com Google'), null);
    } catch (e, s) {
      log(
        'Failed to retrive Id token from google sign-in',
        name: 'GoogleSigninService',
        error: e,
        stackTrace: s,
      );
      return Failure(Exception('Failed to sign in with Google'), null);
    }
  }

  @override
  Future<Result<Unit>> signOut() async {
    try {
      await GoogleSignIn.instance.signOut().timeout(_timeout);
      // Limpar cache após logout
      _isSignedInCache = false;
      _cachedIdToken = null;
      _cacheTimestamp = null;
      return successOfUnit();
    } on TimeoutException {
      log('Timeout ao fazer logout do Google', name: 'GoogleSigninService');
      return Failure(Exception('Timeout ao fazer logout'), null);
    } catch (e, s) {
      log(
        'Failed to sign out from google',
        name: 'GoogleSigninService',
        error: e,
        stackTrace: s,
      );
      return Failure(Exception('Failed to sign in with Google'), null);
    }
  }

  // Método para limpar cache manualmente
  void clearCache() {
    _isSignedInCache = null;
    _cachedIdToken = null;
    _cacheTimestamp = null;
  }
}
