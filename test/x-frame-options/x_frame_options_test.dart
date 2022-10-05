import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test("Should add the 'X-Permitted-Cross-Domain-Policies:none' Header", () async {
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
    expect(response.headers, containsPair('x-frame-options', 'sameorigin'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'X-Frame-Options:deny' Header", () async {
    final handler = const Pipeline().addMiddleware(xFrameOptions(xFrameOption: XFrameOptions.deny)).addHandler(
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
    expect(response.headers, containsPair('x-frame-options', 'deny'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
