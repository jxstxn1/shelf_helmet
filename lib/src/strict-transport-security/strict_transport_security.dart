import 'package:shelf/shelf.dart';

/// This middleware adds the `Strict-Transport-Security` header to the response.
/// [maxAge] will tell the browser to cache the HSTS header for the specified amount of time.
/// [includeSubDomains] will tell the browser to include all subdomains of the current domain.
/// [preload] will tell the browser to include this domain in the browser's HSTS preload list.
Middleware strictTransportSecurity({
  Duration maxAge = const Duration(days: 180),
  bool includeSubDomains = true,
  bool preload = false,
}) {
  final List<String> args = [
    'max-age=${maxAge.inSeconds}',
    if (includeSubDomains) 'includeSubDomains',
    if (preload) 'preload',
  ];
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'strict-transport-security': args.join('; '), ...response.headersAll},
      );
    };
  };
}
