import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test("Should add the 'X-XSS-Protection' Header", () async {
    final handler = const Pipeline().addMiddleware(xXssProtection()).addHandler(
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
    expect(response.headers, containsPair('x-xss-protection', '0'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
