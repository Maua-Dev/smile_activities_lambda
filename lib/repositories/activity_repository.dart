import 'dart:io' show Platform;
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:music_api/model/activity.dart';

class ActivityRepository {
  // final dynamoClient = DynamoDB(
  //     region: Platform.environment.containsKey('AWS_REGION')
  //         ? Platform.environment['AWS_REGION']!
  //         : 'sa-east-1',
  //     credentials: Platform.environment.containsKey('ENV')
  //         ? AwsClientCredentials(
  //             accessKey:
  //                 Platform.environment['accessKey'] ?? 'AKIA6OSE4M4SAWHPS5GV',
  //             secretKey: Platform.environment['secretKey'] ??
  //                 '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')
  //         : null);
  final dynamoClient = DynamoDB(
      region: 'sa-east-1',
      credentials: AwsClientCredentials(
          accessKey: 'AKIA6OSE4M4SAWHPS5GV',
          secretKey: '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'));
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
          expressionAttributeValues: value.expressionAttr(),
          expressionAttributeNames: value.expressionAttrNames(),
          returnValues: ReturnValue.allNew);
      if (output.attributes == null) {
        return null;
      }
      return ActivityModel.fromOutput(output.attributes!);
    } catch (e) {
      return null;
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
}
