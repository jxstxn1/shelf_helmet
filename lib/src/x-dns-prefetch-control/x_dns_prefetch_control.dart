import 'package:shelf/shelf.dart';

/// This middleware lets you set the `X-DNS-Prefetch-Control` to control browsers' DNS prefetching.
/// You can control it with the `allow` parameter.
Middleware xDNSPrefetchControl({bool allow = false}) {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'x-dns-prefetch-control': allow ? 'on' : 'off', ...response.headersAll},
      );
    };
  };
}
