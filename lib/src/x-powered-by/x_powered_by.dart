import 'package:shelf/shelf.dart';

Middleware xPoweredBy() {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      final headers = {...response.headersAll}..update(
          'X-Powered-By',
          (_) => [],
          ifAbsent: () => [],
        );
      return response.change(
        headers: {
          ...headers,
        },
      );
    };
  };
}
