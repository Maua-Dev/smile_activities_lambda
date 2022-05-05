import 'dart:typed_data';

import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:intl/intl.dart';

import 'package:smile_activities_lambda/env.dart';
import 'package:smile_activities_lambda/utils/errors.dart';

class S3Upload {
  static final _service = S3(region: Env.region, credentials: Env.credential);
  static Future<String?> upload({required String csvRows}) async {
    try {
      ;
      var fileName = DateFormat('ddMMyyyyhhmm').format(DateTime.now());
      await _service.putObject(
        bucket: Env.bucketName,
        key: '$fileName.csv',
        body: Uint8List.fromList(csvRows.codeUnits),
      );
      return 'https://${Env.bucketName}.s3.${Env.region}.amazonaws.com/$fileName.csv';
    } catch (e) {
      throw InternalServerError(e.toString());
    }
  }
}
