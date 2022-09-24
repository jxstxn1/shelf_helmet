import 'package:shelf/shelf.dart';

enum PermittedPolicies {
  none('none'),
  masterOnly('master-only'),
  byContentType('by-content-type'),
  all('all');

  final String policie;
  const PermittedPolicies(this.policie);
}

Middleware xPermittedCrossDomainPolies({PermittedPolicies permittedPolicie = PermittedPolicies.none}) {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'x-permitted-cross-domain-policies': permittedPolicie.policie, ...response.headersAll},
      );
    };
  };
}
