import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

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

void defaultHelmetOptionsExpecter(Response response) {
  expect(
    response.headers['content-security-policy'],
    "default-src 'self';base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests",
  );
  expect(response.headers['cross-origin-opener-policy'], 'same-origin');
  expect(response.headers['cross-origin-resource-policy'], 'same-origin');
  expect(response.headers['origin-agent-cluster'], '?1');
  expect(response.headers['referrer-policy'], 'no-referrer');
  expect(
    response.headers['strict-transport-security'],
    'max-age=31536000; includeSubDomains',
  );
  expect(response.headers['x-content-type-options'], 'nosniff');
  expect(response.headers['x-dns-prefetch-control'], 'off');
  expect(response.headers['x-download-options'], 'noopen');
  expect(response.headers['x-frame-options'], 'SAMEORIGIN');
  expect(response.headers['x-permitted-cross-domain-policies'], 'none');
  expect(response.headers['x-xss-protection'], '0');
}
