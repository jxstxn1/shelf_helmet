import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test("Should add the 'X-DNS-Prefetch-Control:off' Header", () async {
    final handler =
        const Pipeline().addMiddleware(xDnsPrefetchControl()).addHandler(
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
    expect(response.headers, containsPair('x-dns-prefetch-control', 'off'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'X-DNS-Prefetch-Control:on' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(xDnsPrefetchControl(allow: true))
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
    expect(response.headers, containsPair('x-dns-prefetch-control', 'on'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
