import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/utils/constants.dart';

class Generate extends StatefulWidget {
  final String id;
  final String deviceid;
  const Generate({Key key, this.id, this.deviceid}) : super(key: key);
  @override
  State<StatefulWidget> createState() => GenerateState();
}

class GenerateState extends State<Generate> {
  // already generated qr code when the page opens

  //add qr code
  GlobalKey globalKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('QR код хадгалах'),
        actions: <Widget>[],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: widget.deviceid + "/" + widget.id,
                    size: 0.5 * bodyHeight,
                  ),
                ),
              ),
            ),
            // QrImage(
            //   //plce where the QR Image will be shown
            //   data: qrData,
            // ),
            SizedBox(
              height: 40.0,
            ),
            InkWell(
              onTap: () {
                showImageChoices(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 1,
                // decoration: BoxDecoration(
                //   borderRadius:
                //       BorderRadius.all(Radius.circular(50.0)),
                //   color: Colors.black,
                // ),
                child: Center(
                    child: mediaUrl == null
                        ? Image(
                            image: AssetImage('assets/images/new1.png'),
                            fit: BoxFit.fill,
                          )
                        : Image(
                            image: FileImage(mediaUrl),
                            fit: BoxFit.fill,
                          )),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: FlatButton(
                padding: EdgeInsets.all(15.0),
                onPressed: () async {
                  if (mediaUrl != null) {
                    saveqrcode(mediaUrl);
                    // setState(() {
                    //   qrData = "";
                    // });
                  } else {
                    // setState(() {
                    //   qrData = qrdataFeed.text;
                    // });
                  }
                },
                child: Text(
                  "Хадгалах",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue, width: 3.0),
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            )
          ],
        ),
      ),
    );
  }

  final qrdataFeed = TextEditingController();
  final picker = ImagePicker();
  File mediaUrl;
  saveqrcode(File mediaUrl) async {
    final storageReference = FirebaseStorage.instance.ref().child(
        'Device/docs/${widget.deviceid}/qrimage/${Path.basename(mediaUrl.path)}');
    print("device" + widget.deviceid);
    print("doc id" + widget.id);
    final FirebaseFirestore kfirestore = FirebaseFirestore.instance;
    final CollectionReference _deviceCollection =
        kfirestore.collection('device');
    UploadTask uploadTask = storageReference.putFile(mediaUrl);
    await uploadTask.then((value) {
      storageReference.getDownloadURL().then((fileURL) async {
        _deviceCollection
            .doc(widget.deviceid)
            .collection('docs')
            .doc(widget.id)
            .update({'qrcode': fileURL.toString()});
      });
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  showImageChoices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'QR оруулах',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Feather.camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(camera: true);
                },
              ),
              ListTile(
                leading: Icon(Feather.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  pickImage({bool camera = false, BuildContext context}) async {
    try {
      PickedFile pickedFile = await picker.getImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Зураг тасдах',
          toolbarColor: Constants.lightAccent,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );
      mediaUrl = File(croppedFile.path);
    } catch (e) {
      showInSnackBar('Цуцлах', context);
    }
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
