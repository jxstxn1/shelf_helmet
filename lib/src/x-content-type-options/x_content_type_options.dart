import 'package:shelf/shelf.dart';

/// This middleware sets the `X-Download-Options` header to `noopen`.
Middleware xContentTypeOptions() {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'x-content-type-options': 'nosniff', ...response.headersAll},
      );
    };
  };
}
