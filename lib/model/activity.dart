import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import '../model/schedule.dart';
import '../model/speaker.dart';

class ActivityModel {
  final String id;
  final String activityCode;
  final String description;
  final String title;
  final String type;
  final List<Speaker> speakers;
  final List<Schedule> schedule;
  ActivityModel(
      {required this.id,
      required this.activityCode,
      required this.description,
      required this.title,
      required this.type,
      required this.speakers,
      required this.schedule});

  factory ActivityModel.fromOutput(Map<String, AttributeValue> json) {
    return ActivityModel(
        id: json['id']?.s ?? '',
        activityCode: json['activityCode']?.s ?? '',
        description: json['description']?.s ?? '',
        title: json['title']?.s ?? '',
        type: json['type']?.s ?? '',
        speakers: Speaker.fromListOutput(json['speakers']?.l),
        schedule: Schedule.fromListOutput(json['schedule']?.l));
  }
  Map<String, AttributeValue> toAttr() {
    return {
      'id': AttributeValue(s: id),
      'activityCode': AttributeValue(s: activityCode),
      'description': AttributeValue(s: description),
      'title': AttributeValue(s: title),
      'type': AttributeValue(s: type),
      'speakers': AttributeValue(
          l: speakers.map((e) => AttributeValue(m: e.toAttr())).toList()),
      'schedule': AttributeValue(
          l: schedule.map((e) => AttributeValue(m: e.toAttr())).toList()),
    };
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
        id: json['id'] as String,
        activityCode: json['activityCode'] as String,
        description: json['description'] as String,
        title: json['title'] as String,
        type: json['type'] as String,
        speakers:
            (json['speakers'] as List).map((e) => Speaker.fromJson(e)).toList(),
        schedule: (json['schedule'] as List)
            .map((e) => Schedule.fromJson(e))
            .toList());
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityCode': activityCode,
      'description': description,
      'title': title,
      'type': type,
      'speakers': speakers.map((e) => e.toJson()).toList(),
      'schedule': schedule.map((e) => e.toJson()).toList(),
    };
  }

  String updateExpression() {
    return '''SET         
 #field1 = :val1,
 #field2 = :val2,
 #field3 = :val3,
 #field4 = :val4,
 #field5 = :val5
    ''';
  }

  Map<String, AttributeValue> expressionAttr() {
    return {
      ':val1': AttributeValue(s: activityCode),
      ':val2': AttributeValue(s: description),
      ':val3': AttributeValue(s: title),
      ':val4': AttributeValue(s: type),
      ':val5': AttributeValue(
          l: speakers.map((e) => AttributeValue(m: e.toAttr())).toList()),
    };
  }

  Map<String, String> expressionAttrNames() {
    return {
      '#field1': 'activityCode',
      '#field2': 'description',
      '#field3': 'title',
      '#field4': 'type',
      '#field5': 'speakers'
    };
  }
}
