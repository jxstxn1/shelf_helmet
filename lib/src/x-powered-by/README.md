# X-Powered-By middleware

Simple instructions to remove the `X-Powered-By` HTTP header.
Technically a middleware is the way of how to remove the header.
But in Shelf you can change this header only on the server top-level of shelf.
so if you want to get rid of this header you need to do:

```dart
final server = await shelf_io.serve(handler, 'localhost', 8080, poweredByHeader: null);
```

Hackers can exploit known vulnerabilities in Shelf/Dart if they see that your site is powered by Shelf (or whichever framework you use). For example, `X-Powered-By: Dart with package:shelf` is sent in every HTTP request coming from Shelf and DartFrog, by default. This won't provide much security benefit ([as discussed here](https://github.com/expressjs/express/pull/2813#issuecomment-159270428)), but might help a tiny bit. It will also improve performance by reducing the number of bytes sent.
