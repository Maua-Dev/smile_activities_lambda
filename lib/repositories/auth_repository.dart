import 'dart:io';

import 'package:dio/dio.dart';
import '../model/user.dart';

class AuthRepository {
  final _dio = Dio(BaseOptions(
      baseUrl: Platform.environment['COGNITO_AWS']!,
      connectTimeout: 5000,
      receiveTimeout: 3000));

  Future<User?> checkToken(String token) async {
    try {
      var res = await _dio.get('/checkToken',
          options: Options(headers: {'Authorization': token}));
      if (res.statusCode == 200) {
        return User.fromJson(res.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
