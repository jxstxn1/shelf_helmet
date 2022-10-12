import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test("Should add the 'Expect-CT:max-age=0' Header", () async {
    final handler = const Pipeline().addMiddleware(expectCt()).addHandler(
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
    expect(response.headers, containsPair('expect-ct', 'max-age=0'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Expect-CT:max-age=31536000' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(expectCt(maxAge: const Duration(days: 365)))
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
    expect(response.headers, containsPair('expect-ct', 'max-age=31536000'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Expect-CT:max-age=15552000, enforce' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(
          expectCt(maxAge: const Duration(days: 180), enforce: true),
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
      containsPair('expect-ct', 'max-age=15552000, enforce'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
  test(
      '''Should add the 'Expect-CT:max-age=0, report-uri="http://localhost:3000/test"' Header''',
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          expectCt(reportUri: Uri.parse('http://localhost:3000/test')),
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
        'expect-ct',
        'max-age=0, report-uri="http://localhost:3000/test"',
      ),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
