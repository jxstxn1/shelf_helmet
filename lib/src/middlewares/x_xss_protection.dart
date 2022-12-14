import 'package:shelf/shelf.dart';

/// The `X-XSS-Protection` HTTP header aimed to offer a basic protection against cross-site scripting (XSS) attacks. _However, you probably should disable it_, which is what this middleware does.
///
/// Many browsers have chosen to remove it because of the unintended security issues it creates. Generally, you should protect against XSS with sanitization and a Content Security Policy. For more, read [this GitHub issue](https://github.com/helmetjs/helmet/issues/230).
///
/// This middleware sets the `X-XSS-Protection` header to `0`.
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// .addMiddleware(xXssProtection())
/// ```
Middleware xXssProtection() {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'x-xss-protection': '0', ...response.headersAll},
      );
    };
  };
}
