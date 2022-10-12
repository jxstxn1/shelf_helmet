import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test('XFrameOptions Enum should have correct values', () {
    expect(XFrameOptions.deny.option, 'DENY');
    expect(XFrameOptions.sameorigin.option, 'SAMEORIGIN');
  });
  test("Should add the 'X-Frame-Options:SAMEORIGIN' Header", () async {
    final handler = const Pipeline().addMiddleware(xFrameOptions()).addHandler(
          (req) => syncHandler(
            req,
            headers: {'content-type': 'application/json'},
          ),
        );
    final response = await makeRequest(
      handler,
      uri: clientUri,
      method: 'GET',
    );

    expect(response.statusCode, 200);
    expect(response.headers, containsPair('x-frame-options', 'SAMEORIGIN'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'X-Frame-Options:DENY' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(xFrameOptions(xFrameOption: XFrameOptions.deny))
        .addHandler(
          (req) => syncHandler(
            req,
            headers: {'content-type': 'application/json'},
          ),
        );
    final response = await makeRequest(
      handler,
      uri: clientUri,
      method: 'GET',
    );

    expect(response.statusCode, 200);
    expect(response.headers, containsPair('x-frame-options', 'DENY'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
