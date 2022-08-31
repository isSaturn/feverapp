import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../constants.dart';
import '../../main.dart';

class SettingsScreen extends StatefulWidget {
  final User user;

  const SettingsScreen({Key key, @required this.user}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState(user);
}

class _SettingsScreenState extends State<SettingsScreen> {
  User user;

  _SettingsScreenState(this.user);

  bool showMe, newMatches, messages, superLikes, topPicks;

  String radius, gender, prefGender;

  @override
  void initState() {
    showMe = user.showMe;
    newMatches = user.settings.pushNewMatchesEnabled;
    messages = user.settings.pushNewMessages;
    superLikes = user.settings.pushSuperLikesEnabled;
    topPicks = user.settings.pushTopPicksEnabled;
    radius = user.settings.distanceRadius;
    gender = user.settings.gender;
    prefGender = user.settings.genderPreference;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
        backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
        brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
        centerTitle: true,
        title: Text(
          'Cài đặt',
          style: TextStyle(
              color: isDarkMode(context) ? Colors.white : Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Builder(
            builder: (buildContext) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0, left: 16, top: 16, bottom: 8),
                      child: Text(
                        'Khám phá',
                        style: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.white54
                                : Colors.black54,
                            fontSize: 18),
                      ),
                    ),
                    Material(
                      elevation: 2,
                      color:
                          isDarkMode(context) ? Colors.black12 : Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SwitchListTile.adaptive(
                              activeColor: Color(COLOR_ACCENT),
                              title: Text(
                                'Hiển thị tôi trên ứng dụng',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: isDarkMode(context)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              value: showMe,
                              onChanged: (bool newValue) {
                                showMe = newValue;
                                setState(() {});
                              }),
                          ListTile(
                            title: Text(
                              'Phạm vi tương thích',
                              style: TextStyle(
                                fontSize: 17,
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: _onDistanceRadiusClick,
                              child: Text(
                                  user.settings.distanceRadius.isNotEmpty
                                      ? '$radius '
                                          'Km'
                                      : 'Vô hạn',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold)),
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
                              onTap: _onGenderClick,
                              child: Text('$gender',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: isDarkMode(context)
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold)),
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
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0, bottom: 16),
                      child: ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: Material(
                          elevation: 2,
                          color: isDarkMode(context)
                              ? Colors.black12
                              : Colors.white,
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(12.0),
                            onPressed: () async {
                              showProgress(context, 'Lưu thay đổi...', true);
                              user.settings.genderPreference = prefGender;
                              user.settings.gender = gender;
                              user.settings.showMe = showMe;
                              user.showMe = showMe;
                              user.settings.pushTopPicksEnabled = topPicks;
                              user.settings.pushNewMessages = messages;
                              user.settings.pushSuperLikesEnabled = superLikes;
                              user.settings.pushNewMatchesEnabled = newMatches;
                              user.settings.distanceRadius = radius;
                              User updateUser = await FireStoreUtils()
                                  .updateCurrentUser(user, context);
                              hideProgress();
                              if (updateUser != null) {
                                this.user = updateUser;
                                MyAppState.currentUser = user;
                                Scaffold.of(buildContext).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                      'Cài đặt đã lưu thành công',
                                      style: TextStyle(fontSize: 17),
                                    )));
                              }
                            },
                            child: Text(
                              'Lưu',
                              style: TextStyle(
                                  fontSize: 18, color: Color(COLOR_PRIMARY)),
                            ),
                            color: isDarkMode(context)
                                ? Colors.black12
                                : Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
      ),
    );
  }

  _onDistanceRadiusClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Bán kính khoảng cách",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("5Km"),
          isDefaultAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '5';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("10Km"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '10';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("15Km"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '15';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("20Km"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '20';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("25Km"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '25';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("50Km"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '50';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("100Km"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '100';
            setState(() {});
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Vô hạn"),
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
            radius = '';
            setState(() {});
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Hủy bỏ"),
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
        child: Text("Hủy bỏ"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
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
        child: Text("Hủy bỏ"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
}
