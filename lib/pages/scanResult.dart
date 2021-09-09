import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:social_media_app/components/custom_image.dart';
import 'package:social_media_app/components/notification_stream_wrapper.dart';
import 'package:social_media_app/models/notification.dart';
import 'package:social_media_app/utils/firebase.dart';
import 'package:social_media_app/utils/global.dart';
import 'package:social_media_app/widgets/notification_items.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScanResult extends StatefulWidget {
  final String scanResult;
  const ScanResult({
    Key key,
    this.scanResult,
  }) : super(key: key);

  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  currentUserId() {
    return firebaseAuth.currentUser.uid;
  }

  Future<DocumentSnapshot> getdata() async {
    DocumentSnapshot documentSnapshot = await deviceRef
        .doc(widget.scanResult.split('/')[0])
        .collection("docs")
        .doc(widget.scanResult.split('/')[1])
        .get();
    return documentSnapshot;
  }

  Future<DocumentSnapshot> devicegetdata() async {
    DocumentSnapshot documentSnapshot = await deviceRef
        .doc(widget.scanResult.split('/')[0])
        .collection("docs")
        .doc(widget.scanResult.split('/')[1])
        .get();
    return documentSnapshot;
  }

  WebViewController _controller;
  _back() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
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

  _forward() async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
    }
  }

  _loadPage() async {
    var url = await _controller.currentUrl();
    _controller.loadUrl(
      url = widget.scanResult.toString(),
    );
    print(url);
  }

  String getUrl() {
    String url =
        "https://docs.google.com/document/d/1xYjg0PXPDWVgYfYOhDrdsIIxUnaxqJSsDq15lqSt9Nk/edit?usp=sharing";
    // usersRef
    //     .doc(firebaseAuth.currentUser.uid)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     print('Document data: ${documentSnapshot.data()}');
    //     tseh = documentSnapshot['tseh'].toString();
    //     section = documentSnapshot['section'].toString();
    //     group = documentSnapshot['group'].toString();
    //   } else {
    //     print('Document data exit');
    //   }
    // });
    if (widget.scanResult.split('(/)')[0] == 'all') {
      url = widget.scanResult.split('(/)')[2];
      return url;
    } else if (widget.scanResult.split('(/)')[0] == 't') {
      if (tseh.trim() == widget.scanResult.split('(/)')[1]) {
        url = widget.scanResult.split('(/)')[2];

        return url;
      } else {
        print('sss tseh $tseh ' + widget.scanResult.split('(/)')[1]);
        return url;
      }
    } else if (widget.scanResult.split('(/)')[0] == 's') {
      if (section.trim() == widget.scanResult.split('(/)')[1]) {
        url = widget.scanResult.split('(/)')[2];
        return url;
      } else {
        print('sss section $section ' + widget.scanResult.split('(/)')[1]);
        return url;
      }
    } else if (widget.scanResult.split('(/)')[0] == 'g') {
      if (group.trim() == widget.scanResult.split('(/)')[1]) {
        url = widget.scanResult.split('(/)')[2];
        return url;
      } else {
        print('sss group $group ' + widget.scanResult.split('(/)')[1]);
        return url;
      }
    } else {
      url =
          "https://docs.google.com/document/d/148TxDEOvyfyafrGPAh4BsafCmZI9Mn_WcH-9qYFPJ4c/edit?usp=sharing";
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Материал'),
        actions: <Widget>[
          IconButton(
            onPressed: _back,
            icon: Icon(Icons.arrow_back_ios),
          ),
          IconButton(
            onPressed: _forward,
            icon: Icon(Icons.arrow_forward_ios),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: _loadPage,
            icon: Icon(Icons.refresh),
          ),
          // FloatingActionButton(
          //   onPressed: _loadPage,
          //   child: Icon(Icons.refresh),
          // ),
        ],
      ),
      floatingActionButton: _floatingActionButton(context),
      body: SafeArea(
        child: WebView(
          key: Key("webview"),
          initialUrl: getUrl(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
        ),
      ),
    );
  }

  getActivities() {
    return ActivityStreamWrapper(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      stream: notificationRef
          .doc(currentUserId())
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots(),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, DocumentSnapshot snapshot) {
        ActivityModel activities = ActivityModel.fromJson(snapshot.data());
        return ActivityItems(
          activity: activities,
        );
      },
    );
  }

  deleteAllItems() async {
//delete all notifications associated with the authenticated user
    QuerySnapshot notificationsSnap = await notificationRef
        .doc(firebaseAuth.currentUser.uid)
        .collection('notifications')
        .get();
    notificationsSnap.docs.forEach(
      (doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      },
    );
  }
}
