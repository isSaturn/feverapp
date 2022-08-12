import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum AuthProviders { PASSWORD, PHONE }

class ReAuthUserScreen extends StatefulWidget {
  final AuthProviders provider;
  final String email;
  final String phoneNumber;
  final bool deleteUser;

  ReAuthUserScreen(
      {Key key,
      @required this.provider,
      this.email,
      this.phoneNumber,
      @required this.deleteUser})
      : super(key: key);

  @override
  _ReAuthUserScreenState createState() => _ReAuthUserScreenState();
}

class _ReAuthUserScreenState extends State<ReAuthUserScreen> {
  TextEditingController _passwordController = TextEditingController();
  Widget body = CircularProgressIndicator.adaptive();
  String _verificationID;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      buildBody();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Text(
                  'Vui lòng xác thực lại để thực hiện hành động này.',
                  textAlign: TextAlign.center,
                ),
              ),
              body,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: 'Nhập mật khẩu của bạn'.tr()),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(COLOR_PRIMARY),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
            onPressed: () async => passwordButtonPressed(),
            child: Text(
              'Đồng ý xóa :(('.tr(),
              style: TextStyle(
                  color: isDarkMode(context) ? Colors.black : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPhoneField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: PinCodeTextField(
            length: 6,
            appContext: context,
            keyboardType: TextInputType.phone,
            backgroundColor: Colors.transparent,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 40,
                fieldWidth: 40,
                activeColor: Color(COLOR_PRIMARY),
                activeFillColor: isDarkMode(context)
                    ? Colors.grey.shade700
                    : Colors.grey.shade100,
                selectedFillColor: Colors.transparent,
                selectedColor: Color(COLOR_PRIMARY),
                inactiveColor: Colors.grey.shade600,
                inactiveFillColor: Colors.transparent),
            enableActiveFill: true,
            onCompleted: (v) {
              _submitCode(v);
            },
            onChanged: (value) {
              print(value);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  passwordButtonPressed() async {
    if (_passwordController.text.isEmpty) {
      showAlertDialog(context, 'Empty Password'.tr(),
          'Password is required to update email'.tr());
    } else {
      await showProgress(context, 'Verifying...'.tr(), false);
      try {
        auth.UserCredential result = await FireStoreUtils.reAuthUser(
            widget.provider,
            email: MyAppState.currentUser.email,
            password: _passwordController.text);
        if (result == null) {
          await hideProgress();
          showAlertDialog(context, 'Couldn\'t verify'.tr(),
              'Please double check the password and try again.'.tr());
        } else {
          if (result.user != null) {
            if (widget.email != null)
              await result.user.updateEmail(widget.email);
            await hideProgress();
            Navigator.pop(context, true);
          } else {
            await hideProgress();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Couldn\'t verify, Please try again.'.tr(),
                  style: TextStyle(fontSize: 17),
                ),
              ),
            );
          }
        }
      } catch (e, s) {
        print('_ReAuthUserScreenState.passwordButtonPressed $e $s');
        await hideProgress();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Couldn\'t verify, Please try again.'.tr(),
              style: TextStyle(fontSize: 17),
            ),
          ),
        );
      }
    }
  }

  _submitPhoneNumber() async {
    await showProgress(context, 'Sending code...'.tr(), true);
    await FireStoreUtils.firebaseSubmitPhoneNumber(
      widget.phoneNumber,
      (String verificationId) {
        if (mounted) {
          hideProgress();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Code verification timeout, request new code.'.tr(),
              ),
            ),
          );
        }
      },
      (String verificationId, int forceResendingToken) async {
        if (mounted) {
          await hideProgress();
          _verificationID = verificationId;
        }
      },
      (auth.FirebaseAuthException error) async {
        if (mounted) {
          await hideProgress();
          print('${error.message} ${error.stackTrace}');
          String message = 'An error has occurred, please try again.'.tr();
          switch (error.code) {
            case 'invalid-verification-code':
              message = 'Invalid code or has been expired.'.tr();
              break;
            case 'user-disabled':
              message = 'This user has been disabled.'.tr();
              break;
            default:
              message = 'An error has occurred, please try again.'.tr();
              break;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
              ),
            ),
          );
          Navigator.pop(context);
        }
      },
      (auth.PhoneAuthCredential credential) async {},
    );
  }

  void _submitCode(String code) async {
    await showProgress(context, 'Verifying...'.tr(), false);
    try {
      if (_verificationID != null) {
        if (widget.deleteUser) {
          await FireStoreUtils.reAuthUser(widget.provider,
              verificationId: _verificationID, smsCode: code);
        } else {
          auth.PhoneAuthCredential credential =
              auth.PhoneAuthProvider.credential(
                  smsCode: code, verificationId: _verificationID);
          await auth.FirebaseAuth.instance.currentUser
              .updatePhoneNumber(credential);
        }
        await hideProgress();
        Navigator.pop(context, true);
      } else {
        await hideProgress();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Couldn\'t get verification ID'.tr()),
            duration: Duration(seconds: 6),
          ),
        );
      }
    } on auth.FirebaseAuthException catch (exception) {
      print('_ReAuthUserScreenState._submitCode ${exception.toString()}');
      await hideProgress();
      Navigator.pop(context);

      String message = 'An error has occurred, please try again.'.tr();
      switch (exception.code) {
        case 'invalid-verification-code':
          message = 'Invalid code or has been expired.'.tr();
          break;
        case 'user-disabled':
          message = 'This user has been disabled.'.tr();
          break;
        default:
          message = 'An error has occurred, please try again.'.tr();
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );
    } catch (e, s) {
      print('_PhoneNumberInputScreenState._submitCode $e $s');
      await hideProgress();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error has occurred, please try again.'.tr(),
          ),
        ),
      );
    }
  }

  void buildBody() async {
    switch (widget.provider) {
      case AuthProviders.PASSWORD:
        body = buildPasswordField();
        break;
      case AuthProviders.PHONE:
        await _submitPhoneNumber();
        body = buildPhoneField();
        break;
    }
    setState(() {});
  }
}
