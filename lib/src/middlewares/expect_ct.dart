import 'package:shelf/shelf.dart';

/// This header is not part of the Helmet middleware
/// The `Expect-CT` HTTP header tells browsers to expect Certificate Transparency.
/// For more, see [this blog post](https://scotthelme.co.uk/a-new-security-header-expect-ct/)
/// and the [article on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Expect-CT).
///
/// Usage:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// // Sets Expect-CT: max-age=123
/// .addMiddleware(expectCt({ maxAge: Duration(seconds: 123) }));
///
/// // Sets Expect-CT: max-age=123, enforce
/// .addMiddleware(
///   expectCt({
///     enforce: true,
///     maxAge: Duration(seconds: 123),
///   })
/// );
///
/// // Sets Expect-CT: max-age=30, enforce, report-uri="https://example.com/report"
/// .addMiddleware(
///   expectCt({
///     enforce: true,
///     maxAge: Duration(seconds: 30),
///     reportUri: "https://example.com/report",
///   })
/// );
/// ```
Middleware expectCt({
  Duration maxAge = Duration.zero,
  bool enforce = false,
  Uri? reportUri,
}) {
  final List<String> args = [
    'max-age=${maxAge.inSeconds}',
    if (enforce) 'enforce',
    if (reportUri != null) 'report-uri="$reportUri"',
  ];
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'expect-ct': args.join(', '), ...response.headersAll},
      );
    };
  };
}
