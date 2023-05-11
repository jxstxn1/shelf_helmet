# Shelf_Helmet

[![codecov](https://codecov.io/gh/jxstxn1/shelf_helmet/branch/main/graph/badge.svg?token=HIH71QVQNQ)](https://codecov.io/gh/jxstxn1/shelf_helmet)

Shelf_Helmet helps you secure your Dart Shelf and Frog apps by setting various HTTP headers. _It's not a silver bullet_, but it can help!
Heavily inspired by [helmetjs](https://helmetjs.github.io/).

## Quick start

First, run `dart pub add shelf_helmet` for your app. Then:

### As shelf middleware

```dart
import 'package:shelf_helmet/shelf_helmet.dart';

var handler = const Pipeline()
    .addMiddleware(helmet())
    .addMiddleware(logRequests())
    .addHandler(_echoRequest);
```

### As dart_frog middleware

```dart
import 'package:shelf_helmet/shelf_helmet.dart';

Handler helmet(Handler handler) {
  return handler.use(
    fromShelfMiddleware(helmet()),
  );
}
```

By default, Helmet sets the following headers:

```http
Content-Security-Policy: default-src 'self';base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Resource-Policy: same-origin
Origin-Agent-Cluster: ?1
Referrer-Policy: no-referrer
Strict-Transport-Security: max-age=15552000; includeSubDomains
X-Content-Type-Options: nosniff
X-DNS-Prefetch-Control: off
X-Download-Options: noopen
X-Frame-Options: SAMEORIGIN
X-Permitted-Cross-Domain-Policies: none
X-XSS-Protection: 0
```

To set custom options for a header, add options like this:

```dart
// This sets custom options for the `referrerPolicy` middleware.
.addMiddleware(
    helmet(
        options: HelmetOptions(
            referrerPolicyTokens: [
                ReferrerPolicyToken.noReferrer,
                ReferrerPolicyToken.sameOrigin,
            ],
        ),
    ),
);
```

You can also disable a middleware:

```dart
// This disables the `contentSecurityPolicy` middleware but keeps the rest.
.addMiddleware(
    helmet(
        options: HelmetOptions(
            enableContentSecurityPolicy: false,
        ),
    ),
);
```

## How it works

Helmet is [Shelf](https://pub.dev/packages/shelf)  and [Dart Frog](https://dartfrog.vgv.dev) middleware.If you need support for other frameworks or languages, [see this list](https://helmetjs.github.io/see-also/).)

The top-level `helmet` function is a wrapper around 13 smaller middlewares.

In other words, these two code snippets are equivalent:

```js
import 'package:shelf_helmet/shelf_helmet.dart';

// ...

.addMiddleware(helmet())
```

```js
import 'package:shelf_helmet/shelf_helmet.dart';

// ...

.addMiddleware(contentSecurityPolicy())
.addMiddleware(crossOriginOpenerPolicy())
.addMiddleware(crossOriginResourcePolicy())
.addMiddleware(originAgentCluster())
.addMiddleware(referrerPolicy())
.addMiddleware(strictTransportSecurity())
.addMiddleware(xContentTypeOptions())
.addMiddleware(xDnsPrefetchControl())
.addMiddleware(xDownloadOptions())
.addMiddleware(xFrameOptions())
.addMiddleware(xPermittedCrossDomainPolicies())
.addMiddleware(xXssProtection())
```

## Reference

<details>
<summary><code>helmet(options)</code></summary>

Helmet is the top-level middleware for this module, including all 13 others.

```dart
// Includes all 13 middlewares
.addMiddleware(helmet());
```

If you want to disable one, pass options to `helmet`. For example, to disable `frameguard`:

```dart
// Includes 12 out of 13 middlewares, skipping `helmet.frameguard`
.addMiddleware(
  helmet(options: HelmetOptions(enableXFrameOptions: false)),
);
```

Most of the middlewares have options, which are documented in more detail below. For example, to pass `{ action: "deny" }` to `frameguard`:

```dart
// Includes all 13 middlewares, setting an option for `XFrameOptions`
.addMiddleware(
  helmet(options: HelmetOptions(xFrameOptionsToken: XFrameOptionsAction.deny)),
);
```

Each middleware's name is listed below.

</details>

<details>
<summary><code>contentSecurityPolicy(options)</code></summary>

Default:

```http
Content-Security-Policy: default-src 'self';base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests
```

`contentSecurityPolicy` sets the `Content-Security-Policy` header which helps mitigate cross-site scripting attacks, among other things. See [MDN's introductory article on Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP).

This middleware performs very little validation. You should rely on CSP checkers like [CSP Evaluator](https://csp-evaluator.withgoogle.com/) instead.

You can use this default with the `ContentSecurityPolicyOptions.useDefaults()` constructor or set the bool to true. `useDefaults` is `true` by default.

You can set any directives you wish. `defaultSrc` is required, but can be explicitly disabled by using the `ContentSecurityPolicyOptions.dangerouslyDisableDefaultSrc()` constructor. Directives can be kebab-cased (like `script-src`) or camel-cased (like `scriptSrc`). They are equivalent, but duplicates are not allowed.

These directives are merged into a default policy, which you can disable by setting `ContentSecurityPolicyOptions(useDefaults: false)`. Here is the default policy (whitespace added for readability):

```http
    default-src 'self';
    base-uri 'self';
    font-src 'self' https: data:;
    form-action 'self';
    frame-ancestors 'self';
    img-src 'self' data:;
    object-src 'none';
    script-src 'self';
    script-src-attr 'none';
    style-src 'self' https: 'unsafe-inline';
    upgrade-insecure-requests
```

`ContentSecurityPolicyOptions(reportOnly)` is a boolean, defaulting to `false`. If `true`, [the `Content-Security-Policy-Report-Only` header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only) will be set instead. If you want to set _both_ the normal and `Report-Only` headers, see this code snippet:

```dart
.addMiddleware(
  contentSecurityPolicy(
    options: const ContentSecurityPolicyOptions.useDefaults(
      useDefaults: true,
      reportOnly: false,
    ),
  ),
);
.addMiddleware(
  contentSecurityPolicy(
    options: const ContentSecurityPolicyOptions.useDefaults(
      useDefaults: true,
      reportOnly: true,
    ),
  ),
);
```

You can also get the default directives object with `ContentSecurityPolicy.getDefaultDirectives`.`.

Examples:

```dart
// Sets all of the defaults, but overrides `script-src` and disables the default `style-src`
.addMiddleware(
  contentSecurityPolicy(
    options: const ContentSecurityPolicyOptions.useDefaults(
        directives: {
          "script-src": ["'self'", "example.com"],
          "style-src": null,
        },
    ),
  ),
);

// Sets "Content-Security-Policy: default-src 'self';script-src 'self' example.com;object-src 'none';upgrade-insecure-requests"
.addMiddleware(
  contentSecurityPolicy(
    options: const ContentSecurityPolicyOptions(
        useDefaults: false,
        reportOnly: false
        dangerouslyDisableDefaultSrc: false,
        directives: {
          defaultSrc: ["'self'"],
          scriptSrc: ["'self'", "example.com"],
          objectSrc: ["'none'"],
          upgradeInsecureRequests: [],
        },
    ),
  ),
);

// Sets the "Content-Security-Policy-Report-Only" header instead
.addMiddleware(
    contentSecurityPolicy(
        options: const ContentSecurityPolicyOptions.useDefaults(
            directives: {
                /* ... */
            },
            reportOnly: true,
        ),
    ),
);

// Sets "Content-Security-Policy: script-src 'self'"
.addMiddleware(
    contentSecurityPolicy(
        options: const ContentSecurityPolicyOptions.dangerouslyDisableDefaultSrc(
            useDefaults: false,
            directives: {
                "script-src": ["'self'"],
            },
        ),
    ),
);

// Sets the `frame-ancestors` directive to "'none'"
// See also: `xFrameOptions`
.addMiddleware(
    contentSecurityPolicy(
        options: const ContentSecurityPolicyOptions.useDefaults(
            directives: {
              frameAncestors: ["'none'"],
            },
        ),
    ),
);
```

You can install this module separately as `contentSecurityPolicy`.

</details>

<details>
<summary><code>crossOriginEmbedderPolicy(options)</code></summary>

This header is not set by default.

The `Cross-Origin-Embedder-Policy` header helps control what resources can be loaded cross-origin. See [MDN's article on this header](https://developer.cdn.mozilla.net/en-US/docs/Web/HTTP/Headers/Cross-Origin-Embedder-Policy) for more.

Standalone example:

```dart
import 'package:shelf_helmet/shelf_helmet.dart'

// Helmet does not set Cross-Origin-Embedder-Policy
// by default.
.addMiddleware(helmet());

// Sets "Cross-Origin-Embedder-Policy: credentialless"
.addMiddleware(
    helmet(
      options: HelmetOptions(
        coepOptions: CrossOriginEmbedderPolicyOptions.credentialLess,
      ),
    );
);
```

You can't install this module separately.

</details>

<details>
<summary><code>crossOriginOpenerPolicy()</code></summary>

```http
Cross-Origin-Opener-Policy: same-origin
```

`crossOriginOpenerPolicy` sets the `Cross-Origin-Opener-Policy` header. For more, see [MDN's article on this header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Opener-Policy).

Example usage with Helmet:

```dart
// Uses the default Helmet options and adds the `crossOriginOpenerPolicy` middleware.

// Sets "Cross-Origin-Opener-Policy: same-origin"
.addMiddleware(helmet());

// Sets "Cross-Origin-Opener-Policy: same-origin-allow-popups"
.addMiddleware(helmet(
    options: const HelmetOptions(
        coop: CrossOriginOpenerPolicyOptions.sameOriginAllowPopups,
    ),
));
```

You can't install this module separately.

</details>

<details>
<summary><code>crossOriginResourcePolicy()</code></summary>

Default:

```http
Cross-Origin-Resource-Policy: same-origin
```

`crossOriginResourcePolicy` sets the `Cross-Origin-Resource-Policy` header. For more, see ["Consider deploying Cross-Origin Resource Policy](https://resourcepolicy.fyi/) and [MDN's article on this header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Resource-Policy).

Example usage with Helmet:

```js
// Uses the default Helmet options and adds the `crossOriginResourcePolicy` middleware.

// Sets "Cross-Origin-Resource-Policy: same-origin"
app.use(helmet());

// Sets "Cross-Origin-Resource-Policy: same-site"
.addMiddleware(helmet(
    options: const HelmetOptions(
        corpOptions: CrossOriginCrossOriginResourcePolicyOptions.sameSite,
    ),
));
```

Standalone example:

```dart
import 'package:shelf_helmet/shelf_helmet.dart'

// Sets Cross-Origin-Resource-Policy: same-origin
.addMiddleware(crossOriginResourcePolicy());

// Sets "Cross-Origin-Resource-Policy: cross-origin"
.addMiddleware(crossOriginResourcePolicy(
  policy: CrossOriginResourcePolicyOptions.crossOrigin
));

// Sets "Cross-Origin-Resource-Policy: same-site"
.addMiddleware(crossOriginResourcePolicy(
  policy: CrossOriginResourcePolicyOptions.sameSite
));
```

You can install this module separately as `crossOriginResourcePolicy`.

</details>

<details>
<summary><code>helmet.referrerPolicy(options)</code></summary>

Default:

```http
Referrer-Policy: no-referrer
```

`referrerPolicy` sets the `Referrer-Policy` header which controls what information is set in [the `Referer` header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referer). See ["Referer header: privacy and security concerns"](https://developer.mozilla.org/en-US/docs/Web/Security/Referer_header:_privacy_and_security_concerns) and [the header's documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy) on MDN for more.

`options.policy` is a string or array of strings representing the policy. If passed as an array, it will be joined with commas, which is useful when setting [a fallback policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy#Specifying_a_fallback_policy). It defaults to `no-referrer`.

Examples:

```dart
import 'package:shelf_helmet/shelf_helmet.dart';

.addMiddleware(referrerPolicy(policies: [ReferrerPolicyToken.sameOrigin])) -> Referrer-Policy: same-origin

.addMiddleware(referrerPolicy(policies: [ReferrerPolicyToken.unsafeUrl])) -> Referrer-Policy: unsafe-url

.addMiddleware(referrerPolicy(policies: [ReferrerPolicyToken.noReferrer, ReferrerPolicyToken.unsafeUrl])) -> Referrer-Policy: no-referrer,unsafe-url

.addMiddleware(referrerPolicy()) -> Referrer-Policy: no-referrer
```

You can install this module separately as `referrerPolicy`.

</details>

<details>
<summary><code>strictTransportSecurity</code></summary>

Default:

```http
Strict-Transport-Security: max-age=15552000; includeSubDomains
```

This middleware adds the `Strict-Transport-Security` header to the response.
This tells browsers, "hey, only use HTTPS for the next period of time".
([See the spec](https://tools.ietf.org/html/rfc6797) for more.)
Note that the header won't tell users on HTTP to _switch_ to HTTPS,
it will just tell HTTPS users to stick around.
You can enforce HTTPS with the [shelf-enforces-ssl](https://pub.dev/packages/shelf_enforces_ssl) package.

This will set the Strict Transport Security header, telling browsers to visit by HTTPS for the next 180 days:

```dart
import 'package:shelf_helmet/shelf_helmet.dart';

.addMiddleware(strictTransportSecurity())

// Sets "Strict-Transport-Security: max-age=15552000; includeSubDomains"
```

Note that the max age must be in seconds.

The `includeSubDomains` directive is present by default.
If this header is set on _example.com_, supported browsers will also use HTTPS on _my-subdomain.example.com_.

You can disable this:  

```dart
import 'package:shelf_helmet/shelf_helmet.dart';

.addMiddleware(strictTransportSecurity(includeSubDomains: false))
```

Some browsers let you submit your site's HSTS to be baked into the browser.
You can add `preload` to the header with the following code.
You can check your eligibility and submit your site at [hstspreload.org](https://hstspreload.org/).

```dart
import 'package:shelf_helmet/shelf_helmet.dart';

.addMiddleware(
    strictTransportSecurity(
        maxAge: const Duration(days: 365), // Must be at least 1 year to be approved
        preload: true
    ),
)
```

^ [The header is ignored in insecure HTTP](https://tools.ietf.org/html/rfc6797#section-8.1), so it's safe to set in development.

This header is [somewhat well-supported by browsers](https://caniuse.com/#feat=stricttransportsecurity).

</details>

<details>
<summary><code>xContentTypeOptions</code></summary>

Default:

```http
X-Content-Type-Options: nosniff
```

Some browsers will try to "sniff" mimetypes. For example,
if my server serves _file.txt_ with a _text/plain_ content-type,
some browsers can still run that file with `<script src="file.txt"></script>`.
Many browsers will allow _file.js_ to be run even if the content-type isn't for JavaScript.
Browsers' same-origin policies generally prevent remote resources from
being loaded dangerously, but vulnerabilities in web browsers
can cause this to be abused.
Some browsers, like [Chrome](https://developers.google.com/web/updates/2018/07/site-isolation),
will further isolate memory if the `X-Content-Type-Options` header is seen.

There are [some other vulnerabilities](https://miki.it/blog/2014/7/8/abusing-jsonp-with-rosetta-flash/), too.

This middleware prevents Chrome, Opera 13+, IE 8+ and
[Firefox 50+](https://bugzilla.mozilla.org/show_bug.cgi?id=471020)
from doing this sniffing. The following example sets the `X-Content-Type-Options`
header to its only option, `nosniff`:

```dart
import 'package:shelf_helmet/shelf_helmet.dart'

.addMiddleware(xContentTypeOptions())
```

[MSDN has a good description](https://msdn.microsoft.com/en-us/library/gg622941%28v=vs.85%29.aspx)
of how browsers behave when this header is sent.

You can't install this module separately.

</details>

<details>
<summary><code>xDnsPrefetchControl</code></summary>

Default:

```http
X-DNS-Prefetch-Control: off
```

This middleware lets you set the `X-DNS-Prefetch-Control` to control
browsers' DNS prefetching.
Read more about it [on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Controlling_DNS_prefetching)
and [on Chromium's docs](https://dev.chromium.org/developers/design-documents/dns-prefetching).

Usage:

```dart
import 'package:shelf_helmet/shelf_helmet.dart'

//Set X-DNS-Prefetch-Control: off
.addMiddleware(xDownloadOptions())

//Set X-DNS-Prefetch-Control: on
.addMiddleware(xDownloadOptions(allow: true))
```

You can install this module separately as `xDnsPrefetchControl`.

</details>

<details>
<summary><code>xDownloadOptions</code></summary>

Default:

```http
X-Download-Options: noopen
```

This middleware sets the `X-Download-Options` header to `noopen`
to prevent Internet Explorer users from executing downloads
in your site's context.

```dart
import 'package:shelf_helmet/shelf_helmet.dart'

.addMiddleware(xDownloadOptions())
```

Some web applications will serve untrusted HTML for download.
By default, some versions of IE will allow you to open
those HTML files _in the context of your site_,
which means that an untrusted HTML page could start
doing bad things in the context of your pages.
For more, see [this MSDN blog post](https://docs.microsoft.com/en-us/archive/blogs/ie/ie8-security-part-v-comprehensive-protection).

This is pretty obscure, fixing a small bug on IE only.
No real drawbacks other than performance/bandwidth
of setting the headers, though.

You can install this module separately as `xDownloadOptions`.

</details>

<details>
<summary><code>xFrameOptions(options)</code></summary>

Default:

```http
X-Frame-Options: SAMEORIGIN
```

The `X-Frame-Options` HTTP header restricts who can put your site in a frame which can help mitigate things like [clickjacking attacks](https://en.wikipedia.org/wiki/Clickjacking). The header has two modes: `DENY` and `SAMEORIGIN`.

This header is superseded by [the `frame-ancestors` Content Security Policy directive](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-ancestors) but is still useful on old browsers.

If your app does not need to be framed (and most don't) you can use `DENY`. If your site can be in frames from the same origin, you can set it to `SAMEORIGIN`.

Usage:

```dart
import 'package:shelf_helmet/shelf_helmet.dart'

// Sets X-Frame-Options: sameorigin
.addMiddleware(xPermittedCrossDomainPolies());

// You can use any of the following values:
.addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.deny));
.addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.sameorigin));
```

</details>

<details>
<summary><code>xPermittedCrossDomainPolicies(options)</code></summary>

Default:

```http
X-Permitted-Cross-Domain-Policies: none
```

The `X-Permitted-Cross-Domain-Policies` header tells some web clients
(like Adobe Flash or Adobe Acrobat) your domain's policy for loading
cross-domain content. See the description on
[OWASP](https://owasp.org/www-project-secure-headers/) for more.

Usage:

```dart
import 'package:shelf_helmet/shelf_helmet.dart'

// Sets X-Permitted-Cross-Domain-Policies: none
.addMiddleware(xPermittedCrossDomainPolies());

// You can use any of the following values:
.addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.none));
.addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.masterOnly));
.addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.byContentType));
.addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.all));
```

The `by-ftp-type` is not currently supported. Please open an issue or pull request if you desire this feature!

If you don't expect Adobe products to load data from your site, you get a minor security benefit by adding this header.

You can install this module separately as `xPermittedCrossDomainPolicies`.

</details>

<details>
<summary><code>xPoweredBy</code></summary>

Simple instructions to remove the `X-Powered-By` HTTP header.
Technically a middleware is the way of how to remove the header.

## Remove the Header in `shelf`

But in Shelf you can change this header only on the server top-level of shelf.
so if you want to get rid of this header you need to do:

```dart
final server = await shelf_io.serve(handler, 'localhost', 8080, poweredByHeader: null);
```

## Remove the Header in `dart_frog`

You can find a tutorial of how to remove in the official [`dart_frog` documentation](https://dartfrog.vgv.dev/docs/advanced/powered_by_header#removing-the-x-powered-by-header).

Hackers can exploit known vulnerabilities in Shelf/Dart if they see that your site is powered by Shelf (or whichever framework you use). For example, `X-Powered-By: Dart with package:shelf` is sent in every HTTP request coming from Shelf and DartFrog, by default. This won't provide much security benefit ([as discussed here](https://github.com/expressjs/express/pull/2813#issuecomment-159270428)), but might help a tiny bit. It will also improve performance by reducing the number of bytes sent.


</details>

<details>
<summary><code>xXssProtection</code></summary>

Default:

```http
X-XSS-Protection: 0
```

`helmet.xssFilter` disables browsers' buggy cross-site scripting filter by setting the `X-XSS-Protection` header to `0`. See [discussion about disabling the header here](https://github.com/helmetjs/helmet/issues/230) and [documentation on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection).

This middleware takes no options.

Examples:

```dart
import 'package:shelf_helmet/shelf_helmet.dart'

.addMiddleware(xXssProtection())
```

You can install this module separately as `xXssProtection`.

</details>
