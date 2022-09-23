import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  final handlerWithHeader = const Pipeline().addMiddleware(xPoweredBy()).addHandler(
        (req) => syncHandler(
          req,
          headers: {
            'X-Powered-By': 'Should be removed',
            'Content-Type': 'application/json',
          },
        ),
      );

  final handlerWithoutHeader = const Pipeline().addMiddleware(xPoweredBy()).addHandler(
        (req) => syncHandler(req, headers: {'Content-Type': 'application/json'}),
      );

  test("Should do nothing if the header wasn't set", () async {
    final response = await makeRequest(
      handlerWithoutHeader,
      uri: clientUri,
      method: 'GET',
    );

    expect(response.statusCode, 200);
    expect(response.headers['X-Powered-By'], null);
  });

  test("Should remove the header if it was set", () async {
    final response = await makeRequest(
      handlerWithHeader,
      uri: clientUri,
      method: 'GET',
    );

    expect(response.statusCode, 200);
    expect(response.headers['x-powered-by'], null);
  });
}
