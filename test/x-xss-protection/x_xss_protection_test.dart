import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  final handler = const Pipeline().addMiddleware(xXssProtection()).addHandler(
        (req) => syncHandler(
          req,
          headers: {'Content-Type': 'application/json'},
        ),
      );

  test("Should add the 'X-XSS-Protection' Header", () async {
    final response = await makeRequest(
      handler,
      uri: clientUri,
      method: 'GET',
    );

    expect(response.statusCode, 200);
    expect(response.headers, containsPair('X-XSS-Protection', '0'));
    expect(response.headers, containsPair('Content-Type', 'application/json'));
  });
}
