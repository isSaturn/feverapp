import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants.dart';
import '../../main.dart';

class AccountDetailsScreen extends StatefulWidget {
  final User user;

  AccountDetailsScreen({Key key, @required this.user}) : super(key: key);

  @override
  _AccountDetailsScreenState createState() {
    return _AccountDetailsScreenState(user);
  }
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  User user;
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String firstName,
      lastName,
      age,
      bio,
      email,
      mobile,
      relationshipStatus,
      denominationView,
      zodiac,
      seeking,
      willingToRelocate;

  _AccountDetailsScreenState(this.user);
  @override
  void initState() {
    relationshipStatus = user.relationshipStatus;
    denominationView = user.denominationalViews;
    zodiac = user.zodiac;
    seeking = user.seeking;
    willingToRelocate = user.willingToRelocate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
          brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
          centerTitle: true,
          iconTheme: IconThemeData(
              color: isDarkMode(context) ? Colors.white : Colors.black),
          title: Text(
            'Chỉnh sửa hồ sơ',
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
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, bottom: 8, top: 24),
                            child: Text(
                              'PUBLIC INFO',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
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
                                                BoxConstraints(maxWidth: 100),
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
                                                BoxConstraints(maxWidth: 100),
                                            child: TextFormField(
                                              onSaved: (String val) {
                                                age = val;
                                              },
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
                                              textCapitalization:
                                                  TextCapitalization.words,
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
                                              child: Text(relationshipStatus,
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
                                              child: Text('$denominationView',
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
                                              child: Text('$zodiac',
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
                                              child: Text(seeking,
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
                                              child: Text(willingToRelocate,
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
                                      ]).toList())),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16, bottom: 8, top: 24),
                            child: Text(
                              'PRIVATE DETAILS',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
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
                                          onSaved: (String val) {
                                            email = val;
                                          },
                                          validator: validateEmail,
                                          textInputAction: TextInputAction.next,
                                          initialValue: user.email,
                                          textAlign: TextAlign.end,
                                          enabled: false,
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
                                          textInputAction: TextInputAction.done,
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
                                                  EdgeInsets.only(bottom: 2)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ).toList()),
                          ),
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
                                      'Lưu',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(COLOR_PRIMARY)),
                                    ),
                                  ),
                                ),
                              )),
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
                            'Inorder to change your email, you must type your password first',
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
      }
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
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
          child: Text("Không"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            willingToRelocate = 'Không';
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
          child: Text("Cần thảo luận"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            willingToRelocate = 'Cần thảo luận';
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
    user.phoneNumber = mobile;
    var updatedUser = await FireStoreUtils().updateCurrentUser(user, context);
    if (updatedUser != null) {
      MyAppState.currentUser = user;
      Scaffold.of(buildContext).showSnackBar(SnackBar(
          content: Text(
        'Details saved successfuly',
        style: TextStyle(fontSize: 17),
      )));
    } else {
      Scaffold.of(buildContext).showSnackBar(SnackBar(
          content: Text(
        'Couldn\'t save details, Please try again.',
        style: TextStyle(fontSize: 17),
      )));
    }
  }
}
