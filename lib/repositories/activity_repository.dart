import 'dart:io' show Platform;
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:smile_activities_lambda/model/schedule.dart';
import '../model/activity.dart';
import '../model/user.dart';
import '../utils/errors.dart' as err;

class ActivityRepository {
  final dynamoClient = DynamoDB(
      region: Platform.environment.containsKey('AWS_REGION')
          ? Platform.environment['AWS_REGION']!
          : 'sa-east-1',
      credentials: Platform.environment.containsKey('ENV')
          ? AwsClientCredentials(
              accessKey: Platform.environment['accessKey'] ?? '',
              secretKey: Platform.environment['secretKey'] ?? '')
          : null);
  Future<List<ActivityModel>> getAll() async {
    var output = await dynamoClient.scan(
        tableName: Platform.environment['TABLE_NAME'] ?? 'Activity_Teste');
    var activityList =
        output.items?.map((e) => ActivityModel.fromOutput(e)).toList() ?? [];
    return activityList;
  }

  Future<bool> create(ActivityModel value) async {
    try {
      await dynamoClient.putItem(
          item: value.toAttr(),
          tableName: Platform.environment['TABLE_NAME'] ?? 'Activity_Teste');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ActivityModel?> update(ActivityModel value) async {
    try {
      var output = await dynamoClient.updateItem(
          tableName: Platform.environment['TABLE_NAME'] ?? 'Activity_Teste',
          key: {'id': AttributeValue(s: value.id)},
          updateExpression: value.updateExpression(),
          expressionAttributeNames: value.expressionAttrNames(),
          expressionAttributeValues: value.expressionAttr(),
          returnValues: ReturnValue.allNew);
      if (output.attributes == null) {
        return null;
      }
      return ActivityModel.fromOutput(output.attributes!);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateSchedules(
      Schedule value, int index, String activityId) async {
    try {
      await dynamoClient.updateItem(
          tableName: Platform.environment['TABLE_NAME'] ?? 'Activity_Teste',
          key: {'id': AttributeValue(s: activityId)},
          updateExpression: value.updateExpression(),
          expressionAttributeNames: value.expressionAttrNames(index),
          expressionAttributeValues: value.expressionAttr(),
          returnValues: ReturnValue.none);
    } catch (e) {
      throw err.InternalServerError(e.toString());
    }
  }

  Future<bool> delete(String id) async {
    try {
      await dynamoClient.deleteItem(
          tableName: Platform.environment['TABLE_NAME'] ?? 'Activity_Teste',
          key: {'id': AttributeValue(s: id)},
          returnValues: ReturnValue.none);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ActivityModel?> get(String id) async {
    try {
      var output = await dynamoClient.getItem(
          tableName: Platform.environment['TABLE_NAME'] ?? 'Activity_Teste',
          key: {'id': AttributeValue(s: id)});
      if (output.item == null) {
        return null;
      }
      return ActivityModel.fromOutput(output.item!);
    } catch (e) {
      return null;
    }
  }

  Future<ActivityModel?> saveEnrollUser(User user, String idActivity,
      int indexSchedule, List<String> enrolledUsers) async {
    try {
      var output = await dynamoClient.updateItem(
          tableName: Platform.environment['TABLE_NAME'] ?? 'Activity_Teste',
          key: {'id': AttributeValue(s: idActivity)},
          updateExpression: 'SET #enroll = :val',
          expressionAttributeNames: {
            "#enroll": "schedule[$indexSchedule].enrolledUsers"
          },
          expressionAttributeValues: {
            ":val": AttributeValue(
                l: enrolledUsers.map((e) => AttributeValue(s: e)).toList())
          },
          returnValues: ReturnValue.allNew);
      if (output.attributes == null) {
        return null;
      }
      return ActivityModel.fromOutput(output.attributes!);
    } catch (e) {
      return null;
    }
  }
}
