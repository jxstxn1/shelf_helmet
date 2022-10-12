import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  test('ReferrerPolicyToken Enum should have correct values', () {
    expect(ReferrerPolicyToken.noReferrer.token, 'no-referrer');
    expect(
      ReferrerPolicyToken.noReferrerWhenDowngrade.token,
      'no-referrer-when-downgrade',
    );
    expect(ReferrerPolicyToken.sameOrigin.token, 'same-origin');
    expect(ReferrerPolicyToken.origin.token, 'origin');
    expect(ReferrerPolicyToken.strictOrigin.token, 'strict-origin');
    expect(
      ReferrerPolicyToken.originWhenCrossOrigin.token,
      'origin-when-cross-origin',
    );
    expect(
      ReferrerPolicyToken.strictOriginWhenCrossOrigin.token,
      'strict-origin-when-cross-origin',
    );
    expect(ReferrerPolicyToken.unsafeUrl.token, 'unsafe-url');
    expect(ReferrerPolicyToken.emptyString.token, '');
  });
  test("Should add the 'Referrer-Policy:no-referrer' Header", () async {
    final handler = const Pipeline().addMiddleware(referrerPolicy()).addHandler(
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
    expect(response.headers, containsPair('referrer-policy', 'no-referrer'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Referrer-Policy:no-referrer-when-downgrade' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          referrerPolicy(
            policies: [ReferrerPolicyToken.noReferrerWhenDowngrade],
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
      containsPair('referrer-policy', 'no-referrer-when-downgrade'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Referrer-Policy:same-origin' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(
          referrerPolicy(policies: [ReferrerPolicyToken.sameOrigin]),
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
    expect(response.headers, containsPair('referrer-policy', 'same-origin'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Referrer-Policy:origin' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(referrerPolicy(policies: [ReferrerPolicyToken.origin]))
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
    expect(response.headers, containsPair('referrer-policy', 'origin'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Referrer-Policy:strict-origin' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(
          referrerPolicy(policies: [ReferrerPolicyToken.strictOrigin]),
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
    expect(response.headers, containsPair('referrer-policy', 'strict-origin'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Referrer-Policy:origin-when-cross-origin' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          referrerPolicy(policies: [ReferrerPolicyToken.originWhenCrossOrigin]),
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
      containsPair('referrer-policy', 'origin-when-cross-origin'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test(
      "Should add the 'Referrer-Policy:strict-origin-when-cross-origin' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          referrerPolicy(
            policies: [ReferrerPolicyToken.strictOriginWhenCrossOrigin],
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
      containsPair('referrer-policy', 'strict-origin-when-cross-origin'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Referrer-Policy:unsafe-url' Header", () async {
    final handler = const Pipeline()
        .addMiddleware(
          referrerPolicy(policies: [ReferrerPolicyToken.unsafeUrl]),
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
    expect(response.headers, containsPair('referrer-policy', 'unsafe-url'));
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test("Should add the 'Referrer-Policy:no-referrer-when-downgrade' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          referrerPolicy(
            policies: [ReferrerPolicyToken.noReferrerWhenDowngrade],
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
      containsPair('referrer-policy', 'no-referrer-when-downgrade'),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });

  test(
      "Should add the 'Referrer-Policy:no-referrer-when-downgrade,same-origin' Header",
      () async {
    final handler = const Pipeline()
        .addMiddleware(
          referrerPolicy(
            policies: [
              ReferrerPolicyToken.noReferrerWhenDowngrade,
              ReferrerPolicyToken.sameOrigin,
            ],
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
        'referrer-policy',
        'no-referrer-when-downgrade,same-origin',
      ),
    );
    expect(response.headers, containsPair('content-type', 'application/json'));
  });
}
