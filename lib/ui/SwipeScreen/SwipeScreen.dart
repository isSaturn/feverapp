import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/CustomFlutterTinderCard.dart';
import 'package:dating/constants.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/matchScreen/MatchScreen.dart';
import 'package:dating/ui/userDetailsScreen/UserDetailsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipeScreen extends StatefulWidget {
  final User user;

  const SwipeScreen({Key key, this.user}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _SwipeScreenState createState() => _SwipeScreenState(user);
}

class _SwipeScreenState extends State<SwipeScreen> {
  final User user;
  final FireStoreUtils _fireStoreUtils = FireStoreUtils();
  Stream<List<User>> tinderUsers;
  List<User> swipedUsers = [];
  List<User> users = [];
  CardController controller;
  TextEditingController reportTextController = TextEditingController();

  _SwipeScreenState(this.user);

  @override
  void initState() {
    super.initState();
    _fireStoreUtils.matchChecker(context);
    tinderUsers = _fireStoreUtils.getTinderUsers();
  }

  @override
  void dispose() {
    _fireStoreUtils.closeTinderStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: tinderUsers,
      initialData: [],
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(COLOR_ACCENT)),
              ),
            );
          case ConnectionState.active:
            return _asyncCards(context, snapshot.data);
          case ConnectionState.done:
        }
        return null; // unreachable
      },
    );
  }

  Widget _buildCard(User tinderUser) {
    return GestureDetector(
      onTap: () async {
        _launchDetailsScreen(tinderUser);
      },
      child: Card(
        // ignore: sort_child_properties_last
        child: Stack(
          children: <Widget>[
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: tinderUser.profilePictureURL == DEFAULT_AVATAR_URL
                      ? ''
                      : tinderUser.profilePictureURL,
                  placeholder: (context, imageUrl) {
                    return Icon(
                      Icons.account_circle,
                      size: MediaQuery.of(context).size.height * .5,
                      color: isDarkMode(context) ? Colors.black : Colors.white,
                    );
                  },
                  errorWidget: (context, imageUrl, error) {
                    return Icon(
                      Icons.account_circle,
                      size: MediaQuery.of(context).size.height * .5,
                      color: isDarkMode(context) ? Colors.black : Colors.white,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              right: 5,
              child: IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                iconSize: 30,
                onPressed: () => _onCardSettingsClick(tinderUser),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      tinderUser.age.isEmpty
                          ? '${tinderUser.fullName()}'
                          : '${tinderUser.fullName()}, ${tinderUser.age}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '${tinderUser.milesAway}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(25),
        ),
        color: Color(COLOR_PRIMARY),
      ),
    );
  }

  Future<void> _launchDetailsScreen(User tinderUser) async {
    CardSwipeOrientation result = await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) => UserDetailsScreen(
          user: tinderUser,
          isMatch: false,
        ),
      ),
    );
  }

  _onCardSettingsClick(User user) {
    final action = CupertinoActionSheet(
      message: Text(
        user.fullName(),
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Report user"),
          onPressed: () {
            Navigator.pop(context);
            _showSingleChoiceDialog(context, user);
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          "Cancel",
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  _showAlertDialog(BuildContext context, String title, String message) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _onReportedClick(User user) async {
    Navigator.pop(context);
    showProgress(context, 'Reporting user...', false);
    bool isSuccessful = await _fireStoreUtils.reportUser(
      user,
      reportTextController.text,
      'reporting',
    );
    reportTextController.clear();
    if (isSuccessful) {
      Navigator.pop(context);
      _showAlertDialog(
          context, 'REPORTED', 'Đã tố cáo ${user.fullName()} thành công.');
    } else {
      _showAlertDialog(
          context,
          'Report',
          'Couldn'
              '\'t report ${user.fullName()}, please try again later.');
    }
  }

  _showSingleChoiceDialog(BuildContext context, User user) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Tố cáo ' + user.fullName(),
            ),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: reportTextController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Ghi báo cáo tại đây',
                          icon: Icon(Icons.note_add)),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text("HỦY"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("BÁO CÁO"),
                onPressed: () async {
                  _onReportedClick(user);
                },
              ),
            ],
          );
        },
      );

  Widget _asyncCards(BuildContext context, List<User> data) {
    users = data;
    if (data == null || data.isEmpty)
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Không có ai xung quanh bạn. Hãy thử tăng bán kính khoảng cách để nhận được nhiều đề xuất hơn.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Stack(children: [
              Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'There’s no one around you. Try increasing '
                      'the distance radius to get more recommendations.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: TinderSwapCard(
                  animDuration: 500,
                  orientation: AmassOrientation.BOTTOM,
                  totalNum: data.length,
                  stackNum: 3,
                  swipeEdge: 15,
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  minHeight: MediaQuery.of(context).size.height * 0.9,
                  cardBuilder: (context, index) => _buildCard(data[index]),
                  cardController: controller = CardController(),
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) async {
                    if (orientation == CardSwipeOrientation.LEFT ||
                        orientation == CardSwipeOrientation.RIGHT) {
                      if (orientation == CardSwipeOrientation.RIGHT) {
                        User result =
                            await _fireStoreUtils.onSwipeRight(data[index]);
                        if (result != null) {
                          data.removeAt(index);
                          _fireStoreUtils.updateCardStream(data);
                          push(context, MatchScreen(matchedUser: result));
                        } else {
                          swipedUsers.add(data[index]);
                          data.removeAt(index);
                          _fireStoreUtils.updateCardStream(data);
                        }
                      } else if (orientation == CardSwipeOrientation.LEFT) {
                        swipedUsers.add(data[index]);
                        await _fireStoreUtils.onSwipeLeft(data[index]);
                        data.removeAt(index);
                        _fireStoreUtils.updateCardStream(data);
                      }
                    } else {
                      User returningUser = data.removeAt(index);
                      _fireStoreUtils.updateCardStream(data);
                      await Future.delayed(Duration(milliseconds: 200));
                      data.insert(0, returningUser);
                      _fireStoreUtils.updateCardStream(data);
                    }
                  },
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        // changes position of shadow
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    elevation: 1,
                    heroTag: 'left',
                    onPressed: () {
                      controller.triggerLeft();
                    },
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  width: 58.0,
                  height: 58.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        // changes position of shadow
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    elevation: 1,
                    heroTag: 'center',
                    onPressed: () {
                      controller.triggerRight();
                    },
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.star,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
                Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        // changes position of shadow
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    elevation: 1,
                    heroTag: 'right',
                    onPressed: () {
                      controller.triggerRight();
                    },
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          )
        ]);
  }
}
