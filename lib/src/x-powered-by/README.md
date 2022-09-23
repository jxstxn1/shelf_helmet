# X-Powered-By middleware

Simple middleware to remove the `X-Powered-By` HTTP header if it's set.

Hackers can exploit known vulnerabilities in Express/Node if they see that your site is powered by Express (or whichever framework you use). For example, `X-Powered-By: Express` is sent in every HTTP request coming from Express, by default. This won't provide much security benefit ([as discussed here](https://github.com/expressjs/express/pull/2813#issuecomment-159270428)), but might help a tiny bit. It will also improve performance by reducing the number of bytes sent.

```dart
import 'package:shelf_helmet/x_xss_protection.dart'

var handler =
  const Pipeline().addMiddleware(xPoweredBy()).addMiddleware(logRequests()).addHandler(_echoRequest);
```
