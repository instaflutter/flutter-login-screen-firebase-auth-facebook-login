import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/services/Authenticate.dart';
import 'package:flutter_login_screen/ui/home/HomeScreen.dart';
import 'package:flutter_login_screen/ui/utils/helper.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart' as Constants;
import '../../main.dart';

final _fireStoreUtils = FireStoreUtils();

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Form(
        key: _key,
        autovalidateMode: _validate,
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              child: Text(
                'Sign In',
                style: TextStyle(
                    color: Color(Constants.COLOR_PRIMARY),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    validator: validateEmail,
                    onSaved: (String val) {
                      email = val;
                    },
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).nextFocus(),
                    style: TextStyle(fontSize: 18.0),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color(Constants.COLOR_PRIMARY),
                    decoration: InputDecoration(
                        contentPadding:
                            new EdgeInsets.only(left: 16, right: 16),
                        fillColor: Colors.white,
                        hintText: 'E-mail Address',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    validator: validatePassword,
                    onSaved: (String val) {
                      password = val;
                    },
                    onFieldSubmitted: (password) async {
                      await login();
                    },
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 18.0),
                    cursorColor: Color(Constants.COLOR_PRIMARY),
                    decoration: InputDecoration(
                        contentPadding:
                            new EdgeInsets.only(left: 16, right: 16),
                        fillColor: Colors.white,
                        hintText: 'Password',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ))),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  color: Color(Constants.COLOR_PRIMARY),
                  child: Text(
                    'Log In',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.white,
                  splashColor: Color(Constants.COLOR_PRIMARY),
                  onPressed: () async {
                    await login();
                  },
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side:
                          BorderSide(color: Color(Constants.COLOR_PRIMARY))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'OR',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, bottom: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: RaisedButton.icon(
                  label: Text(
                    'Facebook Login',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.asset(
                      'assets/images/facebook_logo.png',
                      color: Colors.white,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  color: Color(Constants.FACEBOOK_BUTTON_COLOR),
                  textColor: Colors.white,
                  splashColor: Color(Constants.FACEBOOK_BUTTON_COLOR),
                  onPressed: () async {
                    final facebookLogin = FacebookLogin();
                    final result = await facebookLogin.logIn(['email']);
                    switch (result.status) {
                      case FacebookLoginStatus.loggedIn:
                        showProgress(
                            context, 'Logging in, please wait...', false);
                        await auth.FirebaseAuth.instance
                            .signInWithCredential(
                                auth.FacebookAuthProvider.credential(
                                    result.accessToken.token))
                            .then((auth.UserCredential authResult) async {
                          User user = await _fireStoreUtils
                              .getCurrentUser(authResult.user.uid);
                          if (user == null) {
                            _createUserFromFacebookLogin(
                                result, authResult.user.uid);
                          } else {
                            _syncUserDataWithFacebookData(result, user);
                          }
                        });
                        break;
                      case FacebookLoginStatus.cancelledByUser:
                        break;
                      case FacebookLoginStatus.error:
                        showAlertDialog(context, 'Error',
                            'Couldn\'t login via facebook.');
                        break;
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                          color: Color(Constants.FACEBOOK_BUTTON_COLOR))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Logging in, please wait...', false);
      User user = await loginWithUserNameAndPassword();
      if (user != null)
        pushAndRemoveUntil(context, HomeScreen(user: user), false);
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Future<User> loginWithUserNameAndPassword() async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      DocumentSnapshot documentSnapshot = await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .doc(result.user.uid)
          .get();
      User user;
      if (documentSnapshot != null && documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data());
        user.active = true;
        await FireStoreUtils.updateCurrentUser(user);
        hideProgress();
        MyAppState.currentUser = user;
      }
      return user;
    } on auth.FirebaseAuthException catch (exception) {
      hideProgress();
      switch ((exception).code) {
        case "invalid-email":
          showAlertDialog(context, 'Couldn\'t Authenticate', 'malformedEmail');
          break;
        case "wrong-password":
          showAlertDialog(context, 'Couldn\'t Authenticate', 'Wrong password');
          break;
        case "user-not-found":
          showAlertDialog(context, 'Couldn\'t Authenticate',
              'No user corresponds to this email');
          break;
        case "user-disabled":
          showAlertDialog(
              context, 'Couldn\'t Authenticate', 'This user is disabled');
          break;
        case 'too-many-requests':
          showAlertDialog(context, 'Couldn\'t Authenticate',
              'Too many requests, Please try again later.');
          break;
      }
      print(exception.toString());
      return null;
    } catch (e) {
      hideProgress();
      showAlertDialog(
          context, 'Couldn\'t Authenticate', 'Login failed. Please try again.');
      print(e.toString());
      return null;
    }
  }

  void _createUserFromFacebookLogin(
      FacebookLoginResult result, String userID) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get('https://graph.facebook.com/v2'
        '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
    final profile = json.decode(graphResponse.body);
    User user = User(
        firstName: profile['first_name'],
        lastName: profile['last_name'],
        email: profile['email'],
        profilePictureURL: profile['picture']['data']['url'],
        active: true,
        userID: userID);
    await FireStoreUtils.firestore
        .collection(Constants.USERS)
        .doc(userID)
        .set(user.toJson())
        .then((onValue) {
      MyAppState.currentUser = user;
      hideProgress();
      pushAndRemoveUntil(context, HomeScreen(user: user), false);
    });
  }

  void _syncUserDataWithFacebookData(
      FacebookLoginResult result, User user) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get('https://graph.facebook.com/v2'
        '.12/me?fields=name,first_name,last_name,email,picture.type(large)&access_token=$token');
    final profile = json.decode(graphResponse.body);
    user.profilePictureURL = profile['picture']['data']['url'];
    user.firstName = profile['first_name'];
    user.lastName = profile['last_name'];
    user.email = profile['email'];
    user.active = true;
    await FireStoreUtils.updateCurrentUser(user);
    MyAppState.currentUser = user;
    hideProgress();
    pushAndRemoveUntil(context, HomeScreen(user: user), false);
  }
}
