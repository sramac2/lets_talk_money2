import 'package:flutter/material.dart';
import 'package:lets_talk_money2/Views/HomePage.dart';
import 'package:lets_talk_money2/Views/Profile.dart';
import 'package:lets_talk_money2/Views/RegistrationPage.dart';

class BottomDrawerPage extends StatefulWidget {
  const BottomDrawerPage({Key key}) : super(key: key);

  @override
  _BottomDrawerPageState createState() => _BottomDrawerPageState();
}

class _BottomDrawerPageState extends State<BottomDrawerPage> {
  static List<Widget> _widgetOptions = <Widget>[HomePage(), ProfilePage()];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.cyan,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          iconSize: 30.0,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.message,
                ),
                label: 'Chats'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1 && currentUser.isAnonymous) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegistrationDemo()));
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }
}
