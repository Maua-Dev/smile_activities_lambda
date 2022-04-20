import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

class Schedule {
  final int date;
  final int totalParticipants;
  final int duration;
  final List<String> enrolledUsers;
  final String location;
  final String link;
  final bool acceptSubscription;
  Schedule(
      {required this.date,
      required this.totalParticipants,
      required this.duration,
      required this.enrolledUsers,
      required this.location,
      required this.link,
      required this.acceptSubscription});

  factory Schedule.fromOutput(Map<String, AttributeValue> json) {
    return Schedule(
      date: int.tryParse(json['date']?.n ?? '') ?? 0,
      totalParticipants: int.tryParse(json['totalParticipants']?.n ?? '') ?? 0,
      duration: int.tryParse(json['duration']?.n ?? '') ?? 0,
      enrolledUsers:
          json['enrolledUsers']?.l?.map((e) => e.s ?? '').toList() ?? [],
      location: json['location']?.s ?? '',
      link: json['link']?.s ?? '',
      acceptSubscription: json['acceptSubscription']?.boolValue ?? false,
    );
  }

  static List<Schedule> fromListOutput(List<AttributeValue>? list) {
    if (list == null) {
      return [];
    }
    return list.map((e) => Schedule.fromOutput(e.m ?? Map())).toList();
  }

  Map<String, AttributeValue> toAttr() {
    return {
      'date': AttributeValue(n: '$date'),
      'totalParticipants': AttributeValue(n: '$totalParticipants'),
      'duration': AttributeValue(n: '$duration'),
      'location': AttributeValue(s: location),
      'link': AttributeValue(s: link),
      'acceptSubscription': AttributeValue(boolValue: acceptSubscription)
    };
  }

  Map<String, AttributeValue> toAttrEnroll() {
    return {
      'enrolledUsers': AttributeValue(
          l: enrolledUsers.map((e) => AttributeValue(s: e)).toList()),
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      date: json['date'] as int,
      totalParticipants: json['totalParticipants'] as int,
      duration: json['duration'] as int,
      enrolledUsers: [],
      location: json['location'] as String,
      link: json['link'] as String,
      acceptSubscription: json['acceptSubscription'] as bool,
    );
  }
  Map toJson() {
    return {
      'date': date,
      'totalParticipants': totalParticipants,
      'duration': duration,
      'enrolledUsers': enrolledUsers.length,
      'location': location,
      'link': link,
      'acceptSubscription': acceptSubscription
    };
  }

  String updateExpression() {
    return '''SET         
 #field1 = :val1,
 #field2 = :val2,
 #field3 = :val3,
 #field4 = :val4,
 #field5 = :val5,
 #field6 = :val6
    ''';
  }

  Map<String, AttributeValue> expressionAttr() {
    return {
      ':val1': AttributeValue(n: '$date'),
      ':val2': AttributeValue(n: '$totalParticipants'),
      ':val3': AttributeValue(s: '$duration'),
      ':val4': AttributeValue(s: location),
      ':val5': AttributeValue(s: link),
      ':val6': AttributeValue(boolValue: acceptSubscription),
    };
  }

  Map<String, String> expressionAttrNames(int index) {
    return {
      '#field1': 'schedule[$index].date',
      '#field2': 'schedule[$index].totalParticipants',
      '#field3': 'schedule[$index].duration',
      '#field4': 'schedule[$index].location',
      '#field5': 'schedule[$index].link',
      '#field6': 'schedule[$index].acceptSubscription'
    };
  }
}
