import 'package:shelf/shelf.dart';

/// The `ReferrerPolicyToken` controls the `Referrer-Policy` header which can be set.
enum ReferrerPolicyToken {
  /// Will set the Referrer-Policy Header to: `no-referrer`
  noReferrer('no-referrer'),

  /// Will set the Referrer-Policy Header to: `no-referrer-when-downgrade`
  noReferrerWhenDowngrade('no-referrer-when-downgrade'),

  /// Will set the Referrer-Policy Header to: `same-origin`
  sameOrigin('same-origin'),

  /// Will set the Referrer-Policy Header to: `origin`
  origin('origin'),

  /// Will set the Referrer-Policy Header to: `strict-origin`
  strictOrigin('strict-origin'),

  /// Will set the Referrer-Policy Header to: `origin-when-cross-origin`
  originWhenCrossOrigin('origin-when-cross-origin'),

  /// Will set the Referrer-Policy Header to: `strict-origin-when-cross-origin`
  strictOriginWhenCrossOrigin('strict-origin-when-cross-origin'),

  /// Will set the Referrer-Policy Header to: `unsafe-url`
  unsafeUrl('unsafe-url'),

  /// Will set the Referrer-Policy Header to: `no-referrer-when-downgrade`
  emptyString('');

  final String token;
  const ReferrerPolicyToken(this.token);
}

/// The [Referer HTTP header](https://en.wikipedia.org/wiki/HTTP_referer) is typically set by web browsers to tell the server where it's coming from. For example, if you click a link on _example.com/index.html_ that takes you to _wikipedia.org_, Wikipedia's servers will see `Referer: example.com`. This can have privacy implications—websites can see where you are coming from. The new [`Referrer-Policy` HTTP header](https://www.w3.org/TR/referrer-policy/#referrer-policy-header) lets authors control how browsers set the Referer header.
///
/// [Read the spec](https://www.w3.org/TR/referrer-policy/#referrer-policies) to see the options you can provide.
///
/// Usage:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart';
///
/// .addMiddleware(referrerPolicy(policies: [ReferrerPolicyToken.sameOrigin])) -> Referrer-Policy: same-origin
///
/// .addMiddleware(referrerPolicy(policies: [ReferrerPolicyToken.unsafeUrl])) -> Referrer-Policy: unsafe-url
///
/// .addMiddleware(referrerPolicy(policies: [ReferrerPolicyToken.noReferrer, ReferrerPolicyToken.unsafeUrl])) -> Referrer-Policy: no-referrer,unsafe-url
///
/// .addMiddleware(referrerPolicy()) -> Referrer-Policy: no-referrer
/// ```
Middleware referrerPolicy({
  List<ReferrerPolicyToken> policies = const [
    ReferrerPolicyToken.noReferrer,
  ],
}) {
  final args = [
    for (final policy in policies)
      policy == ReferrerPolicyToken.emptyString
          ? ReferrerPolicyToken.noReferrerWhenDowngrade.token
          : policy.token
  ];
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'referrer-policy': args, ...response.headersAll},
      );
    };
  };
}
