import 'package:shelf/shelf.dart';

Middleware xPoweredBy() {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      // We need to remove the header in the updated list...
      final headers = {...response.headersAll}..remove('X-Powered-By');
      return response.change(
        headers: {
          // ... and set it here to null, to actually remove it.
          'X-Powered-By': null,
          ...headers,
        },
      );
    };
  };
}
