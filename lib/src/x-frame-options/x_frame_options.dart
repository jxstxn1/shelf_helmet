import 'package:shelf/shelf.dart';

enum XFrameOptions {
  deny('deny'),
  sameorigin('sameorigin');

  final String option;
  const XFrameOptions(this.option);
}

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
