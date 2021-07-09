import 'package:flutter_test/flutter_test.dart';
import 'package:lets_talk_money2/Models/Friend.dart';

void main() {
  group('Friend', () {
    test('First name value is set', () {
      final friend = Friend();
      friend.firstName = "santhosh";

      expect(friend.firstName, "santhosh");
    });
    test('Last name value is set', () {
      final friend = Friend();
      friend.lastName = "ram";

      expect(friend.lastName, "ram");
    });
    test('uid value is set', () {
      final friend = Friend();
      friend.uid = "1234567";

      expect(friend.uid, "1234567");
    });
  });
}
