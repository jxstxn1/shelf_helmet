import 'package:shelf/shelf.dart';
import 'package:shelf_helmet/shelf_helmet.dart';
import 'package:test/test.dart';

import '../utils/test_utils.dart';

void main() {
  group('Extension Tests: ', () {
    group('Dashify: ', () {
      test('should dashify a string', () {
        expect('helloWorld'.dashify(), 'hello-world');
      });

      test('should dashify a string with multiple uppercase letters', () {
        expect('helloWorldAndMore'.dashify(), 'hello-world-and-more');
      });

      test('should do nothing if the string is already dashified', () {
        expect('hello-world'.dashify(), 'hello-world');
      });
    });

    group('isDirectiveValueInvalid: ', () {
      test('should return true if the string contains a semicolon', () {
        expect('hello;world'.isDirectiveValueInvalid(), true);
      });

      test('should return true if the string contains a comma', () {
        expect('hello,world'.isDirectiveValueInvalid(), true);
      });

      test(
          'should return false if the string contains neither a semicolon nor a comma',
          () {
        expect('hello world'.isDirectiveValueInvalid(), false);
      });
    });

    group('isDirectiveNameInvalid: ', () {
      test(
          'should return false if the string contains only alphanumeric characters',
          () {
        expect('hello-world'.isDirectiveNameInvalid(), false);
      });

      test('should return true if the string contains special characters', () {
        expect('helloWorld '.isDirectiveNameInvalid(), true);
      });
    });
  });

  group('ContentSecurityPolicyOptions: ', () {
    test(
        'Should create a ContentSecurityPolicyOptions Object by using the .useDefaults constructor',
        () {
      // ignore: prefer_const_constructors
      final options = ContentSecurityPolicyOptions.useDefaults();
      expect(options.useDefaults, true);
      expect(options.reportOnly, false);
      expect(options.directives, {});
      expect(options.dangerouslyDisableDefaultSrc, false);
    });
    test(
        'Should create a ContentSecurityPolicyOptions Object by using the .useDefaults constructor',
        () {
      // ignore: prefer_const_constructors
      final options = ContentSecurityPolicyOptions
          .dangerouslyDisableDefaultSrc(); // ignore: prefer_const_constructors
      expect(options.useDefaults, true);
      expect(options.reportOnly, false);
      expect(options.directives, {});
      expect(options.dangerouslyDisableDefaultSrc, true);
    });
  });
  group('Middleware Test: ', () {
    test(
      "Should add the 'Content-Security-Policy' Header with default params",
      () async {
        final handler =
            const Pipeline().addMiddleware(contentSecurityPolicy()).addHandler(
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
            'content-security-policy',
            "default-src 'self';base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests",
          ),
        );
      },
    );
    test(
      "Should add the 'Content-Security-Policy-Report-Only' Header with default params",
      () async {
        final handler = const Pipeline()
            .addMiddleware(
              contentSecurityPolicy(
                options: const ContentSecurityPolicyOptions.useDefaults(
                  reportOnly: true,
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
            'content-security-policy-report-only',
            "default-src 'self';base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests",
          ),
        );
      },
    );
  });
  test(
    "Should add the 'Content-Security-Policy-Report-Only' Header with dangerously Disable DefaultSrc",
    () async {
      final handler = const Pipeline()
          .addMiddleware(
            contentSecurityPolicy(
              options: const ContentSecurityPolicyOptions
                  .dangerouslyDisableDefaultSrc(),
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
          'content-security-policy',
          "base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';style-src 'self' https: 'unsafe-inline';upgrade-insecure-requests",
        ),
      );
    },
  );
  //! TODO:
  test(
    "Should add ''style-src':[]' Header with dangerously Disable DefaultSrc",
    () async {
      final handler = const Pipeline()
          .addMiddleware(
            contentSecurityPolicy(
              options: const ContentSecurityPolicyOptions.useDefaults(
                directives: {'style-src': null},
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
          'content-security-policy',
          "default-src 'self';base-uri 'self';font-src 'self' https: data:;form-action 'self';frame-ancestors 'self';img-src 'self' data:;object-src 'none';script-src 'self';script-src-attr 'none';upgrade-insecure-requests",
        ),
      );
    },
  );
  test(
    "Should throw: 'Content-Security-Policy has no directives. Either set some or disable the header' if no directives are provided",
    () async {
      expectLater(
        () async {
          final handler = const Pipeline()
              .addMiddleware(
                contentSecurityPolicy(
                  options: const ContentSecurityPolicyOptions
                      .dangerouslyDisableDefaultSrc(useDefaults: false),
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
            'Content-Security-Policy has no directives. Either set some or disable the header',
          ),
        ),
      );
    },
  );
  test(
    "Should throw: 'Content-Security-Policy received an invalid directive value for default-src: hello;,' throw if a , or a ; is added",
    () async {
      expectLater(
        () async {
          final handler = const Pipeline()
              .addMiddleware(
                contentSecurityPolicy(
                  options: const ContentSecurityPolicyOptions
                      .dangerouslyDisableDefaultSrc(
                    useDefaults: false,
                    directives: {
                      'default-src': ["'hello;,'"],
                    },
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
            "Content-Security-Policy received an invalid directive value for default-src: 'hello;,'",
          ),
        ),
      );
    },
  );
  test(
    "Should throw: 'Content-Security-Policy needs a default-src but it was set to `null`. If you really want to disable it, set it to `ContentSecurityPolicyOptions.dangerouslyDisableDefaultSrc`.' throw if default src was set to null",
    () async {
      expectLater(
        () async {
          final handler = const Pipeline()
              .addMiddleware(
                contentSecurityPolicy(
                  options: const ContentSecurityPolicyOptions
                      .dangerouslyDisableDefaultSrc(
                    useDefaults: false,
                    directives: {'default-src': null},
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
            'Content-Security-Policy needs a default-src but it was set to `null`. If you really want to disable it, set it to `ContentSecurityPolicyOptions.dangerouslyDisableDefaultSrc`.',
          ),
        ),
      );
    },
  );
  test(
    "Should throw: 'Content-Security-Policy needs a default-src but none was provided. If you really want to disable it, set it to `contentSecurityPolicy.dangerouslyDisableDefaultSrc`. throw if no default-src was provided without setting dangerouslyDisableDefaultSrc to true",
    () async {
      expectLater(
        () async {
          final handler = const Pipeline()
              .addMiddleware(
                contentSecurityPolicy(
                  options: const ContentSecurityPolicyOptions(
                    useDefaults: false,
                    reportOnly: false,
                    dangerouslyDisableDefaultSrc: false,
                    directives: {
                      'base-uri': ["'self'"],
                    },
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
            'Content-Security-Policy needs a default-src but none was provided. If you really want to disable it, set it to `contentSecurityPolicy.dangerouslyDisableDefaultSrc`.',
          ),
        ),
      );
    },
  );
  test(
    "Should throw: 'Content-Security-Policy received two directives with the same name: 'base-uri'' if a directive is set twice",
    () async {
      expectLater(
        () async {
          final handler = const Pipeline()
              .addMiddleware(
                contentSecurityPolicy(
                  options: const ContentSecurityPolicyOptions(
                    useDefaults: false,
                    reportOnly: false,
                    dangerouslyDisableDefaultSrc: false,
                    directives: {
                      'base-uri': ["'self'"],
                      'baseUri': ["'self'"],
                    },
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
            'Content-Security-Policy received two directives with the same name: base-uri',
          ),
        ),
      );
    },
  );
  test(
    "Should throw: 'Content-Security-Policy received an invalid directive name: base-uri '",
    () async {
      expectLater(
        () async {
          final handler = const Pipeline()
              .addMiddleware(
                contentSecurityPolicy(
                  options: const ContentSecurityPolicyOptions(
                    useDefaults: false,
                    reportOnly: false,
                    dangerouslyDisableDefaultSrc: false,
                    directives: {
                      'base-uri ': ["'self'"],
                    },
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
            'Content-Security-Policy received an invalid directive name: base-uri ',
          ),
        ),
      );
    },
  );
}
