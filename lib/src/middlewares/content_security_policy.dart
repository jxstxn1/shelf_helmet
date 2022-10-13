import 'package:shelf/shelf.dart';

typedef Directive = Map<String, List<String>?>;

extension CSPExtensions on String {
  /// Replaces all Uppercase letters with an dash and lowercase letter.
  String dashify() {
    return replaceAllMapped(RegExp('([A-Z])'), (match) {
      return '-${match.group(0)}'.toLowerCase();
    });
  }

  /// Validates the given string to be a valid CSP directive.
  bool isDirectiveValueInvalid() {
    return contains(RegExp(';|,'));
  }

  /// Validates the given string to be a valid CSP directive.
  bool isDirectiveNameInvalid() {
    return contains(RegExp("[^a-zA-Z0-9-]"));
  }
}

/// Options for the Content Security Policy middleware.
class ContentSecurityPolicyOptions {
  const ContentSecurityPolicyOptions({
    /// The default policy to use if no other policy is specified.
    required this.useDefaults,

    /// If true the middleware will add the `Content-Security-Policy-Report-Only` header.
    required this.reportOnly,

    /// The CSP directives to use.
    required this.directives,

    /// Disabling the default-src directive. This is not recommended.
    required this.dangerouslyDisableDefaultSrc,
  });

  /// Preconfigured options for the default CSP policy.
  const ContentSecurityPolicyOptions.useDefaults({
    bool useDefaults = true,
    bool reportOnly = false,
    Map<String, List<String>?> directives = const {},
  }) : this(
          useDefaults: useDefaults,
          reportOnly: reportOnly,
          directives: directives,
          dangerouslyDisableDefaultSrc: false,
        );

  /// Preconfigured options for disabling the Default Src which is dangerous.
  const ContentSecurityPolicyOptions.dangerouslyDisableDefaultSrc({
    bool useDefaults = true,
    bool reportOnly = false,
    Map<String, List<String>?> directives = const {},
  }) : this(
          useDefaults: useDefaults,
          reportOnly: reportOnly,
          directives: directives,
          dangerouslyDisableDefaultSrc: true,
        );

  /// Default CSP policy directives.
  static const Map<String, List<String>?> getDefaultDirectives = {
    'default-src': ["'self'"],
    'base-uri': ["'self'"],
    'font-src': ["'self'", 'https:', 'data:'],
    'form-action': ["'self'"],
    'frame-ancestors': ["'self'"],
    'img-src': ["'self'", 'data:'],
    'object-src': ["'none'"],
    'script-src': ["'self'"],
    'script-src-attr': ["'none'"],
    'style-src': ["'self'", 'https:', "'unsafe-inline'"],
    'upgrade-insecure-requests': [],
  };

  final bool dangerouslyDisableDefaultSrc;
  final bool useDefaults;
  final bool reportOnly;
  final Directive directives;
}

/// Content Security Policy (CSP) helps prevent unwanted content from being injected/loaded into your webpages. This can mitigate cross-site scripting (XSS) vulnerabilities, clickjacking, formjacking, malicious frames, unwanted trackers, and other web client-side attacks.
/// If you want to learn how CSP works, check out the fantastic [HTML5 Rocks guide](https://www.html5rocks.com/en/tutorials/security/content-security-policy/), the [Content Security Policy Reference](https://content-security-policy.com/), and the [Content Security Policy specification](https://www.w3.org/TR/CSP/).
///
/// This middleware helps set Content Security Policies.
///
/// Basic usage:
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// .addMiddleware(
///   contentSecurityPolicy(
///     options: const ContentSecurityPolicyOptions.useDefaults(
///       useDefaults: true,
///       directives: {
///         defaultSrc: ["'self'", "default.example"],
///         scriptSrc: ["'self'", "js.example.com"],
///         objectSrc: ["'none'"],
///         upgradeInsecureRequests: [],
///       },
///       reportOnly: false,
///     ),
///   ),
/// );
/// ```
///
/// If no directives are supplied, the following policy is set (whitespace added for readability):
///
///     default-src 'self';
///     base-uri 'self';
///     font-src 'self' https: data:;
///     form-action 'self';
///     frame-ancestors 'self';
///     img-src 'self' data:;
///     object-src 'none';
///     script-src 'self';
///     script-src-attr 'none';
///     style-src 'self' https: 'unsafe-inline';
///     upgrade-insecure-requests
///
/// You can use this default with the `ContentSecurityPolicyOptions.useDefaults()` constructor or set the bool to true. `useDefaults` is `true` by default.
///
/// You can also get the default directives object with `ContentSecurityPolicy.getDefaultDirectives`.
///
/// You can set any directives you wish. `defaultSrc` is required, but can be explicitly disabled by using the `ContentSecurityPolicyOptions.dangerouslyDisableDefaultSrc()` constructor. Directives can be kebab-cased (like `script-src`) or camel-cased (like `scriptSrc`). They are equivalent, but duplicates are not allowed.
///
/// The `reportOnly` option, if set to `true`, sets the `Content-Security-Policy-Report-Only` header instead. If you want to set _both_ the normal and `Report-Only` headers, you can do this like described here:
/// ```dart
/// .addMiddleware(
///   contentSecurityPolicy(
///     options: const ContentSecurityPolicyOptions.useDefaults(
///       useDefaults: true,
///       reportOnly: false,
///     ),
///   ),
/// );
/// .addMiddleware(
///   contentSecurityPolicy(
///     options: const ContentSecurityPolicyOptions.useDefaults(
///       useDefaults: true,
///       reportOnly: true,
///     ),
///   ),
/// );
/// ```
///
/// This middleware does minimal validation. You should use a more sophisticated CSP validator, like [Google's CSP Evaluator](https://csp-evaluator.withgoogle.com/), to make sure your CSP looks good.
///
/// ## See also
///
/// - [Google's CSP Evaluator tool](https://csp-evaluator.withgoogle.com/)
/// - [CSP Scanner](https://cspscanner.com/)
/// - [GitHub's CSP journey](https://githubengineering.com/githubs-csp-journey/)
/// - [Content Security Policy for Single Page Web Apps](https://developer.squareup.com/blog/content-security-policy-for-single-page-web-apps/)
Middleware contentSecurityPolicy({
  ContentSecurityPolicyOptions options =
      const ContentSecurityPolicyOptions.useDefaults(),
}) {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {
          options.reportOnly
                  ? 'Content-Security-Policy-Report-Only'
                  : 'Content-Security-Policy':
              getHeaderValue(_normalizeDirectives(options))
        },
      );
    };
  };
}

String getHeaderValue(Directive normalizedDirectives) {
  final List<String> result = [];

  normalizedDirectives.forEach((directiveName, rawDirectiveValue) {
    final directiveValue = StringBuffer();
    if (rawDirectiveValue != null) {
      for (final element in rawDirectiveValue) {
        directiveValue.write(' $element');
      }
    }
    result.add('$directiveName$directiveValue');
  });

  return result.join(';');
}

Directive _normalizeDirectives(ContentSecurityPolicyOptions options) {
  final Directive rawDirectives = options.directives;

  final Directive normalizedDirectives = {};
  final List<String> directiveNamesSeen = [];
  final List<String> directivesExplicitlyDisabled = [
    if (options.dangerouslyDisableDefaultSrc) 'default-src'
  ];

  for (final rawDirective in rawDirectives.entries) {
    final rawDirectiveName = rawDirective.key;
    if (rawDirectiveName.isEmpty || rawDirectiveName.isDirectiveNameInvalid()) {
      throw ArgumentError(
        'Content-Security-Policy received an invalid directive name: $rawDirectiveName',
      );
    }

    final directiveName = rawDirectiveName.dashify();

    if (directiveNamesSeen.contains(directiveName)) {
      throw ArgumentError(
        'Content-Security-Policy received two directives with the same name: $directiveName',
      );
    }

    directiveNamesSeen.add(directiveName);

    final rawDirectiveValue = rawDirective.value;
    final directiveValue = <String>[];
    if (rawDirectiveValue == null) {
      if (directiveName == 'default-src') {
        throw ArgumentError(
          'Content-Security-Policy needs a default-src but it was set to `null`. If you really want to disable it, set it to `ContentSecurityPolicyOptions.dangerouslyDisableDefaultSrc`.',
        );
      }
      directivesExplicitlyDisabled.add(directiveName);
      continue;
    } else {
      directiveValue.addAll(rawDirectiveValue);
    }
    for (final String value in directiveValue) {
      if (value.isDirectiveValueInvalid()) {
        throw ArgumentError(
          'Content-Security-Policy received an invalid directive value for $directiveName: $value',
        );
      }
    }
    normalizedDirectives.addAll({directiveName: directiveValue});
  }

  if (options.useDefaults) {
    for (final defaultEntry
        in ContentSecurityPolicyOptions.getDefaultDirectives.entries) {
      if (!normalizedDirectives.containsKey(defaultEntry.key) &&
          !directivesExplicitlyDisabled.contains(defaultEntry.key)) {
        normalizedDirectives.addAll({defaultEntry.key: defaultEntry.value});
      }
    }
  }

  if (normalizedDirectives.isEmpty) {
    throw ArgumentError(
      'Content-Security-Policy has no directives. Either set some or disable the header',
    );
  }

  if (!normalizedDirectives.containsKey('default-src') &&
      !directivesExplicitlyDisabled.contains('default-src')) {
    throw ArgumentError(
      'Content-Security-Policy needs a default-src but none was provided. If you really want to disable it, set it to `contentSecurityPolicy.dangerouslyDisableDefaultSrc`.',
    );
  }
  return normalizedDirectives;
}
