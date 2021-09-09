import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String username;
  String lastname;
  String firstname;
  String email;
  String tabel;
  String photoUrl;
  String country;
  String tseh;
  String section;
  String group;
  String bio;
  String id;
  Timestamp signedUpAt;
  Timestamp lastSeen;
  bool isOnline;

  UserModel(
      {this.username,
      this.lastname,
      this.firstname,
      this.email,
      this.tabel,
      this.id,
      this.photoUrl,
      this.signedUpAt,
      this.isOnline,
      this.lastSeen,
      this.bio,
      this.country,
      this.tseh,
      this.section,
      this.group});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    lastname = json['lastname'];
    firstname = json['firstname'];
    email = json['email'];
    tabel = json['tabel'];
    country = json['country'];
    tseh = json['tseh'];
    section = json['section'];
    group = json['group'];
    photoUrl = json['photoUrl'];
    signedUpAt = json['signedUpAt'];
    isOnline = json['isOnline'];
    lastSeen = json['lastSeen'];
    bio = json['bio'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['country'] = this.country;
    data['tseh'] = this.tseh;
    data['section'] = this.section;
    data['group'] = this.group;
    data['email'] = this.email;
    data['tabel'] = this.tabel;
    data['photoUrl'] = this.photoUrl;
    data['bio'] = this.bio;
    data['signedUpAt'] = this.signedUpAt;
    data['isOnline'] = this.isOnline;
    data['lastSeen'] = this.lastSeen;
    data['id'] = this.id;

    return data;
  }
}
