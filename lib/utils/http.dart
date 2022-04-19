import 'dart:convert';

class HttpRequest {
  final String rawPath;
  final Map<String, dynamic>? queryStringParameters;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? body;
  final String httpMethod;

  HttpRequest(this.rawPath, this.queryStringParameters, this.body,
      this.httpMethod, this.headers);

  factory HttpRequest.fromJson(Map<String, dynamic> json) {
    return HttpRequest(
        json['rawPath'],
        json['queryStringParameters'],
        json['body'] != null ? jsonDecode(json['body']) : null,
        json['requestContext']['http']['method'],
        json['headers']);
  }
}

class HttpResponse {
  late final String? body;
  final int statusCode;
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  final bool isBase64Encoded;
  HttpResponse(dynamic body,
      {this.statusCode = 200,
      Map<String, String>? headers,
      this.isBase64Encoded = false}) {
    this.body = body != null ? json.encode(body) : null;
    if (headers != null) {
      this.headers.addAll(headers);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "statusCode": statusCode,
      "headers": headers,
      "body": body,
      "isBase64Encoded": isBase64Encoded
    };
  }
}
