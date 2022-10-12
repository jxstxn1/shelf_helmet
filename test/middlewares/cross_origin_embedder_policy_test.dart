import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test("Should add the 'Cross-Origin-Embedder-Policy:require-corp' Header",
      () async {
    final handler =
        const Pipeline().addMiddleware(crossOriginEmbedderPolicy()).addHandler(
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
    expect(
      response.headers,
      containsPair(
        'cross-origin-embedder-policy',
        'require-corp',
      ),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
  test("Should add the 'Cross-Origin-Embedder-Policy:credetialless' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          crossOriginEmbedderPolicy(
            policy: CrossOriginEmbedderPolicyOptions.credentialLess,
          ),
        )
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
    expect(
      response.headers,
      containsPair('cross-origin-embedder-policy', 'credentialless'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
