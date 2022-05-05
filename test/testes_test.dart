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
          "Bearer eyJraWQiOiJlSTljRU5ZM1JrOE5PMHFKWDRpZ1JOR0praWg1MXVQdXVlUFVHWEI0MUJBPSIsImFsZyI6IlJTMjU2In0.eyJvcmlnaW5fanRpIjoiZDdkNjdlNzMtNWRjYi00OTNhLTgxNmQtOWRmOTg2M2I3NjFkIiwic3ViIjoiNDE0ZjdlZjItMGE5My00NzE3LWFkYmMtOTJiNzZjNjFlZTBiIiwiZXZlbnRfaWQiOiI3ZGZjMDFhYS04NGI3LTRkYWUtYmU5My0wM2VkNWM5MTQwMDQiLCJ0b2tlbl91c2UiOiJhY2Nlc3MiLCJzY29wZSI6ImF3cy5jb2duaXRvLnNpZ25pbi51c2VyLmFkbWluIiwiYXV0aF90aW1lIjoxNjUxNjgyNTE3LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuc2EtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3NhLWVhc3QtMV85ZTNBRko3bEYiLCJleHAiOjE2NTE3Njg5MTcsImlhdCI6MTY1MTY4MjUxNywianRpIjoiN2U1YzkzZDEtYTAzMy00ZTEyLWJjMjYtYzUwOWJhNzYwOWJlIiwiY2xpZW50X2lkIjoiMW5zbHRmdXBwa2gyNWtkdHNrMjR1czBlZjciLCJ1c2VybmFtZSI6IjkzNzkyNjgwMDkyIn0.LRKahh2GlaVQ2DNn5oaqcbZMu2SNNffJ8IhoNUNWbSIboEdxMqvSf9TO6TdsI9NEe-psbzc8G-o-hEFAFTfBzwzxBO4tV2Ya5bazTprqA-8fuA7ALCiCOG29cbW7XYsG2LVhs5u5NHnGlRWddwOIafdwoe4XfkrugCpp43s4NgTIsrfIVMKO3ebkYDEG6HKwOfXX3p3UXZSs61xlv2uYtkSt20-uWEdtM_7ZjvPMgqcgmxI6BuQLT4KrZZ2vyiCTkGzNsRroOw-kKCAcJfk4qGmA18TTlvOCimpfwunVZc0gH4pXZ9hxsz3aRCvXL0iTxxYm0cIxgixX-zgazdtEgQ"
    }));

    print(res.body);
  });
}
