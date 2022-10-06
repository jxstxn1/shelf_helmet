import 'package:shelf/shelf.dart';

enum CrossOriginEmbedderPolicyOptions {
  requireCorp('require-corp'),
  credentialLess('credentialless');

  final String option;
  const CrossOriginEmbedderPolicyOptions(this.option);
}

/// Sets the `Cross-Origin-Embedder-Policy` header to `require-corp`.
/// See [MDN's article on this header](https://developer.cdn.mozilla.net/en-US/docs/Web/HTTP/Headers/Cross-Origin-Embedder-Policy) for more.
/// Example:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// // Sets Cross-Origin-Embedder-Policy: require-corp
/// .addMiddleware(crossOriginEmbedderPolicy());
///
/// // Sets "Cross-Origin-Embedder-Policy: credentialless"
/// .addMiddleware(crossOriginEmbedderPolicy(
///   policy: CrossOriginEmbedderPolicyOptions.credentialLess
/// ));
Middleware crossOriginEmbedderPolicy({
  CrossOriginEmbedderPolicyOptions policy = CrossOriginEmbedderPolicyOptions.requireCorp,
}) {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'cross-origin-embedder-policy': policy.option, ...response.headersAll},
      );
    };
  };
}
