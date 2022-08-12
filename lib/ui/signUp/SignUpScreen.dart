import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart' as location;
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/InfoUserScreen/InfoUserScreen.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

File _image;

class SignUpScreen extends StatefulWidget {
  @override
  State createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  GlobalKey<FormState> _key = new GlobalKey();
  String firstName,
      lastName,
      email,
      mobile,
      password,
      confirmPassword,
      _phoneNumber,
      _verificationID;
  LocationData signUpLocation;
  AutovalidateMode _validate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      retrieveLostData();
    }

    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
          child: new Form(
            key: _key,
            autovalidateMode: _validate,
            child: formUI(),
          ),
        ),
      ),
    );
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _imagePicker.getLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file.path);
      });
    }
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Add profile picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.gallery);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        new Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Tạo tài khoản',
              style: TextStyle(
                  color: Color(COLOR_PRIMARY),
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            )),
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, top: 32, right: 8, bottom: 8),
          child: Visibility(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.grey.shade400,
                  child: ClipOval(
                    child: SizedBox(
                      width: 170,
                      height: 170,
                      child: _image == null
                          ? Image.asset(
                              'assets/images/placeholder.jpg',
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  left: 80,
                  right: 0,
                  child: FloatingActionButton(
                      backgroundColor: Color(COLOR_ACCENT),
                      // ignore: sort_child_properties_last
                      child: Icon(
                        Icons.camera_alt,
                        color:
                            isDarkMode(context) ? Colors.black : Colors.white,
                      ),
                      mini: true,
                      onPressed: _onCameraClick),
                )
              ],
            ),
          ),
        ),
        Visibility(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                cursorColor: Color(COLOR_PRIMARY),
                textAlignVertical: TextAlignVertical.center,
                validator: validateName,
                controller: _firstNameController,
                onSaved: (String val) {
                  firstName = val;
                },
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  fillColor: Colors.white,
                  hintText: 'Họ',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                validator: validateName,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Color(COLOR_PRIMARY),
                onSaved: (String val) {
                  lastName = val;
                },
                controller: _lastNameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  fillColor: Colors.white,
                  hintText: 'Tên',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.next,
                cursorColor: Color(COLOR_PRIMARY),
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                validator: validateEmail,
                onSaved: (String val) {
                  email = val;
                },
                decoration: InputDecoration(
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  fillColor: Colors.white,
                  hintText: 'Email VLU của bạn',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                obscureText: true,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                controller: _passwordController,
                validator: validatePassword,
                onSaved: (String val) {
                  password = val;
                },
                style: TextStyle(fontSize: 18.0),
                cursorColor: Color(COLOR_PRIMARY),
                decoration: InputDecoration(
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  fillColor: Colors.white,
                  hintText: 'Mật khẩu',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _sendToServer();
                },
                obscureText: true,
                validator: (val) =>
                    validateConfirmPassword(_passwordController.text, val),
                onSaved: (String val) {
                  confirmPassword = val;
                },
                style: TextStyle(fontSize: 18.0),
                cursorColor: Color(COLOR_PRIMARY),
                decoration: InputDecoration(
                  contentPadding:
                      new EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  fillColor: Colors.white,
                  hintText: 'Xác nhận mật khẩu',
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          child: Padding(
            padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 40.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: RaisedButton(
                color: Color(COLOR_PRIMARY),
                child: Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                textColor: isDarkMode(context) ? Colors.black : Colors.white,
                splashColor: Color(COLOR_PRIMARY),
                onPressed: () => _signUp(),
                padding: EdgeInsets.only(top: 12, bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(
                    color: Color(COLOR_PRIMARY),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _sendToServer() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Creating new account, Please wait...', false);
      var profilePicUrl = '';
      try {
        auth.UserCredential result = await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.trim(), password: password.trim());
        if (_image != null) {
          updateProgress('Uploading image, Please wait...');
          profilePicUrl = await FireStoreUtils()
              .uploadUserImageToFireStorage(_image, result.user.uid);
        }
        User user = User(
            email: email.trim(),
            firstName: firstName,
            lastOnlineTimestamp: fire.Timestamp.now(),
            bio: '',
            age: '',
            phoneNumber: '',
            userID: result.user.uid,
            active: true,
            lastName: lastName,
            photos: [],
            showMe: true,
            location: location.Location(
                latitude: signUpLocation.latitude,
                longitude: signUpLocation.longitude),
            signUpLocation: location.Location(
                latitude: signUpLocation.latitude,
                longitude: signUpLocation.longitude),
            settings: Settings(
              pushNewMessages: true,
              pushNewMatchesEnabled: true,
              pushSuperLikesEnabled: true,
              pushTopPicksEnabled: true,
              genderPreference: 'Nữ',
              gender: 'Nam',
              distanceRadius: '10',
              showMe: true,
            ),
            fcmToken: await FirebaseMessaging.instance.getToken(),
            profilePictureURL: profilePicUrl);
        await FireStoreUtils.firestore
            .collection(USERS)
            .doc(result.user.uid)
            .set(user.toJson())
            .catchError((onError) {
          print(onError);
        });
        hideProgress();
        MyAppState.currentUser = user;
        pushAndRemoveUntil(context, InfoUserScreen(user: user), false);
      } on auth.FirebaseAuthException catch (error) {
        hideProgress();
        String message = 'Couldn\'t sign up';
        switch (error.code) {
          case 'email-already-in-use':
            message = 'Email already in use, Please pick another email!';
            break;
          case 'invalid-email':
            message = 'Enter valid e-mail';
            break;
          case 'operation-not-allowed':
            message = 'Email/password accounts are not enabled';
            break;
          case 'weak-password':
            message = 'Password must be more than 5 characters';
            break;
          case 'too-many-requests':
            message = 'Too many requests, Please try again later.';
            break;
        }
        showAlertDialog(context, 'Failed', message);
        print(error.toString());
      } catch (e) {
        hideProgress();
        showAlertDialog(context, 'Failed', 'Couldn\'t sign up');
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _image = null;
    super.dispose();
  }

  _signUp() async {
    signUpLocation = await getCurrentLocation();
    if (signUpLocation != null) {
      _sendToServer();
    } else {
      _scaffoldState.currentState.showSnackBar(SnackBar(
        content: Text('Location is required to match you with people from '
            'your area.'),
        duration: Duration(seconds: 6),
      ));
    }
  }
}
