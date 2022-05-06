import 'package:intl/intl.dart';
import 'package:smile_activities_lambda/model/schedule.dart';
import 'package:smile_activities_lambda/repositories/users_repository.dart';
import 'package:smile_activities_lambda/services/csv_converter.dart';
import 'package:smile_activities_lambda/services/s3_upload.dart';
import 'package:uuid/uuid.dart';
import '../model/user.dart';
import '../model/activity.dart';
import '../repositories/activity_repository.dart';
import '../utils/errors.dart';
import '../utils/http.dart';

class ActivityController {
  final _activityRepository = ActivityRepository();
  final _usersRepository = UsersRepository();
  Future<HttpResponse> getAll(HttpRequest req) async {
    var res = await _activityRepository.getAll();
    res.sort((a, b) {
      if (a.schedule.first.date == b.schedule.first.date) {
        return a.activityCode.compareTo(b.activityCode);
      }
      return a.schedule.first.date.compareTo(b.schedule.first.date);
    });
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
    var data = await _activityRepository.get(activity.id);
    if (data == null) {
      return HttpResponse(null, statusCode: 400);
    }
    activity.schedule.forEach((element) {
      data.schedule.forEach((sch) {
        if (element.date == sch.date) {
          element.enrolledUsers.addAll(sch.enrolledUsers);
        }
      });
    });
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
    var sch = <Schedule>[];
    acts.forEach((element) {
      element.schedule.forEach((el) {
        if (el.enrolledUsers.contains(user.id)) {
          sch.add(el);
        }
      });
      if (sch.length > 0) {
        var act = element;
        act.schedule.clear();
        act.schedule.addAll(sch);
        list.add(act);
        sch.clear();
      }
    });
    list.sort((a, b) => a.schedule.length > 0 && b.schedule.length > 0
        ? a.schedule.first.date.compareTo(b.schedule.first.date)
        : 0);
    return HttpResponse(list.map((e) => e.toJson()).toList(), statusCode: 200);
  }

  Future<HttpResponse> getUsersActivities(HttpRequest req) async {
    if (!req.headers!.containsKey('authorization')) {
      throw AuthenticationError();
    }
    var acts = await _activityRepository.getAll();
    acts.sort((a, b) {
      if (a.schedule.first.date == b.schedule.first.date) {
        return a.activityCode.compareTo(b.activityCode);
      }
      return a.schedule.first.date.compareTo(b.schedule.first.date);
    });

    var actSubs = <Map<String, String>>[];
    acts.forEach((element) {
      element.schedule.forEach((e) {
        var subs = e.enrolledUsers.map((u) {
          return {
            'dia': DateFormat('dd/MM')
                .format(DateTime.fromMillisecondsSinceEpoch(e.date)),
            'codigoAtividade': element.activityCode,
            'userId': u
          };
        }).toList();
        actSubs.addAll(subs);
      });
    });
    var users = await _usersRepository.listUsers(
        actSubs.map((e) => e['userId']!).toSet().toList(),
        req.headers!['authorization']);
    if (users == null) {
      return HttpResponse('Users return null', statusCode: 500);
    }

    actSubs.forEach((element) {
      var u = users[element['userId']];
      if (u['error'] == null) {
        var ent = <String, String>{
          'cpf': u!['cpfRne'] as String,
          'nome': u['name'] as String,
          'email': u['email'] as String
        };
        element.addAll(ent);
        element.remove('userId');
      }
    });
    var csv = CsvConverter.listToCsv(actSubs);
    var res = await S3Upload.upload(csvRows: csv);
    if (res == null) {
      throw InternalServerError('Upload S3 error');
    }
    return HttpResponse(res, statusCode: 200);
  }
}
