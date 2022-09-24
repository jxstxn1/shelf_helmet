import 'dart:async';

import 'package:shelf/shelf.dart';

final Uri clientUri = Uri.parse('http://127.0.0.1:4322/');

/// Copied from the Shelf package.
/// https://github.com/dart-lang/shelf/blob/master/pkgs/shelf/test/test_util.dart
/// A simple, synchronous handler for [Request].
///
/// By default, replies with a status code 200, empty headers, and
/// `Hello from ${request.url.path}`.
Response syncHandler(
  Request request, {
  int? statusCode,
  Map<String, String>? headers,
}) {
  return Response(
    statusCode ?? 200,
    headers: headers,
    body: 'Hello from ${request.requestedUri.path}',
  );
}

Future<Response> makeRequest(
  Handler handler, {
  required Uri uri,
  required String method,
  Map<String, Object>? headers,
  Object? body,
}) {
  return Future.sync(
    () {
      return handler(
        Request(
          method,
          uri,
          headers: headers,
          body: body,
        ),
      );
    },
  );
}
