# X-DNS-Prefetch-Control middleware

This middleware lets you set the `X-DNS-Prefetch-Control` to control browsers' DNS prefetching. Read more about it [on MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Controlling_DNS_prefetching) and [on Chromium's docs](https://dev.chromium.org/developers/design-documents/dns-prefetching).

Usage:

```dart
import 'package:shelf_helmet/shelf_helmet.dart'

// Set X-DNS-Prefetch-Control: off
.addMiddleware(xDownloadOptions())

// Set X-DNS-Prefetch-Control: on
.addMiddleware(xDownloadOptions(allow: true))
```
