import 'package:shelf/shelf.dart';

/// This middleware sets the `X-Download-Options` header to `noopen`.
Middleware xDownloadOptions() {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'x-download-options': 'noopen', ...response.headersAll},
      );
    };
  };
}
