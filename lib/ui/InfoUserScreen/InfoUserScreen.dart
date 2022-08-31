import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/home/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../constants.dart';
import '../../main.dart';

class InfoUserScreen extends StatefulWidget {
  final User user;

  InfoUserScreen({Key key, this.user}) : super(key: key);

  @override
  State<InfoUserScreen> createState() => _InfoUserScreenState(user);
}

class _InfoUserScreenState extends State<InfoUserScreen> {
  User user;
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String radius, gender, prefGender;
  String firstName,
      lastName,
      age,
      bio,
      email,
      mobile,
      relationshipStatus,
      denominationView,
      zodiac,
      majors,
      seeking,
      willingToRelocate;

  _InfoUserScreenState(this.user);
  @override
  void initState() {
    relationshipStatus = user.relationshipStatus;
    denominationView = user.denominationalViews;
    zodiac = user.zodiac;
    majors = user.majors;
    seeking = user.seeking;
    willingToRelocate = user.willingToRelocate;
    gender = user.settings.gender;
    prefGender = user.settings.genderPreference;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
          brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
          centerTitle: true,
          iconTheme: IconThemeData(
              color: isDarkMode(context) ? Colors.white : Colors.black),
          title: Text(
            'Thông tin của bạn',
            style: TextStyle(
                color: isDarkMode(context) ? Colors.white : Colors.black),
          ),
        ),
        body: Builder(
            builder: (buildContext) => SingleChildScrollView(
                  child: Form(
                    key: _key,
                    autovalidateMode: _validate,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Material(
                              elevation: 2,
                              color: isDarkMode(context)
                                  ? Colors.black12
                                  : Colors.white,
                              child: ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: ListTile.divideTiles(
                                      context: buildContext,
                                      tiles: [
                                        ListTile(
                                          title: Text(
                                            'Họ',
                                            style: TextStyle(
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          trailing: ConstrainedBox(
                                            constraints:
                                                BoxConstraints(maxWidth: 100),
                                            child: TextFormField(
                                              onSaved: (String val) {
                                                firstName = val;
                                              },
                                              validator: validateName,
                                              textInputAction:
                                                  TextInputAction.next,
                                              textAlign: TextAlign.end,
                                              initialValue: user.firstName,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: isDarkMode(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                              cursorColor: Color(COLOR_ACCENT),
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Họ',
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Tên',
                                            style: TextStyle(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          trailing: ConstrainedBox(
                                            constraints:
                                                BoxConstraints(maxWidth: 200),
                                            child: TextFormField(
                                              onSaved: (String val) {
                                                lastName = val;
                                              },
                                              validator: validateName,
                                              textInputAction:
                                                  TextInputAction.next,
                                              textAlign: TextAlign.end,
                                              initialValue: user.lastName,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: isDarkMode(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                              cursorColor: Color(COLOR_ACCENT),
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Tên',
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Tuổi',
                                            style: TextStyle(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          trailing: ConstrainedBox(
                                            constraints:
                                                BoxConstraints(maxWidth: 200),
                                            child: TextFormField(
                                              onSaved: (String val) {
                                                age = val;
                                              },
                                              validator: validateAge,
                                              textInputAction:
                                                  TextInputAction.next,
                                              textAlign: TextAlign.end,
                                              initialValue: user.age,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: isDarkMode(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                              cursorColor: Color(COLOR_ACCENT),
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Tuổi',
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Bio',
                                            style: TextStyle(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          trailing: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5),
                                            child: TextFormField(
                                              validator: validateBio,
                                              onSaved: (String val) {
                                                bio = val;
                                              },
                                              initialValue: user.bio,
                                              minLines: 1,
                                              maxLines: 3,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: isDarkMode(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                              cursorColor: Color(COLOR_ACCENT),
                                              keyboardType:
                                                  TextInputType.multiline,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Bio',
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Tình trạng hôn nhân',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: _onGenderClick,
                                            child: Container(
                                              width: 180,
                                              child: Text(
                                                  relationshipStatus != null
                                                      ? relationshipStatus
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: isDarkMode(context)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Tôn giáo',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: _onDenominationViewClick,
                                            child: Container(
                                              width: 180,
                                              child: Text(
                                                  denominationView != null
                                                      ? denominationView
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: isDarkMode(context)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Cung hoàng đạo',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: _onchurchInvolvmentClick,
                                            child: Container(
                                              width: 180,
                                              child: Text(
                                                  zodiac != null ? zodiac : '',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: isDarkMode(context)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Ngành học',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: _onMajors,
                                            child: Container(
                                              width: 180,
                                              child: Text(
                                                  majors != null ? majors : '',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: isDarkMode(context)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Tìm kiếm mối quan hệ',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: _onSeekingClick,
                                            child: Container(
                                              width: 180,
                                              child: Text(
                                                  seeking != null
                                                      ? seeking
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: isDarkMode(context)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Sẵn sàng cho một mối quan hệ lâu dài',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: _onWillingClick,
                                            child: Container(
                                              width: 180,
                                              child: Text(
                                                  willingToRelocate != null
                                                      ? willingToRelocate
                                                      : '',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: isDarkMode(context)
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Tài khoản',
                                            style: TextStyle(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          trailing: ConstrainedBox(
                                            constraints:
                                                BoxConstraints(maxWidth: 200),
                                            child: TextFormField(
                                              enabled: false,
                                              onSaved: (String val) {
                                                email = val;
                                              },
                                              validator: validateEmail,
                                              textInputAction:
                                                  TextInputAction.next,
                                              initialValue: user.email,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: isDarkMode(context)
                                                      ? Colors.grey
                                                      : Colors.grey),
                                              cursorColor: Color(COLOR_ACCENT),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Tài khoản',
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'SDT',
                                            style: TextStyle(
                                                color: isDarkMode(context)
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                          trailing: ConstrainedBox(
                                            constraints:
                                                BoxConstraints(maxWidth: 150),
                                            child: TextFormField(
                                              onSaved: (String val) {
                                                mobile = val;
                                              },
                                              validator: validateMobile,
                                              textInputAction:
                                                  TextInputAction.done,
                                              initialValue: user.phoneNumber,
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: isDarkMode(context)
                                                      ? Colors.white
                                                      : Colors.black),
                                              cursorColor: Color(COLOR_ACCENT),
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: '.',
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          bottom: 2)),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Giới tính',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: _onMyGenderClick,
                                            child: Text('$gender',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: isDarkMode(context)
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            'Bạn đang tìm kiếm',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: isDarkMode(context)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: _onGenderPrefClick,
                                            child: Text('$prefGender',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: isDarkMode(context)
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        )
                                      ]).toList())),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 32.0, bottom: 16),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                  minWidth: double.infinity),
                              child: Material(
                                elevation: 2,
                                color: isDarkMode(context)
                                    ? Colors.black12
                                    : Colors.white,
                                child: CupertinoButton(
                                  padding: const EdgeInsets.all(12.0),
                                  onPressed: () async {
                                    _validateAndSave(buildContext);
                                  },
                                  child: Text(
                                    'Hoàn tất đăng ký',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Color(COLOR_PRIMARY)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                )));
  }

  _validateAndSave(BuildContext buildContext) async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      if (user.email != email) {
        TextEditingController _passwordController = new TextEditingController();
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Để thay đổi email của bạn, trước tiên bạn phải nhập mật khẩu của mình',
                            style: TextStyle(color: Colors.red, fontSize: 17),
                            textAlign: TextAlign.start,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(hintText: 'Password'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: RaisedButton(
                              color: Color(COLOR_ACCENT),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              onPressed: () async {
                                if (_passwordController.text.isEmpty) {
                                  showAlertDialog(context, "Empty Password",
                                      "Password is required to update email");
                                } else {
                                  Navigator.pop(context);
                                  showProgress(context, 'Verifying...', false);
                                  auth.UserCredential result = await auth
                                      .FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: 'test@user2.com',
                                          password: _passwordController.text)
                                      .catchError((onError) {
                                    hideProgress();
                                    showAlertDialog(context, 'Couldn\'t verify',
                                        'Please double check the password and try again.');
                                  });
                                  _passwordController.dispose();
                                  if (result.user != null) {
                                    await result.user.updateEmail(email);
                                    updateProgress('Saving details...');
                                    await _updateUser(buildContext);
                                    hideProgress();
                                  } else {
                                    hideProgress();
                                    Scaffold.of(buildContext)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      'Couldn\'t verify, Please try again.',
                                      style: TextStyle(fontSize: 17),
                                    )));
                                  }
                                }
                              },
                              child: Text(
                                'Verify',
                                style: TextStyle(
                                    color: isDarkMode(context)
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ),
                          )
                        ],
                      )),
                ));
      } else {
        showProgress(context, "Saving details...", false);
        await _updateUser(buildContext);
        hideProgress();
        pushAndRemoveUntil(context, HomeScreen(user: user), false);
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  _onGenderPrefClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Gender Preference",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Nữ"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            prefGender = 'Nữ';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Nam"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            prefGender = 'Nam';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Tất cả"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            prefGender = 'Tất cả';
            setState(() {});
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

  _onMyGenderClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Gender",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Nam"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            gender = 'Nam';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Nữ"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            gender = 'Nữ';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Khác"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            gender = 'Khác';
            setState(() {});
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

  _onGenderClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Tình trạng hôn nhân",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Độc thân"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            relationshipStatus = 'Độc thân';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Đã ly hôn"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            relationshipStatus = 'Đã ly hôn';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Đã cưới"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            relationshipStatus = 'Đã cưới';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Góa"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            relationshipStatus = 'Góa';
            setState(() {});
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

  _onDenominationViewClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Tôn giáo",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Đạo Chúa"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            denominationView = 'Đạo Chúa';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Đạo Phật"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            denominationView = 'Đạo Phật';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Đạo Nho Giáo"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            denominationView = 'Đạo Nho Giáo';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Đạo Hồi"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            denominationView = 'Đạo Hồi';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Không có"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            denominationView = 'Không có';
            setState(() {});
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

  _onMajors() {
    final action = CupertinoActionSheet(
      message: Text(
        "Ngành học",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Khoa học môi trường"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Khoa học môi trường';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quản lý Tài nguyên và Môi trường"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quản lý Tài nguyên và Môi trường';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Mỹ thuật ứng dụng"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Mỹ thuật ứng dụng';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quản trị Dịch vụ Du lịch Lữ Hành"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quản trị Dịch vụ Du lịch Lữ Hành';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Thiết kế Công nghiệp"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Thiết kế Công nghiệp';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Thiết kế Đồ họa"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Thiết kế Đồ họa';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Thiết kế Nội thất"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Thiết kế Nội thất';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Thiết kế Thời trang"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Thiết kế Thời trang';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Ngôn ngữ Anh"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Ngôn ngữ Anh';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quản trị Kinh doanh"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quản trị Kinh doanh';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kinh doanh Thương mại"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Kinh doanh Thương mại';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kế toán"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Kế toán';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Tài chính Ngân hàng"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Tài chính Ngân hàng';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kỹ thuật phần mềm"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Kỹ thuật phần mềm';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Công nghệ Thông tin"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Công nghệ Thông tin';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quản trị Dịch vụ Du lịch và Lữ hành"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quản trị Dịch vụ Du lịch và Lữ hành';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quản trị Khách sạn"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quản trị Khách sạn';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quan hệ Công chúng"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quan hệ Công chúng';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Văn học"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Văn học';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kỹ thuật Nhiệt"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Kỹ thuật Nhiệt';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Công nghệ Kỹ thuật Ô tô"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Công nghệ Kỹ thuật Ô tô';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Công nghệ Kỹ thuật Môi trường"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Công nghệ Kỹ thuật Môi trường';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kỹ thuật xây dựng"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Kỹ thuật xây dựng';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kỹ thuật Xây dựng Công trình giao thông"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Kỹ thuật Xây dựng Công trình giao thông';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quản lý xây dựng"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quản lý xây dựng';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kiến trúc"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Kiến trúc';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Luật Kinh tế"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Luật Kinh tế';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Luật"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Luật';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Piano"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Piano';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Thanh nhạc"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Thanh nhạc';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Đông phương học"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Đông phương học';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Điều dưỡng"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Điều dưỡng';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kỹ thuật Xét nghiệm Y học"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Kỹ thuật Xét nghiệm Y học';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Dược học"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Dược học';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Tâm lý học"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Tâm lý học';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Marketing"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Marketing';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Công nghệ Sinh học Y dược"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Công nghệ Sinh học Y dược';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Công nghệ Sinh học"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Công nghệ Sinh học';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quản trị Môi trường Doanh nghiệp"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quản trị Môi trường Doanh nghiệp';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Nông nghiệp Công nghệ cao"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Nông nghiệp Công nghệ cao';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Công nghệ Kỹ thuật Điện - Điện tử"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Công nghệ Kỹ thuật Điện - Điện tử';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Công tác Xã hội"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Công tác Xã hội';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Khoa học Dữ liệu"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Khoa học Dữ liệu';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kỹ thuật Cơ - Điện tử"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Kỹ thuật Cơ - Điện tử';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Logistics và Quản lý chuỗi cung ứng"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Logistics và Quản lý chuỗi cung ứng';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quản trị Nhà hàng và Dịch vụ Ăn uống"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quản trị Nhà hàng và Dịch vụ Ăn uống';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Bất động sản"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Bất động sản';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Ngôn ngữ Trung Quốc"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Ngôn ngữ Trung Quốc';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Răng - Hàm - Mặt"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Răng - Hàm - Mặt';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Công nghệ Thực phẩm"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Công nghệ Thực phẩm';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Đạo diễn Điện ảnh - Truyền hình"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Đạo diễn Điện ảnh - Truyền hình';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Diễn viên Kịch - Điện ảnh - Truyền hình"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Diễn viên Kịch - Điện ảnh - Truyền hình';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Thiết kế xanh"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Thiết kế xanh';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Việt Nam học"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Việt Nam học';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Thiết kế Mỹ thuật số"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Thiết kế Mỹ thuật số';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Ngôn ngữ Hàn Quốc"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Ngôn ngữ Hàn Quốc';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Công nghệ Thẩm mỹ"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Công nghệ Thẩm mỹ';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Ngành Truyền thông đa phương tiện"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Ngành Truyền thông đa phương tiện';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Ngành Thương mại điện tử"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Ngành Thương mại điện tử';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Ngành Kinh doanh Quốc tế"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Ngành Kinh doanh Quốc tế';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Ngành Kinh tế Quốc tế"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Ngành Kinh tế Quốc tế';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Bảo hộ Lao động"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Bảo hộ Lao động';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Quản lý Công nghiệp"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Quản lý Công nghiệp';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Hệ thống thông tin Quản lý"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Hệ thống thông tin Quản lý';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Du lịch"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            majors = 'Du lịch';
            setState(() {});
          },
        ),
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

  _onchurchInvolvmentClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Cung hoàng đạo",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Bạch Dương"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Bạch Dương';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kim Ngưu"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Kim Ngưu';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Song Tử"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Song Tử';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Cự Giải"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Cự Giải';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Sư Tử"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Sư Tử';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Xử Nữ"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Xử Nữ';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Thiên Bình"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Thiên Bình';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Bò Cạp"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Bò Cạp';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Nhân Mã"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Nhân Mã';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Ma Kết"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Ma Kết';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Bảo Bình"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Bảo Bình';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Song Ngư"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            zodiac = 'Song Ngư';
            setState(() {});
          },
        ),
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

  _onSeekingClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Tìm kiếm mối quan hệ",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Kết bạn"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            seeking = 'Kết bạn';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Lâu dài"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            seeking = 'Lâu dài';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Để kết hôn"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            seeking = 'Để kết hôn';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Kết hôn và sinh con"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            seeking = 'Kết hôn và sinh con';
            setState(() {});
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

  _onWillingClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Sẵn sàng cho một mối quan hệ lâu dài",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Có"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            willingToRelocate = 'Có';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Chưa cần"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            willingToRelocate = 'Chưa cần';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Nếu gặp đúng người"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            willingToRelocate = 'Nếu gặp đúng người';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Cần suy nghĩ"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            willingToRelocate = 'Cần suy nghĩ';
            setState(() {});
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

  _updateUser(BuildContext buildContext) async {
    user.firstName = firstName;
    user.lastName = lastName;
    user.age = age;
    user.bio = bio;
    user.email = email;
    user.relationshipStatus = relationshipStatus;
    user.denominationalViews = denominationView;
    user.seeking = seeking;
    user.willingToRelocate = willingToRelocate;
    user.zodiac = zodiac;
    user.majors = majors;
    user.phoneNumber = mobile;
    user.settings.genderPreference = prefGender;
    user.settings.gender = gender;
    var updatedUser = await FireStoreUtils().updateCurrentUser(user, context);
    if (updatedUser != null) {
      MyAppState.currentUser = user;
      Scaffold.of(buildContext).showSnackBar(SnackBar(
          content: Text(
        'Thông tin chi tiết đã được lưu thành công',
        style: TextStyle(fontSize: 17),
      )));
    } else {
      Scaffold.of(buildContext).showSnackBar(SnackBar(
          content: Text(
        'Không thể lưu chi tiết, Vui lòng thử lại.',
        style: TextStyle(fontSize: 17),
      )));
    }
  }
}
