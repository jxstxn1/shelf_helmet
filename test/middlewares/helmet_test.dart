import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
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
    defaultHelmetOptionsExpecter(response);
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
  test('CrossOriginEmbedderPolicy can be activated with the options', () async {
    final handler = const Pipeline()
        .addMiddleware(
          helmet(
            options: const HelmetOptions(enableCrossOriginEmbedderPolicy: true),
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
    expect(response.headers['content-type'], 'application/json');
    defaultHelmetOptionsExpecter(response);
    expect(response.headers['cross-origin-embedder-policy'], 'require-corp');
  });
}
