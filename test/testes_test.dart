import 'package:dotenv/dotenv.dart';
import 'package:smile_activities_lambda/controllers/activity_controller.dart';
import 'package:smile_activities_lambda/utils/http.dart';
import 'package:test/test.dart';

void main() {
  test('tesate', () async {
    DotEnv(includePlatformEnvironment: true).load();
    var controller = ActivityController();
    var res = await controller.getUsersActivities(
        HttpRequest('/activity/download', null, null, 'get', {
      "authorization":
          "Bearer eyJraWQiOiJTZnE4VFhxYWo4S3d2K1Z6b1wvcEN3NHQ4bEk0cDNERndLRnJMc1cyTVNnbz0iLCJhbGciOiJSUzI1NiJ9.eyJvcmlnaW5fanRpIjoiNzY2MWU0MTYtMDE1Mi00MWYyLWFlNzctYWI1ZWEzMTJhMzVkIiwic3ViIjoiZDY5ODZhZTgtMTRhNi00NzhkLWE4ZDQtYTMwZWM4ZjZlNDUyIiwiZXZlbnRfaWQiOiI5ZTBkNThjMC00OTI4LTQxMDMtYmNhMi1jNmY4MzdlMGNmZDIiLCJ0b2tlbl91c2UiOiJhY2Nlc3MiLCJzY29wZSI6ImF3cy5jb2duaXRvLnNpZ25pbi51c2VyLmFkbWluIiwiYXV0aF90aW1lIjoxNjUxNzYxOTYzLCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuc2EtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3NhLWVhc3QtMV82S1dTd2xLT0IiLCJleHAiOjE2NTE4NDgzNjMsImlhdCI6MTY1MTc2MTk2MywianRpIjoiMzZkMGYyNWItYThkZi00NDNmLTgyZDAtN2RiZjhlYzZkYTAyIiwiY2xpZW50X2lkIjoiN3BmNThpMGV1aTkzdWVzZmhrYWs1Y2cwdjUiLCJ1c2VybmFtZSI6IjQ3OTI2OTg5MDEwIn0.hiTmltKHlU1EBcAOBBk6YTlRncIctTLFyaua99FS4PGMhd8kdV2XaUEHNXxNmnjcCKGU-RPeoYpqFRJaXJ0_1U5t65Az2oN0dE60-YpcuW35mzSPtNssu6SKBs7gTBH4beB6J5rUdFn8W8ejaB9EivO8qVJKXH-kljMbmAn-m-6vXd_L37aIVPei4MV8wJtW9TQtxS4S7v0bKaZc5WPXyxEk-GS1aTG0kZzfgfIUHtooU_eAARV_OdQArRsTswng7xkPYzArZSpMytHmLWQGAkRytPPEmQ9DG8FvY03WY_sMS-TPmjbX17OMY4mMx-9WWsgKPu83X6gZk0iqR2eyeg"
    }));

    print(res.body);
  });
}
