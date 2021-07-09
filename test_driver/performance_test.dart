import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Login App', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('verifies the login is succssful', () async {
      final friendPage = find.byValueKey('friends');
      final loginButton = find.byValueKey('loginbutton');
      //final itemFinder = find.byValueKey('item_50_text');

      // Record a performance profile as the app scrolls through
      // the list of items.
      final timeline = await driver.traceAction(() async {
        // await driver.scrollUntilVisible(
        //   listFinder,
        //   itemFinder,
        //   dyScroll: -300.0,
        // );
        await driver.tap(loginButton);

        await driver.waitFor(friendPage);

        expect(await driver.getText(friendPage), 'Friends');
      });

      // Convert the Timeline into a TimelineSummary that's easier to
      // read and understand.
      final summary = new TimelineSummary.summarize(timeline);

      // Then, save the summary to disk.
      await summary.writeSummaryToFile('Login_Summary', pretty: true);

      // Optionally, write the entire timeline to disk in a json format.
      // This file can be opened in the Chrome browser's tracing tools
      // found by navigating to chrome://tracing.
      await summary.writeTimelineToFile('login_timeline', pretty: true);
    });
  });
}
