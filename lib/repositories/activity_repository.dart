import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import '../env.dart';
import '../model/activity.dart';
import '../model/user.dart';

class ActivityRepository {
  final dynamoClient =
      DynamoDB(region: Env.region, credentials: Env.credential);
  Future<List<ActivityModel>> getAll() async {
    var output = await dynamoClient.scan(tableName: Env.tableName);
    var activityList =
        output.items?.map((e) => ActivityModel.fromOutput(e)).toList() ?? [];
    return activityList;
  }

  Future<bool> create(ActivityModel value) async {
    try {
      await dynamoClient.putItem(
          item: value.toAttr(), tableName: Env.tableName);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ActivityModel?> update(ActivityModel value) async {
    try {
      var output = await dynamoClient.updateItem(
          tableName: Env.tableName,
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

  Future<bool> delete(String id) async {
    try {
      await dynamoClient.deleteItem(
          tableName: Env.tableName,
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
          tableName: Env.tableName, key: {'id': AttributeValue(s: id)});
      if (output.item == null) {
        return null;
      }
      return ActivityModel.fromOutput(output.item!);
    } catch (e) {
      return null;
    }
  }

  Future<ActivityModel?> saveEnrollUser(User user, ActivityModel value) async {
    try {
      var output = await dynamoClient.updateItem(
          tableName: Env.tableName,
          key: {'id': AttributeValue(s: value.id)},
          updateExpression: 'SET #schedule = :val',
          expressionAttributeNames: {"#schedule": "schedule"},
          expressionAttributeValues: {
            ":val": AttributeValue(
                l: value.schedule
                    .map((e) => AttributeValue(m: e.toAttrEnroll()))
                    .toList())
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
