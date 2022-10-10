import 'package:shelf/shelf.dart';

/// Sets the `Origin-Agent-Cluster` header,
/// which provides a mechanism to allow web applications
/// to isolate their origins.
/// Read more about it [in the spec](https://whatpr.org/html/6214/origin.html#origin-keyed-agent-clusters).
///
/// Examples:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
/// // Sets "Origin-Agent-Cluster: ?1"
/// .addMiddleware(originAgentCluster())
/// ```
Middleware originAgentCluster() {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'origin-agent-cluster': '?1', ...response.headersAll},
      );
    };
  };
}
