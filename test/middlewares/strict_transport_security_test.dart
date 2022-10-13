import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test(
      "Should add the 'Strict-Transport-Security:max-age=15552000; includeSubDomains' Header",
      () async {
    final handler =
        const Pipeline().addMiddleware(strictTransportSecurity()).addHandler(
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
        'strict-transport-security',
        'max-age=15552000; includeSubDomains',
      ),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test(
      "Should add the 'Strict-Transport-Security:max-age=31536000; includeSubDomains' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          strictTransportSecurity(
            options: const StrictTransportSecurityOptions(
              maxAge: Duration(
                days: 365,
              ),
            ),
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
      containsPair(
        'strict-transport-security',
        'max-age=31536000; includeSubDomains',
      ),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Strict-Transport-Security:max-age=15552000' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          strictTransportSecurity(
            options: const StrictTransportSecurityOptions(
              includeSubDomains: false,
            ),
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
      containsPair('strict-transport-security', 'max-age=15552000'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
  test(
      "Should add the 'Strict-Transport-Security:max-age=15552000; includeSubDomains; preload' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          strictTransportSecurity(
            options: const StrictTransportSecurityOptions(preload: true),
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
      containsPair(
        'strict-transport-security',
        'max-age=15552000; includeSubDomains; preload',
      ),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
