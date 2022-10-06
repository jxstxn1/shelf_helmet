import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test("Should add the 'Cross-Origin-Resource-Policy:same-origin' Header", () async {
    final handler = const Pipeline().addMiddleware(crossOriginResourcePolicy()).addHandler(
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
    expect(response.headers, containsPair('cross-origin-resource-policy', 'same-origin'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
  test("Should add the 'Cross-Origin-Resource-Policy:cross-origin' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(
          crossOriginResourcePolicy(
            policy: CrossOriginResourcePolicyOptions.crossOrigin,
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
    expect(response.headers, containsPair('cross-origin-resource-policy', 'cross-origin'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
  test("Should add the 'Cross-Origin-Resource-Policy:same-site' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(
          crossOriginResourcePolicy(
            policy: CrossOriginResourcePolicyOptions.sameSite,
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
    expect(response.headers, containsPair('cross-origin-resource-policy', 'same-site'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
