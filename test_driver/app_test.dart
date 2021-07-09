import 'package:test/test.dart' as test;
import 'package:flutter_driver/flutter_driver.dart';

void main() {
  test.group('Login Page App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    
    final titleFinder = find.byValueKey('title');
    final buttonFinder = find.byValueKey('login');
    final noAccFinder = find.byValueKey('noaccount');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    test.setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    test.tearDownAll(() async {
      driver.close();
    });

    test.test('Login Page title is shown', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      test.expect(await driver.getText(titleFinder), "Login Page");
    });

    test.test('Login button is present', () async {
      // First, tap the button.
      //await driver.tap(buttonFinder);

      // Then, verify the counter text is incremented by 1.
     test.expect(await driver.getText(buttonFinder), "Login");
    });
  });
}