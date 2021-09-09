import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/models/device.dart';
import 'package:social_media_app/models/devicedocs.dart';
import 'package:social_media_app/pages/generate.dart';
import 'package:social_media_app/utils/firebase.dart';

import 'CreateDoc.dart';
import 'GeneratePage.dart';
import 'createMaterial.dart';

class DeviceDetails extends StatefulWidget {
  final DeviceModel Device;

  const DeviceDetails({Key key, this.Device}) : super(key: key);

  // constructor

  @override
  _DeviceDetailsState createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final List<String> ids = [];
    int id = 0;
    deviceRef
        .doc(widget.Device.key)
        .collection("docs")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("data " + doc["key"]);
        ids.add(doc["key"]);
        id++;
      });
    });
    CollectionReference Dref =
        deviceRef.doc(widget.Device.key).collection("docs");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.Device.dName} ",
                style: TextStyle(
                    fontFamily: "Sofia",
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    wordSpacing: 0.1),
              ),
              IconButton(
                icon: Icon(
                  CupertinoIcons.create_solid,
                  size: 30.0,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => CreateMaterial(id: widget.Device.key),
                    ),
                  );
                },
              ),
            ],
          ),
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 35.0, bottom: 5.0),
              child: Text(
                "${widget.Device.dName} -ийн талаар",
                style: TextStyle(
                  fontFamily: "Sans",
                  fontWeight: FontWeight.w300,
                  fontSize: 17.5,
                  color: Colors.black45,
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Dref.snapshots(),
                  builder: (context, snapshot) {
                    print("snapshot " + snapshot.data.toString());
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.isEmpty) {
                        return Container(
                          color: Colors.white,
                          width: 500.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 60.0, left: 10.0, right: 10.0),
                                child: Image.asset(
                                  "assets/images/login.png",
                                  height: 250.0,
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 20.0)),
                              Text(
                                'Жагсаалт хоосон байна.',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 21.5,
                                    color: Colors.black54,
                                    fontFamily: "Sofia"),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          print(
                              "sdsd ${snapshot.data.docs.length} ${snapshot.data.docs[index]}");
                          DocumentSnapshot doc = snapshot.data.docs[index];
                          return devicelist(doc['key']);
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            )
          ],
        ));
  }

  Future<DeviceDocsModel> getDeviceDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await deviceRef
          .doc(widget.Device.key)
          .collection("docs")
          .doc(id)
          .get();
      print("hihi " + documentSnapshot.data().toString() + "");
      return DeviceDocsModel.fromJson(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  Widget devicelist(String Id) {
    return FutureBuilder<DeviceDocsModel>(
      future: getDeviceDetailsById(Id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          DeviceDocsModel data = snapshot.data;
          print("dataname" + data.name);
          if (snapshot.hasData) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => GeneratePage(),
                    transitionDuration: Duration(milliseconds: 2000),
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: child,
                      );
                    }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Stack(
                  //   children: <Widget>[
                  //     CircleImage(
                  //       user.profilePic,
                  //       imageSize: 40.0,
                  //       whiteMargin: 2.0,
                  //       imageMargin: 6.0,
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.only(top: 32, left: 35),
                  //       child: OnlineDotIndicator(
                  //         userId: user.userId,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  data.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Sofia",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.5,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  data.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: "Sofia",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: Color(0xFFFBF054),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        /// refresh home page feed
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Засах',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // child: FutureBuilder(
              //   future: chatstate.fetchLastMessageBetween(
              //     senderId: authstate.userModel.userId,
              //     receiverId: user.userId,
              //   ),
              //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //     if (snapshot.hasData) {
              //       var docList = snapshot.data.docs;
              //     }
              //     return Text(
              //       "..",
              //       style: TextStyle(
              //         color: Colors.grey,
              //         fontSize: 14,
              //       ),
              //     );
              //   },
              // ),
            );
          }
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 15.0),
          child: Container(
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 5.0),
                  child: CircleAvatar(
                    radius: 22.0,
                    backgroundColor: Colors.black12,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 220.0,
                        height: 20.0,
                        color: Colors.black12,
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0)),
                      Container(
                        height: 15.0,
                        width: 100.0,
                        color: Colors.black12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.9),
                        child: Container(
                          height: 12.0,
                          width: 140.0,
                          color: Colors.black12,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<String>> getDevice(List<String> ids) async {
    return ids;
  }
}
