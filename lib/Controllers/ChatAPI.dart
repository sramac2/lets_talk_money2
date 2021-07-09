import 'package:lets_talk_money2/Models/Friend.dart';
import 'package:lets_talk_money2/Models/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_talk_money2/Models/User.dart';

class ChatAPI {
  Future<List<Friend>> getAllFriends(String uid) async {
    List<Friend> result = [];
    var collection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends');
    var querySnapshot = await collection.get();
    for (var doc in querySnapshot.docs) {
      result.add(
        Friend.fromJson(
          doc.data(),
        ),
      );
    }
    return result;
  }

  Future<Friend> findFriend(String uid) async {
    var document = FirebaseFirestore.instance.collection('users').doc(uid);
    var a = await document
        .get()
        .then((value) => {Friend.fromJson(value.data())})
        .onError((error, stackTrace) => null);

    return a.first;
  }

  Future<String> createFriend(String uid, Friend friend) async {
    var document = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('friends')
        .doc(friend.uid);

    var response = await document
        .set(friend.toJson())
        .then((value) => null)
        .catchError((error) => error.toString());
    // document = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(friend.uid)
    //     .collection('friends')
    //     .doc(user.uid);
    
    //  response = await document
    //     .set(user.toJson())
    //     .then((value) => null)
    //     .catchError((error) => error.toString());

    return response;
  }

  Future<String> postMessage(
      String userId, String friendId, Message msg) async {
    msg.isMe = true;
    CollectionReference user = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .collection('messages');
    var response = await user
        .doc(msg.uid)
        .set(msg.toJson())
        .then((value) => null)
        .catchError((error) => error.toString());
    if (response != null) {
      return response.toString();
    }

    msg.isMe = false;
    user = FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(userId)
        .collection('messages');

    response = await user
        .doc(msg.uid)
        .set(msg.toJson())
        .then((value) => null)
        .catchError((error) => error.toString());

    if (response != null) {
      return response.toString();
    }
    return null;
  }
}
