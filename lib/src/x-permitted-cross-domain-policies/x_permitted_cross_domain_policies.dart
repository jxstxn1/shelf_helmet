import 'package:shelf/shelf.dart';

enum PermittedPolicies {
  none('none'),
  masterOnly('master-only'),
  byContentType('by-content-type'),
  all('all');

  final String policie;
  const PermittedPolicies(this.policie);
}

/// The `X-Permitted-Cross-Domain-Policies` header tells some web
/// clients (like Adobe Flash or Adobe Acrobat) your domain's
/// policy for loading cross-domain content. See the description on
/// [OWASP](https://owasp.org/www-project-secure-headers/) for more.
///
/// [permittedPolicies] the policy to set for the header.
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
