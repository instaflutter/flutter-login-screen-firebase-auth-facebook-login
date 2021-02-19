import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String firstName;
  String lastName;

  String phoneNumber;

  bool active;

  Timestamp lastOnlineTimestamp;

  String userID;
  String profilePictureURL;

  bool selected;

  String appIdentifier;

  User(
      {this.email = '',
      this.firstName = '',
      this.phoneNumber = '',
      this.lastName = '',
      this.active = false,
      this.selected = false,
      lastOnlineTimestamp,
      this.userID = '',
      this.profilePictureURL = ''})
      : this.lastOnlineTimestamp = lastOnlineTimestamp ?? Timestamp.now(),
        this.appIdentifier = 'Flutter Login Screen ${Platform.operatingSystem}';

  String fullName() {
    return '$firstName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        active: parsedJson['active'] ?? false,
        lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
        phoneNumber: parsedJson['phoneNumber'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': this.email,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phoneNumber': this.phoneNumber,
      'id': this.userID,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'profilePictureURL': this.profilePictureURL,
      'appIdentifier': this.appIdentifier
    };
  }
}