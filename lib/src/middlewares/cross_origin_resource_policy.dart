import 'package:shelf/shelf.dart';

enum CrossOriginResourcePolicyOptions {
  sameSite('same-site'),
  sameOrigin('same-origin'),
  crossOrigin('cross-origin');

  final String option;
  const CrossOriginResourcePolicyOptions(this.option);
}

/// This middleware sets the `Cross-Origin-Resource-Policy` header. Read about it [in the spec](https://fetch.spec.whatwg.org/#cross-origin-resource-policy-header).
///
/// Usage:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// // Sets Cross-Origin-Resource-Policy: same-origin
/// .addMiddleware(crossOriginResourcePolicy());
///
/// // Sets "Cross-Origin-Resource-Policy: cross-origin"
/// .addMiddleware(crossOriginResourcePolicy(
///   policy: CrossOriginResourcePolicyOptions.crossOrigin
/// ));
///
/// // Sets "Cross-Origin-Resource-Policy: same-site"
/// .addMiddleware(crossOriginResourcePolicy(
///   policy: CrossOriginResourcePolicyOptions.sameSite
/// ));
/// ```
Middleware crossOriginResourcePolicy({
  CrossOriginResourcePolicyOptions policy = CrossOriginResourcePolicyOptions.sameOrigin,
}) {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'cross-origin-resource-policy': policy.option, ...response.headersAll},
      );
    };
  };
}
