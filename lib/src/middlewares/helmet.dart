import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:shelf_helmet/src/middlewares/cross_origin_embedder_policy.dart';
import 'package:shelf_helmet/src/middlewares/cross_origin_opener_policy.dart';
import 'package:shelf_helmet/src/middlewares/x_content_type_options.dart';

/// Helmet middleware for Dart.
/// This middleware sets various HTTP headers to help secure your app.
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// .addMiddleware(helmet());
///
/// ```
///
/// This middleware sets the following headers:
/// ```http
/// Content-Security-Policy: default-src 'self';base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests
/// Cross-Origin-Embedder-Policy: require-corp
/// Cross-Origin-Opener-Policy: same-origin
/// Cross-Origin-Resource-Policy: same-origin
/// Origin-Agent-Cluster: ?1
/// Referrer-Policy: no-referrer
/// Strict-Transport-Security: max-age=15552000; includeSubDomains
/// X-Content-Type-Options: nosniff
/// X-DNS-Prefetch-Control: off
/// X-Download-Options: noopen
/// X-Frame-Options: SAMEORIGIN
/// X-Permitted-Cross-Domain-Policies: none
/// X-XSS-Protection: 0
/// ```
///
/// If you  want to set the headers manually or only use some of the included middlewares, check out the documentation for the individual middlewares
Middleware helmet({
  HelmetOptions options = const HelmetOptions(),
}) {
  final List<Middleware> middlewares = [
    if (options.enableContentSecurityPolicy)
      contentSecurityPolicy(options: options.cspOptions),
    if (options.enableCrossOriginEmbedderPolicy)
      crossOriginEmbedderPolicy(policy: options.coepOptions),
    if (options.enableCrossOriginOpenerPolicy)
      crossOriginOpenerPolicy(policy: options.coopOptions),
    if (options.enableCrossOriginResourcePolicy)
      crossOriginResourcePolicy(policy: options.corpOptions),
    if (options.enableOriginAgentCluster) originAgentCluster(),
    if (options.enableReferrerPolicy)
      referrerPolicy(policies: options.referrerPolicyTokens),
    if (options.enableStrictTransportSecurity)
      strictTransportSecurity(options: options.strictTransportSecurityOptions),
    if (options.enableXContentTypeOptions) xContentTypeOptions(),
    if (options.enableXDnsPrefetchControl)
      xDnsPrefetchControl(allow: options.allowXDnsPrefetchControl),
    if (options.enableXDownloadOptions) xDownloadOptions(),
    if (options.enableXFrameOptions)
      xFrameOptions(xFrameOption: options.xFrameOptionsToken),
    if (options.enableXPermittedCrossDomainPolicies)
      xPermittedCrossDomainPolicies(
        permittedPolicy: options.xPermittedPoliciesToken,
      ),
    if (options.enableXXssProtection) xXssProtection(),
  ];
  Pipeline pipeline = const Pipeline();
  if (middlewares.isEmpty) {
    throw ArgumentError(
      'No middlewares were provided, consider removing helmet()',
    );
  }
  for (final middleware in middlewares) {
    pipeline = pipeline.addMiddleware(middleware);
  }
  return (innerHandler) => pipeline.addHandler(innerHandler);
}

/// Options for the [helmet] middleware.
/// Set the options beginning with `enable` to `false` to disable the header.
class HelmetOptions {
  final bool enableContentSecurityPolicy;
  final bool enableCrossOriginEmbedderPolicy;
  final bool enableCrossOriginOpenerPolicy;
  final bool enableCrossOriginResourcePolicy;
  final bool enableOriginAgentCluster;
  final bool enableReferrerPolicy;
  final bool enableStrictTransportSecurity;
  final bool enableXContentTypeOptions;
  final bool enableXDnsPrefetchControl;
  final bool enableXDownloadOptions;
  final bool enableXFrameOptions;
  final bool enableXPermittedCrossDomainPolicies;
  final bool enableXXssProtection;

  final ContentSecurityPolicyOptions cspOptions;
  final CrossOriginEmbedderPolicyOptions coepOptions;
  final CrossOriginOpenerPolicyOptions coopOptions;
  final CrossOriginResourcePolicyOptions corpOptions;
  final List<ReferrerPolicyToken> referrerPolicyTokens;
  final StrictTransportSecurityOptions strictTransportSecurityOptions;
  final bool allowXDnsPrefetchControl;
  final XFrameOptions xFrameOptionsToken;
  final PermittedPolicies xPermittedPoliciesToken;

  const HelmetOptions({
    this.enableContentSecurityPolicy = true,
    this.cspOptions = const ContentSecurityPolicyOptions.useDefaults(),
    this.enableCrossOriginEmbedderPolicy = true,
    this.coepOptions = CrossOriginEmbedderPolicyOptions.requireCorp,
    this.enableCrossOriginOpenerPolicy = true,
    this.coopOptions = CrossOriginOpenerPolicyOptions.sameOrigin,
    this.enableCrossOriginResourcePolicy = true,
    this.corpOptions = CrossOriginResourcePolicyOptions.sameOrigin,
    this.enableOriginAgentCluster = true,
    this.enableReferrerPolicy = true,
    this.referrerPolicyTokens = const [ReferrerPolicyToken.noReferrer],
    this.enableStrictTransportSecurity = true,
    this.strictTransportSecurityOptions =
        const StrictTransportSecurityOptions(),
    this.enableXContentTypeOptions = true,
    this.enableXDnsPrefetchControl = true,
    this.allowXDnsPrefetchControl = false,
    this.enableXDownloadOptions = true,
    this.enableXFrameOptions = true,
    this.xFrameOptionsToken = XFrameOptions.sameorigin,
    this.enableXPermittedCrossDomainPolicies = true,
    this.xPermittedPoliciesToken = PermittedPolicies.none,
    this.enableXXssProtection = true,
  });
}
