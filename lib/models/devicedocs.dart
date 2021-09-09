import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceDocsModel {
  String name;
  String description;
  String key;
  String file;
  String qrcode;

  String createdAt;
  String updatedAt;
  DeviceDocsModel({
    this.key,
    this.name,
    this.description,
    this.file,
    this.createdAt,
    this.updatedAt,
  });

  DeviceDocsModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    key = map['key'];
    name = map['name'];
    description = map['description'];
    file = map['file'];
    file = map['qrcode'];
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
  }
  toJson() {
    return {
      'key': key,
      "dName": name,
      "description": description,
      "file": file,
      "qrcode": qrcode,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  DeviceDocsModel copyWith({
    String key,
    String name,
    String description,
    String createdAt,
    String updatedAt,
    String file,
    String qrcode,
  }) {
    return DeviceDocsModel(
      key: key ?? this.key,
      name: name ?? this.name,
      description: description ?? this.description,
      file: file ?? this.file,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
