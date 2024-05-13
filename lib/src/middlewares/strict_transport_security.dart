import 'package:shelf/shelf.dart';

/// This middleware adds the `Strict-Transport-Security` header to the response.
/// This tells browsers, "hey, only use HTTPS for the next period of time".
/// ([See the spec](https://tools.ietf.org/html/rfc6797) for more.)
/// Note that the header won't tell users on HTTP to _switch_ to HTTPS,
/// it will just tell HTTPS users to stick around.
/// You can enforce HTTPS with the [shelf-enforces-ssl](https://pub.dev/packages/shelf_enforces_ssl) package.
///
/// This will set the Strict Transport Security header, telling browsers to visit by HTTPS for the next 365 days:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart';
///
/// .addMiddleware(strictTransportSecurity())
///
/// // Sets "Strict-Transport-Security: max-age=15552000; includeSubDomains"
/// ```
///
/// Note that the max age must be in seconds.
///
/// The `includeSubDomains` directive is present by default.
/// If this header is set on _example.com_, supported browsers will also use HTTPS on _my-subdomain.example.com_.
///
/// You can disable this:
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart';
///
/// .addMiddleware(strictTransportSecurity(includeSubDomains: false))
/// ```
///
/// Some browsers let you submit your site's HSTS to be baked into the browser.
/// You can add `preload` to the header with the following code.
/// You can check your eligibility and submit your site at [hstspreload.org](https://hstspreload.org/).
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart';
///
/// .addMiddleware(
///     strictTransportSecurity(
///         maxAge: const Duration(days: 365), // Must be at least 1 year to be approved
///         preload: true
///     ),
/// )
/// ```
///
/// [The header is ignored in insecure HTTP](https://tools.ietf.org/html/rfc6797#section-8.1), so it's safe to set in development.
///
/// This header is [somewhat well-supported by browsers](https://caniuse.com/#feat=stricttransportsecurity).
Middleware strictTransportSecurity({
  StrictTransportSecurityOptions options =
      const StrictTransportSecurityOptions(),
}) {
  final List<String> args = [
    'max-age=${options.maxAge.inSeconds}',
    if (options.includeSubDomains) 'includeSubDomains',
    if (options.preload) 'preload',
  ];
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {
          'strict-transport-security': args.join('; '),
          ...response.headersAll,
        },
      );
    };
  };
}

class StrictTransportSecurityOptions {
  final Duration maxAge;
  final bool includeSubDomains;
  final bool preload;

  const StrictTransportSecurityOptions({
    this.maxAge = const Duration(days: 365),
    this.includeSubDomains = true,
    this.preload = false,
  });
}
