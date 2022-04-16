import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

class Speaker {
  final String? name;
  final String? bio;
  final String? company;

  Speaker({required this.name, required this.bio, required this.company});

  factory Speaker.fromOutput(Map<String, AttributeValue> json) {
    return Speaker(
      name: json['name']?.s ?? '',
      bio: json['bio']?.s ?? '',
      company: json['company']?.s ?? '',
    );
  }

  static List<Speaker> fromListOutput(List<AttributeValue>? list) {
    if (list == null) {
      return [];
    }
    return list.map((e) => Speaker.fromOutput(e.m ?? Map())).toList();
  }

  Map<String, AttributeValue> toAttr() {
    return {
      'name': AttributeValue(s: name),
      'bio': AttributeValue(s: bio),
      'company': AttributeValue(s: company),
    };
  }

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      company: json['company'] as String?,
    );
  }

  Map toJson() {
    return {
      'name': name,
      'bio': bio,
      'company': company,
    };
  }
}
