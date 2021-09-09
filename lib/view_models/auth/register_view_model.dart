import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/auth/register/profile_pic.dart';
import 'package:social_media_app/services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  String username,
      lastname,
      firstname,
      email,
      tabel,
      country,
      tseh,
      section,
      group,
      password,
      cPassword;
  FocusNode usernameFN = FocusNode();
  FocusNode lastnameFN = FocusNode();
  FocusNode firstnameFN = FocusNode();
  FocusNode emailFN = FocusNode();
  FocusNode tabelFN = FocusNode();
  FocusNode countryFN = FocusNode();
  FocusNode tsehFN = FocusNode();
  FocusNode sectionFN = FocusNode();
  FocusNode groupFN = FocusNode();
  FocusNode passFN = FocusNode();
  FocusNode cPassFN = FocusNode();
  AuthService auth = AuthService();

  register(BuildContext context) async {
    FormState form = formKey.currentState;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'Бүртгүүлэхэд алдаа гарлаа та мэдээллүүдээ шалгаад дахин оролдоно уу.',
          context);
    } else {
      if (password == cPassword) {
        loading = true;
        notifyListeners();
        try {
          bool success = await auth.createUser(
            name: lastname + " " + firstname,
            lastname: lastname,
            firstname: firstname,
            email: email,
            tabel: tabel,
            password: password,
            country: country,
            tseh: tseh,
            section: section,
            group: group,
          );
          print(success);
          if (success) {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (_) => ProfilePicture(),
              ),
            );
          }
        } catch (e) {
          loading = false;
          notifyListeners();
          print(e);
          showInSnackBar(
              '${auth.handleFirebaseAuthError(e.toString())}', context);
        }
        loading = false;
        notifyListeners();
      } else {
        showInSnackBar('The passwords does not match', context);
      }
    }
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  setTabel(val) {
    tabel = val;
    notifyListeners();
  }

  setPassword(val) {
    password = val;
    notifyListeners();
  }

  setName(val) {
    username = val;
    notifyListeners();
  }

  setlastname(val) {
    lastname = val;
    notifyListeners();
  }

  setfirstname(val) {
    firstname = val;
    notifyListeners();
  }

  setConfirmPass(val) {
    cPassword = val;
    notifyListeners();
  }

  setCountry(val) {
    country = val;
    notifyListeners();
  }

  setTseh(val) {
    tseh = val;
    notifyListeners();
  }

  setSection(val) {
    section = val;
    notifyListeners();
  }

  setGroup(val) {
    group = val;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
