import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/main.dart';
import 'package:dating/model/User.dart' as user;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../constants.dart';

String validateName(String value) {
  String patttern =
      r'(^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s\W|_ ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Yêu cầu điền tên";
  } else if (!regExp.hasMatch(value)) {
    return "Tên chỉ chứa ký tự a-z và A-Z";
  } else if (value.length < 2) {
    return "Đặt tên ít nhất 2 ký tự";
  }
  return null;
}

String validateAge(String value) {
  String pattern = r'^[0-9]+$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Vui lòng nhập tuổi';
  } else if (!regExp.hasMatch(value)) {
    return 'Tuổi chỉ chứa số';
  }
  return null;
}

String validateBio(String value) {
  String pattern =
      r'(^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ\s\W|_ ]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Vui lòng nhập đủ thông tin';
  }
  return null;
}

String validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Vui lòng nhập SDT';
  } else if (!regExp.hasMatch(value)) {
    return 'Vui lòng nhập SDT hợp lệ';
  }
  return null;
}

String validatePassword(String value) {
  if (value.length < 6)
    return 'Mật khẩu phải ít nhất 5 ký tự';
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  if (value.isEmpty) {
    return ("Vui lòng điền Email");
  }
  // reg expression for email validation
  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
    return ("Vui lòng nhập đúng Email");
  }
  if (!RegExp("@vanlanguni.vn").hasMatch(value)) {
    return ("Tên miền bắt buộc là @vanlanguni.vn");
  }
  return null;
}

String validateConfirmPassword(String password, String confirmPassword) {
  if (password != confirmPassword) {
    return 'Mật khẩu không khớp';
  } else if (confirmPassword.length == 0) {
    return 'Xác nhận mật khẩu là bắt buộc';
  } else {
    return null;
  }
}

//helper method to show progress
ProgressDialog progressDialog;

showProgress(BuildContext context, String message, bool isDismissible) async {
  progressDialog = ProgressDialog(context,
      type: ProgressDialogType.Normal, isDismissible: isDismissible);
  progressDialog.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Color(COLOR_PRIMARY),
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          )),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
          color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600));

  await progressDialog.show();
}

updateProgress(String message) {
  progressDialog.update(message: message);
}

hideProgress() async {
  await progressDialog.hide();
}

//helper method to show alert dialog
showAlertDialog(BuildContext context, String title, String content) {
  // set up the AlertDialog
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => destination));
}

push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(new MaterialPageRoute(builder: (context) => destination));
}

pushAndRemoveUntil(BuildContext context, Widget destination, bool predict) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
      (Route<dynamic> route) => predict);
}

String formatTimestamp(int timestamp) {
  var format = new DateFormat('hh:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return format.format(date);
}

String setLastSeen(int seconds) {
  var format = DateFormat('hh:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  var diff = DateTime.now().millisecondsSinceEpoch - (seconds * 1000);
  if (diff < 24 * HOUR_MILLIS) {
    return format.format(date);
  } else if (diff < 48 * HOUR_MILLIS) {
    return 'Yesterday at ${format.format(date)}';
  } else {
    format = DateFormat('MMM d');
    return '${format.format(date)}';
  }
}

Widget displayCircleImage(String picUrl, double size, hasBorder) =>
    CachedNetworkImage(
        imageBuilder: (context, imageProvider) =>
            _getCircularImageProvider(imageProvider, size, false),
        imageUrl: picUrl,
        placeholder: (context, url) =>
            _getPlaceholderOrErrorImage(size, hasBorder),
        errorWidget: (context, url, error) =>
            _getPlaceholderOrErrorImage(size, hasBorder));

Widget _getPlaceholderOrErrorImage(double size, hasBorder) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        borderRadius: new BorderRadius.all(new Radius.circular(size / 2)),
        border: new Border.all(
          color: Colors.white,
          width: hasBorder ? 2.0 : 0.0,
        ),
      ),
      child: ClipOval(
          child: Image.asset(
        'assets/images/placeholder.jpg',
        fit: BoxFit.cover,
        height: size,
        width: size,
      )),
    );

Widget _getCircularImageProvider(
    ImageProvider provider, double size, bool hasBorder) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xff7c94b6),
      borderRadius: new BorderRadius.all(new Radius.circular(size / 2)),
      border: new Border.all(
        color: Colors.white,
        width: hasBorder ? 2.0 : 0.0,
      ),
    ),
    child: ClipOval(
        child: FadeInImage(
            fit: BoxFit.cover,
            placeholder: Image.asset(
              'assets/images/placeholder.jpg',
              fit: BoxFit.cover,
              height: size,
              width: size,
            ).image,
            image: provider)),
  );
}

bool isDarkMode(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.light) {
    return false;
  } else {
    return true;
  }
}

Future<LocationData> getCurrentLocation() async {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  return await location.getLocation();
}

bool isInPreferredDistance(double distance) {
  if (MyAppState.currentUser.settings.distanceRadius.isNotEmpty) {
    if (distance <=
        int.tryParse(MyAppState.currentUser.settings.distanceRadius)) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

bool isPreferredGender(String gender) {
  if (MyAppState.currentUser.settings.genderPreference != 'All') {
    return gender == MyAppState.currentUser.settings.genderPreference;
  } else {
    return true;
  }
}

double getDistance(user.Location userLocation, user.Location myLocation) {
  final Distance distance = new Distance();
  final double milesAway = distance.as(
      LengthUnit.Mile,
      new LatLng(userLocation.latitude, userLocation.longitude),
      new LatLng(myLocation.latitude, myLocation.longitude));
  return milesAway;
}

skipNulls<Widget>(List<Widget> items) {
  return items..removeWhere((item) => item == null);
}

String audioMessageTime(Duration audioDuration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitsHours(int n) {
    if (n >= 10) return "$n:";
    if (n == 0) return '';
    return "0$n:";
  }

  String twoDigitMinutes = twoDigits(audioDuration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(audioDuration.inSeconds.remainder(60));
  return "${twoDigitsHours(audioDuration.inHours)}$twoDigitMinutes:$twoDigitSeconds";
}

String updateTime(Timer timer) {
  Duration callDuration = Duration(seconds: timer.tick);
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitsHours(int n) {
    if (n >= 10) return "$n:";
    if (n == 0) return '';
    return "0$n:";
  }

  String twoDigitMinutes = twoDigits(callDuration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(callDuration.inSeconds.remainder(60));
  return "${twoDigitsHours(callDuration.inHours)}$twoDigitMinutes:$twoDigitSeconds";
}
