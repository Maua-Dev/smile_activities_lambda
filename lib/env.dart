import 'dart:io' show Platform;

import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

class Env {
  static String get region => Platform.environment.containsKey('AWS_REGION')
      ? Platform.environment['AWS_REGION']!
      : 'sa-east-1';
  static AwsClientCredentials? get credential =>
      Platform.environment.containsKey('ENV')
          ? AwsClientCredentials(
              accessKey: Platform.environment['accessKey'] ?? '',
              secretKey: Platform.environment['secretKey'] ?? '')
          : null;
  static String get tableName =>
      Platform.environment['TABLE_NAME'] ?? 'Activity_Teste';
  static String get cognitoUrl => Platform.environment['COGNITO_AWS'] ?? '';
  static String get bucketName => Platform.environment['BUCKET_NAME'] ?? '';
}
