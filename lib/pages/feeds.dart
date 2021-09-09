import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:social_media_app/chats/recent_chats.dart';
import 'package:social_media_app/components/fab_container.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/pages/generate.dart';
import 'package:social_media_app/pages/profile.dart';
import 'package:social_media_app/pages/qrscan.dart';
import 'package:social_media_app/pages/scanResult.dart';
import 'package:social_media_app/screens/note_screen.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:social_media_app/widgets/indicators.dart';
import 'package:social_media_app/widgets/userpost.dart';

import 'CreateDoc.dart';
import 'GeneratePage.dart';
import 'QrScanPage.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<DocumentSnapshot> post = [];

  bool isLoading = false;

  bool hasMore = true;

  int documentLimit = 10;

  DocumentSnapshot lastDocument;

  ScrollController _scrollController;

  getPosts() async {
    if (!hasMore) {
      print('No New Posts');
    }
    if (isLoading) {
      return CircularProgressIndicator();
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await postRef
          .orderBy('timestamp', descending: false)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await postRef
          .orderBy('timestamp', descending: false)
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .get();
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    if (querySnapshot.docs.length != 0) {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      post.addAll(querySnapshot.docs);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPosts();
    _scrollController?.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (maxScroll - currentScroll <= delta) {
        getPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton: _floatingActionButton(context),
      key: scaffoldKey,
      appBar: AppBar(
        // leading: Padding(
        //   padding:
        //       const EdgeInsets.only(left: 10.0, right: 0, bottom: 0, top: 0),
        //   child: Image(
        //       height: 50,
        //       width: 200,
        //       image: AssetImage('assets/images/logo.png')),
        // ),
        automaticallyImplyLeading: false,
        title: Padding(
          padding:
              const EdgeInsets.only(left: 0.0, right: 0, bottom: 0, top: 0),
          child: Image(
              height: 40,
              width: 180,
              image: AssetImage('assets/images/logo.png')),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(
          //     CupertinoIcons.qrcode,
          //     size: 30.0,
          //     color: Theme.of(context).accentColor,
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       CupertinoPageRoute(
          //         builder: (_) => ScanPage(),
          //       ),
          //     );
          //   },
          // ),
          SizedBox(width: 20.0),
          IconButton(
            icon: Icon(
              CupertinoIcons.chat_bubble_2_fill,
              size: 30.0,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => Chats(),
                ),
              );
            },
          ),

          // IconButton(
          //   icon: Icon(
          //     CupertinoIcons.gamecontroller_fill,
          //     size: 30.0,
          //     color: Theme.of(context).accentColor,
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       CupertinoPageRoute(
          //         builder: (_) => GeneratePage(),
          //       ),
          //     );
          //   },
          // ),
          // SizedBox(width: 20.0),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, right: 5.0, bottom: 5.0, left: 5.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => NotesScreen(),
                  ),
                );
              },
              child: Icon(
                CupertinoIcons.calendar_circle_fill,
                color: Theme.of(context).accentColor,
                size: 30.0,
              ),
            ),
          ),

          // StreamBuilder(
          //     stream: usersRef.doc(firebaseAuth.currentUser.uid).snapshots(),
          //     builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //       DocumentSnapshot doc = snapshot.data;
          //       return InkWell(
          //         onTap: () {
          //           Navigator.of(context).push(
          //             CupertinoPageRoute(
          //               builder: (_) => Profile(
          //                 profileId: firebaseAuth.currentUser.uid,
          //               ),
          //             ),
          //           );
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.only(
          //               top: 5.0, right: 5.0, bottom: 5.0, left: 5.0),
          //           child: CircleAvatar(
          //             backgroundImage: NetworkImage(doc['photoUrl']),
          //             radius: 25.0,
          //           ),
          //         ),
          //       );
          //     }),
        ],
      ),
      body: isLoading
          ? circularProgress(context)
          : ListView.builder(
              controller: _scrollController,
              itemCount: post.length,
              itemBuilder: (context, index) {
                internetChecker(context);
                PostModel posts = PostModel.fromJson(post[index].data());
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: UserPost(post: posts),
                );
              },
            ),
    );
  }

  _floatingActionButton(BuildContext context) {
    return Container(
      height: 50.0,
      width: 50.0,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () async {
            String codeSanner = await BarcodeScanner.scan(); //barcode scnner
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => ScanResult(scanResult: codeSanner),
              ),
            );
          },
          heroTag: true,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.qr_code,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }

  internetChecker(context) async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == false) {
      showInSnackBar('No Internet Connection', context);
    }
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
