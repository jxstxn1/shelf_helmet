import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test('CrossOriginOpenerPolicyOptions Enum should have correct values', () {
    expect(CrossOriginOpenerPolicyOptions.sameOrigin.option, 'same-origin');
    expect(
      CrossOriginOpenerPolicyOptions.sameOriginAllowPopUps.option,
      'same-origin-allow-popups',
    );
    expect(CrossOriginOpenerPolicyOptions.unsafeNone.option, 'unsafe-none');
  });
  test("Should add the 'Cross-Origin-Opener-Policy:same-origin' Header",
      () async {
    final handler =
        const Pipeline().addMiddleware(crossOriginOpenerPolicy()).addHandler(
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
      containsPair('cross-origin-opener-policy', 'same-origin'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
  test("Should add the 'Cross-Origin-Opener-Policy:cross-origin' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          crossOriginOpenerPolicy(
            policy: CrossOriginOpenerPolicyOptions.sameOriginAllowPopUps,
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
      containsPair('cross-origin-opener-policy', 'same-origin-allow-popups'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
  test("Should add the 'Cross-Origin-Opener-Policy:unsafe-none' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          crossOriginOpenerPolicy(
            policy: CrossOriginOpenerPolicyOptions.unsafeNone,
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
      containsPair('cross-origin-opener-policy', 'unsafe-none'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
