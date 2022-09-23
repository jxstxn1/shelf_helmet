import 'package:shelf/shelf.dart';

Middleware xPoweredBy() {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      final headers = {...response.headersAll}..update(
          'x-powered-by',
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
