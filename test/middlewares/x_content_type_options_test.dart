import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/src/middlewares/x_content_type_options.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test("Should add the 'X-Content-Type-Options:nosniff' Header", () async {
    final handler =
        const Pipeline().addMiddleware(xContentTypeOptions()).addHandler(
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
    expect(response.headers, containsPair('x-content-type-options', 'nosniff'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
