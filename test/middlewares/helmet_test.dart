import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/src/middlewares/helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test('Should pass with the default helmet settings', () async {
    final handler = const Pipeline().addMiddleware(helmet()).addHandler(
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
    expect(response.headers['content-type'], 'application/json');
    expect(
      response.headers['content-security-policy'],
      "default-src 'self';base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests",
    );
    expect(response.headers['cross-origin-embedder-policy'], 'require-corp');
    expect(response.headers['cross-origin-opener-policy'], 'same-origin');
    expect(response.headers['cross-origin-resource-policy'], 'same-origin');
    expect(response.headers['origin-agent-cluster'], '?1');
    expect(response.headers['referrer-policy'], 'no-referrer');
    expect(
      response.headers['strict-transport-security'],
      'max-age=15552000; includeSubDomains',
    );
    expect(response.headers['x-content-type-options'], 'nosniff');
    expect(response.headers['x-dns-prefetch-control'], 'off');
    expect(response.headers['x-download-options'], 'noopen');
    expect(response.headers['x-frame-options'], 'SAMEORIGIN');
    expect(response.headers['x-permitted-cross-domain-policies'], 'none');
    expect(response.headers['x-xss-protection'], '0');
  });

  test(
    "Should throw: 'No middlewares were provided, consider removing helmet()' if every middleware is set to false",
    () async {
      expectLater(
        () async {
          final handler = const Pipeline()
              .addMiddleware(
                helmet(
                  options: const HelmetOptions(
                    enableContentSecurityPolicy: false,
                    enableCrossOriginEmbedderPolicy: false,
                    enableCrossOriginOpenerPolicy: false,
                    enableCrossOriginResourcePolicy: false,
                    enableOriginAgentCluster: false,
                    enableReferrerPolicy: false,
                    enableStrictTransportSecurity: false,
                    enableXContentTypeOptions: false,
                    enableXDnsPrefetchControl: false,
                    enableXDownloadOptions: false,
                    enableXFrameOptions: false,
                    enableXPermittedCrossDomainPolicies: false,
                    enableXXssProtection: false,
                  ),
                ),
              )
              .addHandler(
                (req) => syncHandler(
                  req,
                  headers: {'content-type': 'application/json'},
                ),
              );
          await makeRequest(
            handler,
            uri: clientUri,
            method: 'GET',
          );
        },
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'No middlewares were provided, consider removing helmet()',
          ),
        ),
      );
    },
  );
}
