import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:social_media_app/components/GradiantIcon.dart';
import 'package:social_media_app/pages/widget/customDialog.dart';

class CreateDoc extends StatefulWidget {
  @override
  _CreateDocState createState() => _CreateDocState();
}

class _CreateDocState extends State<CreateDoc> {
  getImage(BuildContext context, ImageSource source,
      {bool image1 = false}) async {
    // ignore: deprecated_member_use
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        if (image1 == false) {
          print('image1 $image1');
        } else {
          _image1 = File(pickedFile.path);
        }
      }
    });
    Navigator.pop(context);
  }

  int _currentStep = 0;
  File _image1;
  StepperType stepperType = StepperType.vertical;
  String _key;
  String _dName;
  String _description;
  String _createdAt;
  String _updatedAt;
  bool _isAgree = false;
  String buttonText = 'Үргэлжлүүлэх';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFDFE0E0),
        title: GradientText(
          "Төхөөрөмж бүртгэл",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              // color: Colors.white,
              fontFamily: 'Sans'),
          colors: [
            Color(0xFFB2A9CA),
            Color(0xFF362C32),
          ],
        ),
        brightness: Brightness.dark,
        leading: new IconButton(
          color: Colors.white,
          icon: GradientIcon(
            icon: Icons.arrow_back,
            gradient: LinearGradient(
              colors: [
                Color(0xffF17AB9),
                Color(0xff9F81E9),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            size: 25,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.green),
        elevation: 0.0,
      ),
      body: Theme(
        data: ThemeData(
            accentColor: Color(0xffF17AB9),
            primarySwatch: Colors.indigo,
            colorScheme: ColorScheme.light(primary: Color(0xffF17AB9))),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Column(children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.height / 12,
                      ),
                      Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: onStepContinue,
                            child: Text(
                              buttonText,
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xffF17AB9)),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 13,
                          ),
                          TextButton(
                            onPressed: onStepCancel,
                            child: const Text(
                              'Буцах',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xffF17AB9)),
                            ),
                          ),
                        ],
                      ),
                    ]);
                  },
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                    Step(
                      title: new Text('Төхөөрөмжийн нэр'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Төхөөрөмжийн нэр'),
                            onChanged: (value) {
                              setState(() {
                                _dName = value;
                                print('Төхөөрөмжийн нэр $_dName');
                              });
                            },
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: new Text('Тайлбар'),
                      content: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Тайлбар'),
                            onChanged: (value) {
                              setState(() {
                                _description = value;
                                print('Тайлбар $_description');
                              });
                            },
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: new Text('Зураг'),
                      content: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              openchooseBottomSheet(context, imageNo: 1);
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
                                  child: _image1 == null
                                      ? Image(
                                          image: AssetImage(
                                              'assets/images/new1.png'),
                                          fit: BoxFit.fill,
                                        )
                                      : Image(
                                          image: FileImage(_image1),
                                          fit: BoxFit.fill,
                                        )),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 20,
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: new Text('Зөвшөөрөл'),
                      content: Column(
                        children: <Widget>[
                          // TextFormField(
                          //   decoration:
                          //       InputDecoration(labelText: 'Mobile Number'),
                          // ),
                          CheckboxListTile(
                            title: Text('Та зөвшөөрч байна уу?'),
                            value: _isAgree,
                            onChanged: (val) {
                              setState(() {
                                // if(_isAgree==true){

                                // }else{

                                // }
                                _isAgree = val;
                                print('agree $_isAgree');
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 3
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffF17AB9),
        child: Icon(
          Icons.list,
          color: Colors.white,
        ),
        onPressed: switchStepsType,
      ),
    );
  }

  Widget _rowdeletebottomsheet(
      {String desc, String txt, IconData icon, double padding, Color color}) {
    return InkWell(
      // onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: padding),
                      child: Icon(
                        icon,
                        color: color,
                        size: 30,
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              txt,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Sofia",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              desc,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Sofia",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                    size: 15.0,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            color: Colors.black12,
          )
        ],
      ),
    );
  }

  void openchooseBottomSheet(BuildContext context, {imageNo}) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 260,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  ),
                ],
              ),
              SizedBox(
                height: 18.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Сонголтууд",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: "Sans",
                        fontSize: 20.0,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (imageNo == 1) {
                          print('image $imageNo');
                          getImage(context, ImageSource.gallery, image1: true);
                        } else {}
                      },
                      child: _rowdeletebottomsheet(
                        txt: "Gallery",
                        desc: "Choose photos from gallery",
                        icon: Icons.photo,
                        padding: 20.0,
                        color: Colors.green,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (imageNo == 1) {
                          print('image $imageNo');
                          getImage(context, ImageSource.camera, image1: true);
                        } else {}
                      },
                      child: _rowdeletebottomsheet(
                        txt: "Camera",
                        desc: "Choose photos from camera",
                        icon: Icons.camera_alt_outlined,
                        padding: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 3
        ? setState(() {
            _currentStep += 1;
            buttonText = "Үргэлжлүүлэх";
            print('step $_currentStep');
            _currentStep > 1
                ? setState(() {
                    buttonText = "Хүсэлт илгээх";
                  })
                : null;
          })
        : setState(() {
            if (_dName != null && _description != null && _image1 != null) {
              buttonText = "Хүсэлт илгээх";
              final userdata = <String, dynamic>{
                'key': "",
                'dName': _dName,
                'description': _description,
              };
              setUserIdentityInfo(
                userdata,
                image: _image1,
              );
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: "Алдаа гарлаа",
                      descriptions:
                          "Та бүх талбарыг бүрэн бөглөөгүй байна. Бүх талбарыг бөглөж зураг сонгосон байх шаардлагатай. !!",
                      text: "Хаах",
                    );
                  });
            }
          });
  }

  cancel() {
    _currentStep > 0
        ? setState(() {
            _currentStep -= 1;
            buttonText = "Үргэлжлүүлэх";
          })
        : null;
  }

  setUserIdentityInfo(data, {File image}) async {
    DateTime now = DateTime.now();
    final userdata = <String, dynamic>{
      'key': "1",
      'dName': data['dName'],
      'description': data['description'],
      'photoUrl': '',
      'createdAt': now.year.toString(),
      'updatedAt': "no"
    };
    String idid = '1';
    final FirebaseFirestore kfirestore = FirebaseFirestore.instance;
    final CollectionReference _deviceCollection =
        kfirestore.collection('device');
    _deviceCollection.add(userdata).then((value) {
      idid = value.id;
      print("1" + idid);
    });
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('Device/${Path.basename(image.path)}');
    print("2" + idid);
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.then((value) {
      storageReference.getDownloadURL().then((fileURL) async {
        _deviceCollection
            .doc(idid)
            .update({'photoUrl': fileURL.toString(), 'key': idid});
        print("3" + idid);
      });
    });
    Navigator.pop(context);
  }
}
