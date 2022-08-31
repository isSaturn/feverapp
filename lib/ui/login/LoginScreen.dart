import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:dating/ui/resetPasswordScreen/ResetPasswordScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constants.dart';
import '../../main.dart';

final _fireStoreUtils = FireStoreUtils();

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String _phoneNumber, _verificationID;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'ĐĂNG NHẬP',
                      style: TextStyle(
                          color: Color(COLOR_PRIMARY),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 3,
                          child: Image(
                            image: AssetImage('assets/images/login.png'),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                  child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      controller: _emailController,
                      style: TextStyle(fontSize: 18.0),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Color(COLOR_PRIMARY),
                      decoration: InputDecoration(
                          contentPadding:
                              new EdgeInsets.only(left: 16, right: 16),
                          hintText: 'Tài khoản',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(COLOR_PRIMARY), width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))),
                ),
              ),
            ),
            Visibility(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: double.infinity),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                  child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: _passwordController,
                      obscureText: true,
                      onSubmitted: (password) =>
                          _login(_emailController.text, password),
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 18.0),
                      cursorColor: Color(COLOR_PRIMARY),
                      decoration: InputDecoration(
                          contentPadding:
                              new EdgeInsets.only(left: 16, right: 16),
                          hintText: 'Mật khẩu',
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(COLOR_PRIMARY), width: 2.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => push(context, ResetPasswordScreen()),
                  child: Text(
                    'Quên mật khẩu?'.tr(),
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 1),
                  ),
                ),
              ),
            ),
            Visibility(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: RaisedButton(
                    color: Color(COLOR_PRIMARY),
                    child: Text(
                      'Đăng nhập',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    textColor:
                        isDarkMode(context) ? Colors.black : Colors.white,
                    splashColor: Color(COLOR_PRIMARY),
                    onPressed: () =>
                        _login(_emailController.text, _passwordController.text),
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Color(COLOR_PRIMARY))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<User> onClick(String email, String password) {
    if (email.isEmpty) {
      showAlertDialog(
          context, 'E-mail address', 'Yêu cầu nhập đúng tên tài khoản của bạn');
      return null;
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      showAlertDialog(context, 'E-mail address', 'Email không phù hợp');
      return null;
    } else if (password.isEmpty) {
      showAlertDialog(
          context, 'Password', 'Yêu cầu nhập đúng mật khẩu tài khoản của bạn');
      return null;
    } else {
      showProgress(context, 'Đang đăng nhập, vui lòng đợi...', false);
      return loginWithUserNameAndPassword(email.trim(), password.trim());
    }
  }

  Future<User> loginWithUserNameAndPassword(
      String email, String password) async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      firestore.DocumentSnapshot documentSnapshot = await FireStoreUtils
          .firestore
          .collection(USERS)
          .doc(result.user.uid)
          .get();
      User user;
      if (documentSnapshot != null && documentSnapshot.exists) {
        user = User.fromJson(documentSnapshot.data());
        user.active = true;
        await _fireStoreUtils.updateCurrentUser(user, context);
        hideProgress();
        MyAppState.currentUser = user;
      }
      return user;
    } on auth.FirebaseAuthException catch (error) {
      hideProgress();
      switch (error.code) {
        case "invalid-email":
          errorMessage =
              "Địa chỉ email của bạn dường như không đúng định dạng.";
          break;
        case "wrong-password":
          errorMessage = "Mật khẩu của bạn sai.";
          break;
        case "user-not-found":
          errorMessage = "Người dùng có email này không tồn tại.";
          break;
        case "user-disabled":
          errorMessage = "Người dùng có email này đã bị vô hiệu hóa.";
          break;
        case "too-many-requests":
          errorMessage = "Quá nhiều yêu cầu";
          break;
        case "operation-not-allowed":
          errorMessage = "Đăng nhập bằng Email và Mật khẩu không được bật.";
          break;
        default:
          errorMessage = "Đã xảy ra lỗi không xác định.";
      }
      Fluttertoast.showToast(msg: errorMessage);
      print(error.code);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(String email, String password) async {
    dynamic result = await onClick(email, password);
    if (result != null) {
      User user = result;
      pushAndRemoveUntil(context, HomeScreen(user: user), false);
    }
  }
}
