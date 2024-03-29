import 'package:shelf/shelf.dart';

enum XFrameOptions {
  deny('DENY'),
  sameorigin('SAMEORIGIN');

  final String option;
  const XFrameOptions(this.option);
}

/// The `X-Frame-Options` HTTP header restricts who can put your site in a frame which can help mitigate things like [clickjacking attacks](https://en.wikipedia.org/wiki/Clickjacking). The header has two modes: `DENY` and `SAMEORIGIN`.
///
/// This header is superseded by [the `frame-ancestors` Content Security Policy directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-ancestors) but is still useful on old browsers.
///
/// If your app does not need to be framed (and most don't) you can use `DENY`. If your site can be in frames from the same origin, you can set it to `SAMEORIGIN`.
///
/// Usage:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// // Sets X-Frame-Options: sameorigin
/// .addMiddleware(xPermittedCrossDomainPolies());
///
///
/// // You can use any of the following values:
/// .addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.deny));
/// .addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.sameorigin));
/// ```
Middleware xFrameOptions({
  XFrameOptions xFrameOption = XFrameOptions.sameorigin,
}) {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {
          'x-frame-options': xFrameOption.option,
          ...response.headersAll,
        },
      );
    };
  };
}
