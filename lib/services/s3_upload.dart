import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:intl/intl.dart';
import 'dart:io' show File, Platform;

import 'package:smile_activities_lambda/env.dart';

class S3Upload {
  static final _service = S3(
    region: Env.region,
  );
  static Future<String?> upload({required String csvRows}) async {
    try {
      var csv = File('file.txt');
      await csv.writeAsString(csvRows);
      var fileName = DateFormat('ddMMyyyyhhmm').format(DateTime.now());
      await _service.putObject(
        bucket: Env.bucketName,
        key: '$fileName.csv',
        body: await csv.readAsBytes(),
      );
      return 'https://${Env.bucketName}.s3.${Env.region}.amazonaws.com/$fileName.csv';
    } catch (e) {
      return null;
    }
  }
}
