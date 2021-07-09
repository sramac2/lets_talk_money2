import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_talk_money2/Models/User.dart' as models;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

TextEditingController fNameController = TextEditingController();
TextEditingController lNameController = TextEditingController();
CollectionReference users = FirebaseFirestore.instance.collection('users');
var currentUser = FirebaseAuth.instance.currentUser;

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(currentUser.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Text("Data does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data.data() as Map<String, dynamic>;
            lNameController.text = data['lastName'];
            fNameController.text = data['firstName'];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 200,
                    child: TextField(
                      controller: fNameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter First Name'),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Last Name'),
                      controller: lNameController,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      String a = await updateUserInfo(models.User(
                          datetime: DateTime.now().toString(),
                          firstName: fNameController.text.trim(),
                          lastName: lNameController.text.trim(),uid: currentUser.uid,role: data['role']));
                      if (a.isNotEmpty) {
                        print("User values not changed");
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content: Text(a),
                                actions: [
                                  ElevatedButton(
                                    child: Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Success!"),
                                content: Text('Profile Updated'),
                                actions: [
                                  ElevatedButton(
                                    child: Text("Ok"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            });
                      }
                    },
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                    color: Colors.indigo,
                  )
                ],
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(
            semanticsLabel: 'Loading...',
          ));
        });
  }

  Future<String> updateUserInfo(models.User user) async {
    return await users
        .doc(currentUser.uid)
        .set(user.toJson())
        .then((value) => '')
        .onError((error, stackTrace) => error.toString());
  }
}
