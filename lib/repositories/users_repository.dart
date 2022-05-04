import 'dart:io';

import 'package:dio/dio.dart';

class UsersRepository {
  final _dio = Dio(BaseOptions(
      baseUrl: Platform.environment['COGNITO_AWS']!,
      connectTimeout: 5000,
      receiveTimeout: 3000));
  Future<Map?> listUsers(List<String> users, String token) async {
    try {
      var res = await _dio.post('/listUsers',
          data: users, options: Options(headers: {'Authorization': token}));
      if (res.statusCode == 200) {
        return res.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
