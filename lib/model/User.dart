import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  String email = '';
  String firstName = '';
  String lastName = '';
  String relationshipStatus = '';
  String denominationalViews = '';
  String zodiac = '';
  String majors = '';
  String seeking = '';
  String willingToRelocate = '';

  Settings settings = Settings(
      pushNewMessages: true,
      distanceRadius: '10',
      gender: 'Nam',
      genderPreference: 'Nữ',
      pushNewMatchesEnabled: true,
      pushSuperLikesEnabled: true,
      pushTopPicksEnabled: true,
      showMe: true);
  String phoneNumber = '';
  bool active = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String userID;
  String profilePictureURL = '';

  //tinder related fields
  Location location = Location(latitude: 00.1, longitude: 00.1);
  Location signUpLocation = Location(latitude: 00.1, longitude: 00.1);
  bool showMe = true;
  String bio = '';
  String age = '';
  List<dynamic> photos = [];

  //internal use only, don't save to db
  String milesAway = '0 Km';
  bool selected = false;

  User({
    this.email,
    this.userID,
    this.profilePictureURL,
    this.firstName,
    this.phoneNumber,
    this.lastName,
    this.active,
    this.lastOnlineTimestamp,
    this.settings,
    this.relationshipStatus,
    this.denominationalViews,
    this.zodiac,
    this.majors,
    this.seeking,
    this.willingToRelocate,

    //tinder related fields
    this.showMe,
    this.location,
    this.signUpLocation,
    this.age,
    this.bio,
    this.photos,
  });

  String fullName() {
    return '$firstName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        relationshipStatus: parsedJson['relationshipStatus'] ?? '',
        denominationalViews: parsedJson['denominationalViews'] ?? '',
        zodiac: parsedJson['zodiac'] ?? '',
        majors: parsedJson['majors'] ?? '',
        seeking: parsedJson['seeking'] ?? '',
        willingToRelocate: parsedJson['willingToRelocate'] ?? '',
        active: parsedJson['active'] ?? false,
        lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
        settings: Settings.fromJson(parsedJson['settings'] ??
            {
              'pushNewMessages': true,
              'distanceRadius': '10',
              'gender': 'Nam',
              'genderPreference': 'Nữ',
              'pushNewMatchesEnabled': true,
              'pushSuperLikesEnabled': true,
              'pushTopPicksEnabled': true,
              'showMe': true
            }),
        phoneNumber: parsedJson['phoneNumber'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? '',

        //dating app related fields
        showMe: parsedJson['showMe'] ?? parsedJson['showMeOnTinder'] ?? true,
        location: Location.fromJson(
            parsedJson['location'] ?? {'latitude': 00.1, 'longitude': 00.1}),
        signUpLocation: Location.fromJson(parsedJson['signUpLocation'] ??
            {'latitude': 00.1, 'longitude': 00.1}),
        age: parsedJson['age'] ?? '',
        bio: parsedJson['bio'] ?? 'N/A',
        photos: parsedJson['photos'] ?? [].cast<String>());
  }

  Map<String, dynamic> toJson() {
    photos.toList().removeWhere((element) => element == null);
    return {
      "email": this.email,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "relationshipStatus": this.relationshipStatus,
      "denominationalViews": this.denominationalViews,
      "zodiac": this.zodiac,
      "majors": this.majors,
      "seeking": this.seeking,
      "willingToRelocate": this.willingToRelocate,
      "settings": this.settings.toJson(),
      "phoneNumber": this.phoneNumber,
      "id": this.userID,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      "profilePictureURL": this.profilePictureURL,

      //tinder related fields
      'showMe': this.settings.showMe,
      'location': this.location.toJson(),
      'signUpLocation': this.signUpLocation.toJson(),
      'bio': this.bio,
      'age': this.age,
      'photos': this.photos,
    };
  }
}

class Settings {
  bool pushNewMessages = true;
  bool pushNewMatchesEnabled = true;
  bool pushSuperLikesEnabled = true;
  bool pushTopPicksEnabled = true;
  String genderPreference = 'Nữ'; // should be either "Male" or "Female"
  // or "All"
  String gender = 'Nam'; // should be either "Male" or "Female"
  String distanceRadius = '10';
  bool showMe = true;

  Settings({
    this.pushNewMessages,
    this.pushNewMatchesEnabled,
    this.pushSuperLikesEnabled,
    this.pushTopPicksEnabled,
    this.genderPreference,
    this.gender,
    this.distanceRadius,
    this.showMe,
  });

  factory Settings.fromJson(Map<dynamic, dynamic> parsedJson) {
    return new Settings(
      pushNewMessages: parsedJson['pushNewMessages'] ?? true,
      pushNewMatchesEnabled: parsedJson['pushNewMatchesEnabled'] ?? true,
      pushSuperLikesEnabled: parsedJson['pushSuperLikesEnabled'] ?? true,
      pushTopPicksEnabled: parsedJson['pushTopPicksEnabled'] ?? true,
      genderPreference: parsedJson['genderPreference'] ?? 'Nữ',
      gender: parsedJson['gender'] ?? 'Nam',
      distanceRadius: parsedJson['distanceRadius'] ?? '10',
      showMe: parsedJson['showMe'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushNewMessages': this.pushNewMessages,
      'pushNewMatchesEnabled': this.pushNewMatchesEnabled,
      'pushSuperLikesEnabled': this.pushSuperLikesEnabled,
      'pushTopPicksEnabled': this.pushTopPicksEnabled,
      'genderPreference': this.genderPreference,
      'gender': this.gender,
      'distanceRadius': this.distanceRadius,
      'showMe': this.showMe
    };
  }
}

class Location {
  num latitude = 00.1;
  num longitude = 00.1;

  Location({this.latitude, this.longitude});

  factory Location.fromJson(Map<dynamic, dynamic> parsedJson) {
    return new Location(
      latitude: parsedJson['latitude'] ?? 00.1,
      longitude: parsedJson['longitude'] ?? 00.1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': this.latitude,
      'longitude': this.longitude,
    };
  }
}
