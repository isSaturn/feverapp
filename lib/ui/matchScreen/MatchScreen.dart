import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/ConversationModel.dart';
import 'package:dating/model/HomeConversationModel.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/chat/ChatScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MatchScreen extends StatefulWidget {
  final User matchedUser;

  MatchScreen({Key key, this.matchedUser}) : super(key: key);

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final FireStoreUtils _fireStoreUtils = FireStoreUtils();

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Material(
      child: Stack(fit: StackFit.expand, children: <Widget>[
        CachedNetworkImage(
          imageUrl: widget.matchedUser.profilePictureURL,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Column(
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    SystemChrome.setEnabledSystemUIOverlays(
                        [SystemUiOverlay.bottom, SystemUiOverlay.top]);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'TIẾP TỤC QUẸT',
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            isDarkMode(context) ? Colors.black : Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                    child: Text('GỬI TIN NHẮN NGAY',
                        style: TextStyle(
                            fontSize: 17,
                            color: isDarkMode(context)
                                ? Colors.black
                                : Colors.white)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide.none),
                    onPressed: () async {
                      String channelID;
                      if (widget.matchedUser.userID
                              .compareTo(MyAppState.currentUser.userID) <
                          0) {
                        channelID = widget.matchedUser.userID +
                            MyAppState.currentUser.userID;
                      } else {
                        channelID = MyAppState.currentUser.userID +
                            widget.matchedUser.userID;
                      }
                      ConversationModel conversationModel =
                          await _fireStoreUtils.getChannelByIdOrNull(channelID);
                      pushReplacement(
                          context,
                          ChatScreen(
                              homeConversationModel: HomeConversationModel(
                                  isGroupChat: false,
                                  members: [widget.matchedUser],
                                  conversationModel: conversationModel)));
                    },
                    color: Color(COLOR_PRIMARY),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 60.0, horizontal: 16),
                child: Text(
                  'TƯƠNG HỢP THÀNH CÔNG',
                  style: TextStyle(
                    letterSpacing: 4,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
