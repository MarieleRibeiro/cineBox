import 'package:cinebox/core/result/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import './local_storage_service.dart';

class LocalStorageServiceImpl implements LocalStorageService {
  final FlutterSecureStorage _flutterSecureStorage;

  LocalStorageServiceImpl({required FlutterSecureStorage flutterSecureStorage})
    : _flutterSecureStorage = flutterSecureStorage;

  @override
  Future<Result<String?>> getIdToken() async {
    final token = await _flutterSecureStorage.read(key: 'id_Token');
    if (token != null) {
      return Success(token);
    }
    return Failure(Exception('No token found'), null);
  }

  @override
  Future<Result<Unit>> removeIdToken() async {
    await _flutterSecureStorage.delete(key: 'id_Token');
    return successOfUnit();
  }

  @override
  Future<Result<Unit>> saveIdToken(String token) async {
    await _flutterSecureStorage.write(key: 'id_Token', value: token);
    return successOfUnit();
  }
}
