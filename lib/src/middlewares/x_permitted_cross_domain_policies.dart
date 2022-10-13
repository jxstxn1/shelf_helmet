import 'package:shelf/shelf.dart';

/// The `X-Permitted-Cross-Domain-Policies` HTTP header controls Adobe Flash Player and Adobe Acrobat's behavior when loading content from other domains.
enum PermittedPolicies {
  /// Will set the X-Permitted-Cross-Domain-Policies Header to: `none`
  none('none'),

  /// Will set the X-Permitted-Cross-Domain-Policies Header to: `master-only`
  masterOnly('master-only'),

  /// Will set the X-Permitted-Cross-Domain-Policies Header to: `by-content-type`
  byContentType('by-content-type'),

  /// Will set the X-Permitted-Cross-Domain-Policies Header to: `all`
  all('all');

  final String policie;
  const PermittedPolicies(this.policie);
}

/// The `X-Permitted-Cross-Domain-Policies` header tells some web clients
/// (like Adobe Flash or Adobe Acrobat) your domain's policy for loading
/// cross-domain content. See the description on
/// [OWASP](https://owasp.org/www-project-secure-headers/) for more.
///
/// Usage:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// // Sets X-Permitted-Cross-Domain-Policies: none
/// .addMiddleware(xPermittedCrossDomainPolies());
///
///
/// // You can use any of the following values:
/// .addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.none));
/// .addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.masterOnly));
/// .addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.byContentType));
/// .addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.all));
/// ```
///
/// The `by-ftp-type` is not currently supported. Please open an issue or pull request if you desire this feature!
///
/// If you don't expect Adobe products to load data from your site, you get a minor security benefit by adding this header.
Middleware xPermittedCrossDomainPolicies({
  PermittedPolicies permittedPolicy = PermittedPolicies.none,
}) {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {
          'x-permitted-cross-domain-policies': permittedPolicy.policie,
          ...response.headersAll
        },
      );
    };
  };
}
