import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lets_talk_money2/Controllers/AuthAPI.dart';
import 'package:lets_talk_money2/Helpers/Adhelper.dart';
import 'package:lets_talk_money2/Views/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'RegistrationPage.dart';

class LoginDemo extends StatelessWidget {
  const LoginDemo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login Page', key: const Key('title')),
        ),
        body: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  BannerAd _bannerAd;

  bool _isBannerAdReady = false;
  AuthAPI api = AuthAPI();
  TextEditingController emailController;
  TextEditingController pwdController;
  StreamController<String> emailStreamController;
  StreamController<String> pwdStreamController;
  SnackBar snackBar;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    emailController = TextEditingController();
    pwdController = TextEditingController();
    emailController.text = 'testing@gmail.com';
    pwdController.text = 'testing';
    emailStreamController = StreamController<String>.broadcast();
    pwdStreamController = StreamController<String>.broadcast();
    _initGoogleMobileAds();

    BuildContext currentCtx;
    snackBar = SnackBar(content: Text('Test'));
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error Initializing Firebase'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Column(
              children: [
                Text(
                  'Login Page',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: TextFormField(
                    controller: pwdController,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                ),
                MaterialButton(
                  key: const Key('loginbutton'),
                  onPressed: () {
                    login();
                  },
                  child: Text("Login",
                      style: TextStyle(color: Colors.white),
                      key: const Key('login')),
                  color: Colors.black,
                ),
                MaterialButton(
                  key: const Key('noaccount'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationDemo()));
                  },
                  child: Text("Don't have an account?"),
                ),
                MaterialButton(
                  onPressed: () async {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInAnonymously();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: Text('Sign in Anonymously'),
                ),
                if (_isBannerAdReady)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: _bannerAd.size.width.toDouble(),
                      height: _bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd),
                    ),
                  ),
              ],
            )),
          );
        });
  }

  Future<void> login() async {
    String email = emailController.text.trim();
    String pwd = pwdController.text.trim();
    if (email.isEmpty || pwd.isEmpty) {
      snackBar = SnackBar(content: Text('All fields need to be filled!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    String response = await api.loginUserEmailPass(email, pwd);
    if (response != null) {
      snackBar = SnackBar(content: Text(response));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
