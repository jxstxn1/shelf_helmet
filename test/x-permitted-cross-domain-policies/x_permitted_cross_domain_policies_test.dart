import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test("Should add the 'X-Permitted-Cross-Domain-Policies:none' Header", () async {
    final handler = const Pipeline().addMiddleware(xPermittedCrossDomainPolies()).addHandler(
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
    expect(response.headers, containsPair('x-permitted-cross-domain-policies', 'none'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'X-Permitted-Cross-Domain-Policies:all' Header", () async {
    final handler =
        const Pipeline().addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.all)).addHandler(
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
    expect(response.headers, containsPair('x-permitted-cross-domain-policies', 'all'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'X-Permitted-Cross-Domain-Policies:by-content-type' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.byContentType))
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
    expect(response.headers, containsPair('x-permitted-cross-domain-policies', 'by-content-type'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'X-Permitted-Cross-Domain-Policies:master-only' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(xPermittedCrossDomainPolies(permittedPolicie: PermittedPolicies.masterOnly))
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
    expect(response.headers, containsPair('x-permitted-cross-domain-policies', 'master-only'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
