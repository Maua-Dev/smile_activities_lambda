import 'package:dio/dio.dart';
import 'package:smile_activities_lambda/env.dart';

class UsersRepository {
  final _dio = Dio(BaseOptions(
      baseUrl: Env.cognitoUrl, connectTimeout: 5000, receiveTimeout: 3000));
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
