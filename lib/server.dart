import 'package:aws_lambda_dart_runtime/aws_lambda_dart_runtime.dart';
import 'package:music_api/controllers/activity_controller.dart';
import 'utils/http.dart';

void main() async {
  final _controller = ActivityController();
  Future<Map<String, dynamic>> handlerRouter(HttpRequest req) async {
    const defaultPath = '/activity';
    switch (req.rawPath.toLowerCase()) {
      case ('$defaultPath/getall'):
        var res = await _controller.getAll(req);
        return res.toJson();
      case ('$defaultPath'):
        if (req.httpMethod == 'PUT') {
          var res = await _controller.update(req);
          return res.toJson();
        }
        var res = await _controller.create(req);
        return res.toJson();
      default:
        return Future.value(HttpResponse(null, statusCode: 404).toJson());
    }
  }

  final Handler<HttpRequest> activityHandler =
      (context, HttpRequest event) async {
    return await handlerRouter(event);
  };
  Runtime()
    ..registerEvent<HttpRequest>(
        (Map<String, dynamic> json) => HttpRequest.fromJson(json))
    ..registerHandler<HttpRequest>("activity.handler", activityHandler)
    ..invoke();
}
