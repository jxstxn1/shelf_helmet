# Example

## Quick start

First, run `dart pub add shelf_helmet` for your app. Then:

### As shelf middleware

```dart
import 'package:shelf_helmet/shelf_helmet.dart';

var handler = const Pipeline()
    .addMiddleware(helmet())
    .addMiddleware(logRequests())
    .addHandler(_echoRequest);
```

### As dart_frog middleware

```dart
import 'package:shelf_helmet/shelf_helmet.dart';

Handler middleware(Handler handler) {
  return handler.use(
    fromShelfMiddleware(helmet()),
  );
}
```

### As pharaoh middleware

```dart
import 'package:shelf_helmet/shelf_helmet.dart';

app.use(useShelfMiddleware(helmet()));
```

You can find more specific examples in the readme.
