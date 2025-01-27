import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/utils/firebase.dart';

class AuthService {
  User getCurrentUser() {
    User user = firebaseAuth.currentUser;
    return user;
  }

//create a firebase user
  Future<bool> createUser(
      {String name,
      String lastname,
      String firstname,
      User user,
      String email,
      String tabel,
      String country,
      String tseh,
      String section,
      String group,
      String password}) async {
    var res = await firebaseAuth.createUserWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );
    if (res.user != null) {
      await saveUserToFirestore(
        name,
        lastname,
        firstname,
        res.user,
        email,
        tabel,
        country,
        tseh,
        section,
        group,
      );
      return true;
    } else {
      return false;
    }
  }

//this will save the details inputted by the user to firestore.
  saveUserToFirestore(
    String name,
    String lastname,
    String firstname,
    User user,
    String email,
    String tabel,
    String country,
    String tseh,
    String section,
    String group,
  ) async {
    await usersRef.doc(user.uid).set({
      'username': name,
      'lastname': lastname,
      'firstname': firstname,
      'email': email,
      'tabel': tabel,
      'time': Timestamp.now(),
      'id': user.uid,
      'bio': "Энэ бол таны био",
      'country': country,
      'tseh': tseh,
      'section': section,
      'group': group,
      'photoUrl': user.photoURL ?? ''
    });
  }

//function to login a user with his email and password
  Future<bool> loginUser({String email, String password}) async {
    var res = await firebaseAuth.signInWithEmailAndPassword(
      email: '$email',
      password: '$password',
    );

    if (res.user != null) {
      return true;
    } else {
      return false;
    }
  }

  forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  logOut() async {
    await firebaseAuth.signOut();
  }

  String handleFirebaseAuthError(String e) {
    if (e.contains("ERROR_WEAK_PASSWORD")) {
      return "Password is too weak";
    } else if (e.contains("invalid-email")) {
      return "Invalid Email";
    } else if (e.contains("ERROR_EMAIL_ALREADY_IN_USE") ||
        e.contains('email-already-in-use')) {
      return "The email address is already in use by another account.";
    } else if (e.contains("ERROR_NETWORK_REQUEST_FAILED")) {
      return "Network error occured!";
    } else if (e.contains("ERROR_USER_NOT_FOUND") ||
        e.contains('firebase_auth/user-not-found')) {
      return "Invalid credentials.";
    } else if (e.contains("ERROR_WRONG_PASSWORD") ||
        e.contains('wrong-password')) {
      return "Invalid credentials.";
    } else if (e.contains('firebase_auth/requires-recent-login')) {
      return 'This operation is sensitive and requires recent authentication.'
          ' Log in again before retrying this request.';
    } else {
      return e;
    }
  }
}
