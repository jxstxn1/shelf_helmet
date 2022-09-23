import 'package:shelf/shelf.dart';

Middleware xXssProtection() {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'x-xxs-protection': '0', ...response.headersAll},
      );
    };
  };
}
