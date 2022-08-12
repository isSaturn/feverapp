import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating/constants.dart';
import 'package:dating/main.dart';
import 'package:dating/model/ChatModel.dart';
import 'package:dating/model/ChatVideoContainer.dart';
import 'package:dating/model/ConversationModel.dart';
import 'package:dating/model/HomeConversationModel.dart';
import 'package:dating/model/MessageData.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/FirebaseHelper.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/fullScreenImageViewer/FullScreenImageViewer.dart';
import 'package:dating/ui/fullScreenVideoViewer/FullScreenVideoViewer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum RecordingState { HIDDEN, VISIBLE, Recording }

enum Product { Apple, Samsung, Oppo, Redmi }

class ChatScreen extends StatefulWidget {
  final HomeConversationModel homeConversationModel;

  const ChatScreen({Key key, @required this.homeConversationModel})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(homeConversationModel);
}

class _ChatScreenState extends State<ChatScreen> {
  ImagePicker _imagePicker = ImagePicker();
  HomeConversationModel homeConversationModel;
  TextEditingController _messageController = new TextEditingController();
  FireStoreUtils _fireStoreUtils = FireStoreUtils();
  TextEditingController _groupNameController = TextEditingController();
  RecordingState currentRecordingState = RecordingState.HIDDEN;
  TextEditingController reportTextController = new TextEditingController();

  String tempPathForAudioMessages;

  _ChatScreenState(this.homeConversationModel);

  Stream<ChatModel> chatStream;

  @override
  void initState() {
    super.initState();
    if (homeConversationModel.isGroupChat)
      _groupNameController.text = homeConversationModel.conversationModel.name;
    setupStream();
  }

  setupStream() {
    chatStream = _fireStoreUtils
        .getChatMessages(homeConversationModel)
        .asBroadcastStream();
    chatStream.listen((chatModel) {
      if (mounted) {
        homeConversationModel.members = chatModel.members;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                    child: ListTile(
                  dense: true,
                  onTap: () {
                    Navigator.pop(context);
                    homeConversationModel.isGroupChat;
                    _onPrivateChatSettingsClick();
                  },
                  contentPadding: const EdgeInsets.all(0),
                  leading: Icon(
                    Icons.settings,
                    color: isDarkMode(context)
                        ? Colors.grey.shade200
                        : Colors.black,
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(fontSize: 18),
                  ),
                ))
              ];
            },
          ),
        ],
        centerTitle: true,
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.grey.shade200 : Colors.white),
        backgroundColor: Color(COLOR_PRIMARY),
        title: homeConversationModel.isGroupChat
            ? Text(
                homeConversationModel.conversationModel.name,
                style: TextStyle(
                    color: isDarkMode(context)
                        ? Colors.grey.shade200
                        : Colors.white,
                    fontWeight: FontWeight.bold),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    homeConversationModel.members.first.fullName(),
                    style: TextStyle(
                        color: isDarkMode(context)
                            ? Colors.grey.shade200
                            : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  homeConversationModel.members.first.lastOnlineTimestamp !=
                          null
                      ? Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: buildSubTitle(
                              homeConversationModel.members.first),
                        )
                      : Container(
                          width: 0,
                          height: 0,
                        )
                ],
              ),
      ),
      body: Builder(builder: (BuildContext innerContext) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      currentRecordingState = RecordingState.HIDDEN;
                    });
                  },
                  child: StreamBuilder<ChatModel>(
                      stream: homeConversationModel.conversationModel != null
                          ? chatStream
                          : null,
                      initialData: ChatModel(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.hasData &&
                              snapshot.data.message.isEmpty) {
                            return Center(
                                child: Text('Hãy bắt chuyện với người mới'));
                          } else {
                            return ListView.builder(
                                reverse: true,
                                itemCount: snapshot.data.message.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return buildMessage(
                                      snapshot.data.message[index],
                                      snapshot.data.members);
                                });
                          }
                        }
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: _onCameraClick,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Color(COLOR_PRIMARY),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 2.0, right: 2),
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: ShapeDecoration(
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(360),
                                    ),
                                    borderSide:
                                        BorderSide(style: BorderStyle.none)),
                                color: isDarkMode(context)
                                    ? Colors.grey[700]
                                    : Colors.grey.shade200,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      onChanged: (s) {
                                        setState(() {});
                                      },
                                      onTap: () {
                                        setState(() {
                                          currentRecordingState =
                                              RecordingState.HIDDEN;
                                        });
                                      },
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: _messageController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        hintText: 'Aa',
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(360),
                                            ),
                                            borderSide: BorderSide(
                                                style: BorderStyle.none)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(360),
                                            ),
                                            borderSide: BorderSide(
                                                style: BorderStyle.none)),
                                      ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      maxLines: 5,
                                      minLines: 1,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                    IconButton(
                        icon: Icon(
                          Icons.send,
                          color: _messageController.text.isEmpty
                              ? Color(COLOR_PRIMARY).withOpacity(.5)
                              : Color(COLOR_PRIMARY),
                        ),
                        onPressed: () async {
                          if (_messageController.text.isNotEmpty) {
                            _sendMessage(_messageController.text,
                                Url(mime: '', url: ''), '');
                            _messageController.clear();
                            setState(() {});
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildSubTitle(User friend) {
    String text = friend.active
        ? 'Active now'
        : 'Last seen on '
            '${setLastSeen(friend.lastOnlineTimestamp?.seconds ?? 0)}';
    return Text(text,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade200));
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Send Media",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose image from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.gallery);
            if (image != null) {
              Url url = await _fireStoreUtils.uploadChatImageToFireStorage(
                  File(image.path), context);
              _sendMessage('', url, '');
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Choose video from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile galleryVideo =
                await _imagePicker.getVideo(source: ImageSource.gallery);
            if (galleryVideo != null) {
              ChatVideoContainer videoContainer =
                  await _fireStoreUtils.uploadChatVideoToFireStorage(
                      File(galleryVideo.path), context);
              _sendMessage(
                  '', videoContainer.videoUrl, videoContainer.thumbnailUrl);
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
                await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null) {
              Url url = await _fireStoreUtils.uploadChatImageToFireStorage(
                  File(image.path), context);
              _sendMessage('', url, '');
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Record video"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile recordedVideo =
                await _imagePicker.getVideo(source: ImageSource.camera);
            if (recordedVideo != null) {
              ChatVideoContainer videoContainer =
                  await _fireStoreUtils.uploadChatVideoToFireStorage(
                      File(recordedVideo.path), context);
              _sendMessage(
                  '', videoContainer.videoUrl, videoContainer.thumbnailUrl);
            }
          },
        )
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

  Widget buildMessage(MessageData messageData, List<User> members) {
    if (messageData.senderID == MyAppState.currentUser.userID) {
      return myMessageView(messageData);
    } else {
      return remoteMessageView(
          messageData,
          members.where((user) {
            return user.userID == messageData.senderID;
          }).first);
    }
  }

  Widget myMessageView(MessageData messageData) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: _myMessageContentWidget(messageData)),
          displayCircleImage(messageData.senderProfilePictureURL, 35, false)
        ],
      ),
    );
  }

  Widget _myMessageContentWidget(MessageData messageData) {
    var mediaUrl = '';
    if (messageData.url != null && messageData.url.url.isNotEmpty) {
      if (messageData.url.mime.contains('image')) {
        mediaUrl = messageData.url.url;
      } else if (messageData.url.mime.contains('video')) {
        mediaUrl = messageData.videoThumbnail;
      } else if (messageData.url.mime.contains('audio')) {
        mediaUrl = messageData.url.url;
      }
    }
    if (mediaUrl.contains('audio')) {
      return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Positioned(
              right: -8,
              bottom: 0,
              child: Image.asset(
                'assets/images/chat_arrow_right.png',
                color: Color(COLOR_ACCENT),
                height: 12,
              ),
            ),
          ]);
    } else if (mediaUrl.isNotEmpty) {
      return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: 200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(alignment: Alignment.center, children: [
              GestureDetector(
                onTap: () {
                  if (messageData.videoThumbnail.isEmpty) {
                    push(
                        context,
                        FullScreenImageViewer(
                          imageUrl: mediaUrl,
                        ));
                  }
                },
                child: Hero(
                  tag: mediaUrl,
                  child: CachedNetworkImage(
                    imageUrl: mediaUrl,
                    placeholder: (context, url) =>
                        Image.asset('assets/images/img_placeholder'
                            '.png'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/error_image'
                            '.png'),
                  ),
                ),
              ),
              messageData.videoThumbnail.isNotEmpty
                  ? FloatingActionButton(
                      mini: true,
                      heroTag: messageData.messageID,
                      backgroundColor: Color(COLOR_ACCENT),
                      onPressed: () {
                        push(
                            context,
                            FullScreenVideoViewer(
                              heroTag: messageData.messageID,
                              videoUrl: messageData.url.url,
                            ));
                      },
                      child: Icon(
                        Icons.play_arrow,
                        color:
                            isDarkMode(context) ? Colors.black : Colors.white,
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    )
            ]),
          ));
    } else {
      return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Positioned(
              right: -8,
              bottom: 0,
              child: Image.asset(
                'assets/images/chat_arrow_right.png',
                color: Color(COLOR_ACCENT),
                height: 12,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 50,
                maxWidth: 200,
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(COLOR_ACCENT),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                      clipBehavior: Clip.hardEdge,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 6, bottom: 6, right: 4, left: 4),
                          child: Text(
                            mediaUrl.isEmpty
                                ? messageData.content ?? 'deleted message'
                                : '',
                            textAlign: TextAlign.start,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: isDarkMode(context)
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 16),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ]);
    }
  }

  Widget remoteMessageView(MessageData messageData, User sender) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              displayCircleImage(sender.profilePictureURL, 35, false),
              Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: homeConversationModel.members
                                .firstWhere((element) =>
                                    element.userID == messageData.senderID)
                                .active
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: isDarkMode(context)
                                ? Color(0xFF303030)
                                : Colors.white,
                            width: 1)),
                  ))
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: _remoteMessageContentWidget(messageData)),
        ],
      ),
    );
  }

  Widget _remoteMessageContentWidget(MessageData messageData) {
    var mediaUrl = '';
    if (messageData.url != null && messageData.url.url.isNotEmpty) {
      if (messageData.url.mime.contains('image')) {
        mediaUrl = messageData.url.url;
      } else if (messageData.url.mime.contains('video')) {
        mediaUrl = messageData.videoThumbnail;
      } else if (messageData.url.mime.contains('audio')) {
        mediaUrl = messageData.url.url;
      }
    }
    if (mediaUrl.contains('audio')) {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Positioned(
            left: -8,
            bottom: 0,
            child: Image.asset(
              'assets/images/chat_arrow_left.png',
              color: isDarkMode(context) ? Colors.grey[600] : Colors.grey[300],
              height: 12,
            ),
          ),
        ],
      );
    } else if (mediaUrl.isNotEmpty) {
      return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 50,
            maxWidth: 200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(alignment: Alignment.center, children: [
              GestureDetector(
                onTap: () {
                  if (messageData.videoThumbnail.isEmpty) {
                    push(
                        context,
                        FullScreenImageViewer(
                          imageUrl: mediaUrl,
                        ));
                  }
                },
                child: Hero(
                  tag: mediaUrl,
                  child: CachedNetworkImage(
                    imageUrl: mediaUrl,
                    placeholder: (context, url) =>
                        Image.asset('assets/images/img_placeholder'
                            '.png'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/error_image'
                            '.png'),
                  ),
                ),
              ),
              messageData.videoThumbnail.isNotEmpty
                  ? FloatingActionButton(
                      mini: true,
                      heroTag: messageData.messageID,
                      backgroundColor: Color(COLOR_ACCENT),
                      onPressed: () {
                        push(
                            context,
                            FullScreenVideoViewer(
                              heroTag: messageData.messageID,
                              videoUrl: messageData.url.url,
                            ));
                      },
                      child: Icon(
                        Icons.play_arrow,
                        color:
                            isDarkMode(context) ? Colors.black : Colors.white,
                      ),
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    )
            ]),
          ));
    } else {
      return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Positioned(
            left: -8,
            bottom: 0,
            child: Image.asset(
              'assets/images/chat_arrow_left.png',
              color: isDarkMode(context) ? Colors.grey[600] : Colors.grey[300],
              height: 12,
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 50,
              maxWidth: 200,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color:
                      isDarkMode(context) ? Colors.grey[600] : Colors.grey[300],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 6, bottom: 6, right: 4, left: 4),
                        child: Text(
                          mediaUrl.isEmpty
                              ? messageData.content ?? 'deleted message'
                              : '',
                          textAlign: TextAlign.start,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      );
    }
  }

  Future<bool> _checkChannelNullability(
      ConversationModel conversationModel) async {
    if (conversationModel != null) {
      return true;
    } else {
      String channelID;
      User friend = homeConversationModel.members.first;
      User user = MyAppState.currentUser;
      if (friend.userID.compareTo(user.userID) < 0) {
        channelID = friend.userID + user.userID;
      } else {
        channelID = user.userID + friend.userID;
      }

      ConversationModel conversation = ConversationModel(
          creatorId: user.userID,
          id: channelID,
          lastMessageDate: Timestamp.now(),
          lastMessage: ''
              '${user.fullName()} sent a message');
      bool isSuccessful =
          await _fireStoreUtils.createConversation(conversation);
      if (isSuccessful) {
        homeConversationModel.conversationModel = conversation;
        setupStream();
        setState(() {});
      }
      return isSuccessful;
    }
  }

  _sendMessage(String content, Url url, String videoThumbnail) async {
    MessageData message;
    if (homeConversationModel.isGroupChat) {
      message = MessageData(
          content: content,
          created: Timestamp.now(),
          senderFirstName: MyAppState.currentUser.firstName,
          senderID: MyAppState.currentUser.userID,
          senderLastName: MyAppState.currentUser.lastName,
          senderProfilePictureURL: MyAppState.currentUser.profilePictureURL,
          url: url,
          videoThumbnail: videoThumbnail);
    } else {
      message = MessageData(
          content: content,
          created: Timestamp.now(),
          recipientFirstName: homeConversationModel.members.first.firstName,
          recipientID: homeConversationModel.members.first.userID,
          recipientLastName: homeConversationModel.members.first.lastName,
          recipientProfilePictureURL:
              homeConversationModel.members.first.profilePictureURL,
          senderFirstName: MyAppState.currentUser.firstName,
          senderID: MyAppState.currentUser.userID,
          senderLastName: MyAppState.currentUser.lastName,
          senderProfilePictureURL: MyAppState.currentUser.profilePictureURL,
          url: url,
          videoThumbnail: videoThumbnail);
    }
    if (url != null) {
      if (url.mime.contains('image')) {
        message.content = '${MyAppState.currentUser.firstName} sent an image';
      } else if (url.mime.contains('video')) {
        message.content = '${MyAppState.currentUser.firstName} sent a video';
      } else if (url.mime.contains('audio')) {
        message.content = '${MyAppState.currentUser.firstName} sent a voice '
            'message';
      }
    }
    if (await _checkChannelNullability(
        homeConversationModel.conversationModel)) {
      await _fireStoreUtils.sendMessage(
          homeConversationModel.members,
          homeConversationModel.isGroupChat,
          message,
          homeConversationModel.conversationModel);
      homeConversationModel.conversationModel.lastMessageDate = Timestamp.now();
      homeConversationModel.conversationModel.lastMessage = message.content;

      await _fireStoreUtils
          .updateChannel(homeConversationModel.conversationModel);
    } else {
      showAlertDialog(context, 'An Error Occured',
          'Couldn\'t send Message, please try again later');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _groupNameController.dispose();
  }

  _onPrivateChatSettingsClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Chat Settings",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Unmatch user"),
          onPressed: () async {
            Navigator.pop(context);
            showProgress(context, 'Unmatching user...', false);
            bool isSuccessful = await _fireStoreUtils.unmatchUser(
                homeConversationModel.members.first, 'unmatch');
            hideProgress();
            if (isSuccessful) {
              Navigator.pop(context);
              _showAlertDialog(context, 'Unmatch',
                  'Đã hủy tương hợp thành công ${homeConversationModel.members.first.fullName()}.');
            } else {
              _showAlertDialog(
                  context,
                  'Unmatch',
                  'Couldn'
                      '\'t unmatch ${homeConversationModel.members.first.fullName()}, please try again later.');
            }
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Report user"),
          onPressed: () {
            Navigator.pop(context);
            _showSingleChoiceDialog(context);
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

  _showSingleChoiceDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Tố cáo ' + homeConversationModel.members.first.fullName(),
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
                  _onReportedClick();
                },
              ),
            ],
          );
        },
      );

  _onReportedClick() async {
    Navigator.pop(context);
    showProgress(context, 'Reporting user...', false);
    bool isSuccessful = await _fireStoreUtils.reportUser(
        homeConversationModel.members.first,
        reportTextController.text,
        'reporting');
    reportTextController.clear();
    if (isSuccessful) {
      Navigator.pop(context);
      _showAlertDialog(context, 'REPORTED',
          'Đã tố cáo ${homeConversationModel.members.first.fullName()} thành công.');
    } else {
      _showAlertDialog(
          context,
          'Report',
          'Couldn'
              '\'t report ${homeConversationModel.members.first.fullName()}, please try again later.');
    }
  }
}
