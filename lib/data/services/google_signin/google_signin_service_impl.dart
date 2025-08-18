import 'dart:developer';

import 'package:cinebox/core/result/result.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './google_signin_service.dart';

class GoogleSigninServiceImpl implements GoogleSigninService {
  @override
  Future<Result<String>> isSignedIn() async {
    try {
      final logged = await GoogleSignIn.instance
          .attemptLightweightAuthentication();
      if (logged case GoogleSignInAccount(
        authentication: GoogleSignInAuthentication(
          :final idToken?,
        ),
      )) {
        return Success(idToken);
      }
      return Failure(Exception('User is not signed in Google'), null);
    } catch (e, s) {
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
      final auth = await GoogleSignIn.instance.authenticate(
        scopeHint: [
          'email',
          'profile',
          'openid',
        ],
      );
      if (auth.authentication case GoogleSignInAuthentication(
        idToken: final idToken?,
      )) {
        return Success(idToken);
      }
      return Failure(Exception('Failed to sign in with Google'), null);
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
      await GoogleSignIn.instance.signOut();
      return successOfUnit();
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
}
