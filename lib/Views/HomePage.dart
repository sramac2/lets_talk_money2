import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lets_talk_money2/Controllers/ChatAPI.dart';
import 'package:lets_talk_money2/Helpers/Adhelper.dart';
import 'package:lets_talk_money2/Models/Friend.dart';
import 'package:lets_talk_money2/Views/ChatPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  Future<List<Friend>> friendsList;
  ChatAPI chatAPI = ChatAPI();
  RewardedAd _rewardedAd;

  // TODO: Add _isRewardedAdReady
  bool _isRewardedAdReady = false;

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          this._rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                _isRewardedAdReady = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
          setState(() {
            _isRewardedAdReady = false;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    var currUser = FirebaseAuth.instance.currentUser;
    friendsList = chatAPI.getAllFriends(currUser.uid);
    _loadInterstitialAd();
    _loadRewardedAd();
    super.initState();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _moveToHome();
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void _moveToHome() {
    // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(

          title: Text('Friends',key: const Key('friends')),
          actions: [
            IconButton(
              icon: Icon(Icons.gif_outlined),
              onPressed: () {
                if (_isInterstitialAdReady) {
                  _interstitialAd?.show();
                }
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Text('Reward'),
          onPressed: () {
            _rewardedAd.show();
          },
        ),
        body: FutureBuilder<List<Friend>>(
            future: friendsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                      friend: snapshot.data[index],
                                    )));
                      },
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"),
                          ),
                          title: Text(
                              "${snapshot.data[index].firstName} ${snapshot.data[index].lastName}"),
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data.length,
                );
              }
              return CircularProgressIndicator(
                semanticsLabel: "Loading...",
              );
            }),
      ),
    );
  }
}
