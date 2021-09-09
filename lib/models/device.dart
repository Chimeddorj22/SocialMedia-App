import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  String key;
  String dName;
  String description;
  String photoUrl;
  String createdAt;
  String updatedAt;
  DeviceModel({
    this.key,
    this.dName,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
  });

  DeviceModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    key = map['key'];
    dName = map['dName'];
    description = map['description'];
    photoUrl = map['photoUrl'];
    createdAt = map['createdAt'];
    updatedAt = map['updatedAt'];
  }
  toJson() {
    return {
      'key': key,
      "dName": dName,
      "description": description,
      "photoUrl": photoUrl,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  DeviceModel copyWith({
    String key,
    String dName,
    String description,
    String createdAt,
    String updatedAt,
    String photoUrl,
  }) {
    return DeviceModel(
      key: key ?? this.key,
      dName: dName ?? this.dName,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
