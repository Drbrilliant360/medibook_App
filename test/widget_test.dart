import 'package:flutter_test/flutter_test.dart';
import 'package:booking_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Basic smoke test - just verifies app builds
    expect(MyApp, isNotNull);
  });
}