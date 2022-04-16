import 'package:uuid/uuid.dart';
import 'package:music_api/model/activity.dart';

import '../repositories/activity_repository.dart';

import '../utils/http.dart';

class ActivityController {
  final _activiryRepository = ActivityRepository();
  Future<HttpResponse> getAll(HttpRequest req) async {
    var res = await _activiryRepository.getAll();
    res.sort((a, b) => a.schedule.length > 0 && b.schedule.length > 0
        ? a.schedule.first.date.compareTo(b.schedule.first.date)
        : 0);

    return HttpResponse(res.map((e) => e.toJson()).toList(), statusCode: 200);
  }

  Future<HttpResponse> create(HttpRequest req) async {
    if (req.body == null) {
      return HttpResponse('Body not content', statusCode: 400);
    }
    if (req.body!['id'] == null) {
      req.body!.addAll({'id': Uuid().v4()});
    }
    var activity = ActivityModel.fromJson(req.body!);
    var res = await _activiryRepository.create(activity);
    if (res) {
      return HttpResponse(null, statusCode: 201);
    }
    return HttpResponse(null, statusCode: 400);
  }

  Future<HttpResponse> update(HttpRequest req) async {
    if (req.body == null) {
      return HttpResponse('Body not content', statusCode: 400);
    }
    if (req.queryStringParameters == null ||
        req.queryStringParameters?['id'] == null) {
      return HttpResponse('invalid or empty id', statusCode: 400);
    }
    req.body!.addAll(req.queryStringParameters!);
    var activity = ActivityModel.fromJson(req.body!);
    var res = await _activiryRepository.update(activity);
    if (res == null) {
      return HttpResponse(null, statusCode: 400);
    }
    return HttpResponse(res.toJson(), statusCode: 200);
  }
}
