import 'package:aws_lambda_dart_runtime/aws_lambda_dart_runtime.dart';
import 'controllers/activity_controller.dart';
import 'repositories/auth_repository.dart';
import 'utils/errors.dart';
import 'model/user.dart';
import 'utils/http.dart';

void main() async {
  final _controller = ActivityController();
  final _authRepository = AuthRepository();
  Future<User> jwtCheck(HttpRequest req) async {
    if (!req.headers!.containsKey('authorization')) {
      throw AuthenticationError();
    }
    var user = await _authRepository.checkToken(req.headers!['authorization']);
    if (user == null) {
      throw AuthenticationError();
    }
    return user;
  }

  Future<Map<String, dynamic>> handlerRouter(HttpRequest req) async {
    const defaultPath = '/activity';
    switch (req.rawPath.toLowerCase()) {
      case ('$defaultPath/getall'):
        try {
          var res = await _controller.getAll(req);
          return res.toJson();
        } catch (e) {
          throw InternalServerError(e);
        }
      case ('$defaultPath'):
        try {
          if (req.httpMethod == 'PUT') {
            var res = await _controller.update(req);
            return res.toJson();
          } else if (req.httpMethod == 'DELETE') {
            var res = await _controller.delete(req);
            return res.toJson();
          }
          var res = await _controller.create(req);
          return res.toJson();
        } catch (e) {
          throw InternalServerError(e);
        }
        
      case ('$defaultPath/enroll'):
        var user = await jwtCheck(req);
        try {
          var res = await _controller.enrollUser(req, user);
          return res.toJson();
        } catch (e) {
          throw InternalServerError(e);
        }
      case ('$defaultPath/unenroll'):
        var user = await jwtCheck(req);
        try {
          var res = await _controller.unEnrollUser(req, user);
          return res.toJson();
        } catch (e) {
          throw InternalServerError(e.message);
        }
      case ('$defaultPath/userisenrolled'):
        var user = await jwtCheck(req);
        try {
          var res = await _controller.userEnrolledActivities(req, user);
          return res.toJson();
        } catch (e) {
          throw InternalServerError(e);
        }
      default:
        return HttpResponse(null, statusCode: 404).toJson();
    }
  }

  final Handler<HttpRequest> activityHandler =
      (context, HttpRequest event) async {
    try {
      return await handlerRouter(event);
    } on AuthenticationError catch (e) {
      return HttpResponse(e.message, statusCode: 401).toJson();
    } on InternalServerError catch (e) {
      return HttpResponse(e.message, statusCode: 500).toJson();
    } catch (e) {
      return HttpResponse(e, statusCode: 500).toJson();
    }
  };
  Runtime()
    ..registerEvent<HttpRequest>(
        (Map<String, dynamic> json) => HttpRequest.fromJson(json))
    ..registerHandler<HttpRequest>("activity.handler", activityHandler)
    ..invoke();
}
