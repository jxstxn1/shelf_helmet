import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/src/middlewares/cross_origin_embedder_policy.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test('CrossOriginEmbedderPolicyOptions Enum should have correct values', () {
    expect(CrossOriginEmbedderPolicyOptions.requireCorp.option, 'require-corp');
    expect(
      CrossOriginEmbedderPolicyOptions.credentialLess.option,
      'credentialless',
    );
  });
  test(
    "Should add the 'Cross-Origin-Embedder-Policy:require-corp' Header",
    () async => testCrossOriginEmbedderPolicy(
      CrossOriginEmbedderPolicyOptions.requireCorp,
    ),
  );
  test(
    "Should add the 'Cross-Origin-Embedder-Policy:credetialless' Header",
    () async => testCrossOriginEmbedderPolicy(
      CrossOriginEmbedderPolicyOptions.credentialLess,
    ),
  );

  test(
    "Should add the 'Cross-Origin-Embedder-Policy:unsafe-none' Header",
    () async => testCrossOriginEmbedderPolicy(
      CrossOriginEmbedderPolicyOptions.unsafeNone,
    ),
  );
}

Future<void> testCrossOriginEmbedderPolicy(
  CrossOriginEmbedderPolicyOptions policy,
) async {
  final handler = const Pipeline()
      .addMiddleware(
        crossOriginEmbedderPolicy(
          policy: policy,
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
    containsPair('cross-origin-embedder-policy', policy.option),
  );
  expect(response.headers, containsPair('content-type', 'application/json'));
}
