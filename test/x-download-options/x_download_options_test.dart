import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test("Should add the 'X-DownloadOptions:noopen' Header", () async {
    final handler = const Pipeline().addMiddleware(xDownloadOptions()).addHandler(
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
    expect(response.headers, containsPair('x-download-options', 'noopen'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
