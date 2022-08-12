import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating/model/User.dart';
import 'package:dating/services/helper.dart';
import 'package:dating/ui/fullScreenImageViewer/FullScreenImageViewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../constants.dart';

class MyDetailsScreen extends StatefulWidget {
  final User user;

  const MyDetailsScreen({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _MyDetailsScreenState createState() => _MyDetailsScreenState(user);
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  final User user;
  List<String> images = [];

  _MyDetailsScreenState(this.user);

  List _pages = [];
  PageController controller = PageController(
    initialPage: 0,
  );
  PageController gridPageViewController = PageController(
    initialPage: 0,
  );
  List<Widget> _gridPages = [];

  @override
  void initState() {
    images.add(user.profilePictureURL);
    images.addAll(user.photos.cast<String>());
    images.removeWhere((element) => element == null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: isDarkMode(context) ? Colors.black : Colors.white));
    _gridPages = _buildGridView();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * .6,
                      child: PageView.builder(
                        itemBuilder: (BuildContext context, int index) =>
                            _buildImage(index),
                        itemCount: images.length,
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: SmoothPageIndicator(
                        controller: controller, // PageController
                        count: images.length,
                        effect: SlideEffect(
                            spacing: 4.0,
                            radius: 4.0,
                            dotWidth: (MediaQuery.of(context).size.width /
                                    images.length) -
                                4,
                            dotHeight: 4.0,
                            paintStyle: PaintingStyle.fill,
                            dotColor: Colors.grey,
                            activeDotColor:
                                Colors.white), // your preferred effect
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: -28,
                      child: FloatingActionButton(
                          mini: false,
                          child: const Icon(
                            Icons.arrow_downward,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    )
                  ]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${user.fullName()}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                    ),
                    Text(
                      user.age != 0 || user.age == 'N/A' ? '' : '  ${user.age}',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.bookmark),
                    Text('   ${user.bio}')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.church),
                    Text('   ${user.denominationalViews}')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.auto_awesome),
                    Text('   ${user.zodiac}')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Text('   ${user.seeking}')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.handshake),
                    Text(
                        '  Tìm kiếm mối quan hệ lâu dài:  ${user.willingToRelocate}')
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: skipNulls([
                    Text(
                      'Photos',
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    _pages.length >= 2
                        ? SmoothPageIndicator(
                            controller: gridPageViewController,
                            // PageController
                            count: _pages.length,
                            effect: JumpingDotEffect(
                                spacing: 4.0,
                                radius: 4.0,
                                dotWidth: 8,
                                dotHeight: 8.0,
                                paintStyle: PaintingStyle.fill,
                                dotColor: Colors.grey,
                                activeDotColor: Color(
                                    COLOR_PRIMARY)), // your preferred effect
                          )
                        : null,
                  ]),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 8),
                child: SizedBox(
                    height: user.photos.length > 3 ? 260 : 130,
                    width: double.infinity,
                    child: PageView(
                      controller: gridPageViewController,
                      children: _gridPages,
                    )),
              ),
              Visibility(
                child: Container(
                  height: 110,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGridView() {
    _pages.clear();
    List<Widget> gridViewPages = [];
    var len = images.length;
    var size = 6;
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      _pages.add(images.sublist(i, end));
    }
    _pages.forEach((elements) {
      gridViewPages.add(GridView.builder(
          padding: EdgeInsets.only(right: 16, left: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (context, index) => _imageBuilder(elements[index]),
          itemCount: elements.length,
          physics: BouncingScrollPhysics()));
    });
    return gridViewPages;
  }

  Widget _imageBuilder(String url) {
    return GestureDetector(
      onTap: () {
        push(context, FullScreenImageViewer(imageUrl: url));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        color: Color(COLOR_PRIMARY),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: user.profilePictureURL == DEFAULT_AVATAR_URL ? '' : url,
            placeholder: (context, imageUrl) {
              return Icon(
                Icons.hourglass_empty,
                size: 75,
                color: isDarkMode(context) ? Colors.black : Colors.white,
              );
            },
            errorWidget: (context, imageUrl, error) {
              return Icon(
                Icons.error_outline,
                size: 75,
                color: isDarkMode(context) ? Colors.black : Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImage(int index) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl:
          user.profilePictureURL == DEFAULT_AVATAR_URL ? '' : images[index],
      placeholder: (context, imageUrl) {
        return Icon(
          Icons.hourglass_empty,
          size: 75,
          color: isDarkMode(context) ? Colors.black : Colors.white,
        );
      },
      errorWidget: (context, imageUrl, error) {
        return Icon(
          Icons.error_outline,
          size: 75,
          color: isDarkMode(context) ? Colors.black : Colors.white,
        );
      },
    );
  }

  @override
  void dispose() {
    gridPageViewController.dispose();
    controller.dispose();
    super.dispose();
  }
}
