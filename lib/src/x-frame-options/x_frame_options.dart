import 'package:shelf/shelf.dart';

enum XFrameOptions {
  deny('deny'),
  sameorigin('sameorigin');

  final String option;
  const XFrameOptions(this.option);
}

/// The `X-Frame-Options` HTTP header restricts who
/// can put your site in a frame which can help
/// mitigate things like [clickjacking attacks]
/// (https://en.wikipedia.org/wiki/Clickjacking).
/// The header has two modes: `DENY` and `SAMEORIGIN`
/// which can be set using the [xFrameOptions] parameter.
Middleware xFrameOptions({XFrameOptions xFrameOption = XFrameOptions.sameorigin}) {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {'x-frame-options': xFrameOption.option, ...response.headersAll},
      );
    };
  };
}
