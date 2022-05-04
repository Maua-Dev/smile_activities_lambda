import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:intl/intl.dart';
import 'dart:io' show File, Platform;

class S3Upload {
  static final _service = S3(
    region: Platform.environment.containsKey('AWS_REGION')
        ? Platform.environment['AWS_REGION']!
        : 'sa-east-1',
  );
  static Future<String?> upload({required String csvRows}) async {
    try {
      var csv = File('file.txt');
      await csv.writeAsString(csvRows);
      var fileName = DateFormat('ddMMyyyyhhmm').format(DateTime.now());
      await _service.putObject(
        bucket: Platform.environment.containsKey('BUCKET_NAME')
            ? Platform.environment['BUCKET_NAME']!
            : '',
        key: '$fileName.csv',
        body: await csv.readAsBytes(),
      );
      return 'https://${Platform.environment['BUCKET_NAME']!}.s3.${Platform.environment['AWS_REGION']!}.amazonaws.com/$fileName.csv';
    } catch (e) {
      return null;
    }
  }
}
