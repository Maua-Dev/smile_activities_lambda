import 'package:music_api/model/user.dart';
import 'package:uuid/uuid.dart';
import 'package:music_api/model/activity.dart';

import '../repositories/activity_repository.dart';

import '../utils/http.dart';

class ActivityController {
  final _activityRepository = ActivityRepository();
  Future<HttpResponse> getAll(HttpRequest req) async {
    var res = await _activityRepository.getAll();
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
    var res = await _activityRepository.create(activity);
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
    var res = await _activityRepository.update(activity);
    if (res == null) {
      return HttpResponse(null, statusCode: 400);
    }
    return HttpResponse(res.toJson(), statusCode: 200);
  }

  Future<HttpResponse> delete(HttpRequest req) async {
    if (req.queryStringParameters == null ||
        req.queryStringParameters?['id'] == null) {
      return HttpResponse('invalid or empty id', statusCode: 400);
    }
    var res =
        await _activityRepository.delete(req.queryStringParameters!['id']);
    if (!res) {
      return HttpResponse(null, statusCode: 400);
    }
    return HttpResponse(null, statusCode: 204);
  }

  Future<HttpResponse> enrollUser(HttpRequest req, User user) async {
    if (req.body == null) {
      return HttpResponse('Body not content', statusCode: 400);
    }
    var act = await _activityRepository.get(req.body!['activityId']);
    if (act == null) {
      return HttpResponse('Activity not found', statusCode: 400);
    }
    act.schedule.forEach((element) {
      if (element.date == req.body!['activityDate'] &&
          !element.enrolledUsers.contains(user.id)) {
        element.enrolledUsers.add(user.id);
      }
    });

    var res = await _activityRepository.saveEnrollUser(user, act);
    if (res == null) {
      return HttpResponse(null, statusCode: 400);
    }
    return HttpResponse(res.toJson(), statusCode: 200);
  }

  Future<HttpResponse> unEnrollUser(HttpRequest req, User user) async {
    if (req.body == null) {
      return HttpResponse('Body not content', statusCode: 400);
    }
    var act = await _activityRepository.get(req.body!['activityId']);
    if (act == null) {
      return HttpResponse('Activity not found', statusCode: 400);
    }
    act.schedule.forEach((element) {
      if (element.date == req.body!['activityDate'] &&
          element.enrolledUsers.contains(user.id)) {
        element.enrolledUsers.remove(user.id);
      }
    });

    var res = await _activityRepository.saveEnrollUser(user, act);
    if (res == null) {
      return HttpResponse(null, statusCode: 400);
    }
    return HttpResponse(res.toJson(), statusCode: 200);
  }

  Future<HttpResponse> userEnrolledActivities(
      HttpRequest req, User user) async {
    var acts = await _activityRepository.getAll();
    var list = [];
    print('acts: ${acts.length}');
    acts.forEach((element) {
      element.schedule.forEach((el) {
        if (el.enrolledUsers.contains(user.id)) {
          list.add(element);
        }
      });
    });
    return HttpResponse(list.map((e) => e.toJson()).toList(), statusCode: 200);
  }
}
