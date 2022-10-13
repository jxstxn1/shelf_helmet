import 'package:shelf/shelf.dart';

enum CrossOriginOpenerPolicyOptions {
  sameOrigin('same-origin'),
  sameOriginAllowPopUps('same-origin-allow-popups'),
  unsafeNone('unsafe-none');

  final String option;
  const CrossOriginOpenerPolicyOptions(this.option);
}

/// Sets the `Cross-Origin-Opener-Policy` header.
/// For more, see [MDN's article on this header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Opener-Policy).
/// Example:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// // Sets Cross-Origin-Opener-Policy: same-origin
/// .addMiddleware(crossOriginOpenerPolicy());
///
/// // Sets "Cross-Origin-Opener-Policy: same-origin-allow-popups"
/// .addMiddleware(crossOriginOpenerPolicy(
///   policy: CrossOriginOpenerPolicyOptions.sameOriginAllowPopUps
/// ));
///
/// // Sets "Cross-Origin-Opener-Policy: unsafe-none"
/// .addMiddleware(crossOriginOpenerPolicy(
///   policy: CrossOriginOpenerPolicyOptions.unsafeNone
/// ));
/// ```
Middleware crossOriginOpenerPolicy({
  CrossOriginOpenerPolicyOptions policy =
      CrossOriginOpenerPolicyOptions.sameOrigin,
}) {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {
          'cross-origin-opener-policy': policy.option,
          ...response.headersAll
        },
      );
    };
  };
}
