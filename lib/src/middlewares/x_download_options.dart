import 'package:shelf/shelf.dart';

/// This middleware sets the `X-Download-Options` header to `noopen`
/// to prevent Internet Explorer users from executing downloads
/// in your site's context.
///
/// ```dart
/// import 'package:shelf_helmet/shelf_helmet.dart'
///
/// .addMiddleware(xDownloadOptions())
/// ```
///
/// Some web applications will serve untrusted HTML for download.
/// By default, some versions of IE will allow you to open
/// those HTML files _in the context of your site_,
/// which means that an untrusted HTML page could start
/// doing bad things in the context of your pages.
/// For more, see [this MSDN blog post](https://docs.microsoft.com/en-us/archive/blogs/ie/ie8-security-part-v-comprehensive-protection).
///
/// This is pretty obscure, fixing a small bug on IE only.
/// No real drawbacks other than performance/bandwidth
/// of setting the headers, though.
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
