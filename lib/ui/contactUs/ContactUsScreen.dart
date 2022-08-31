import 'package:dating/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String url = "tel:0585 023 602";
          launch(url);
        },
        backgroundColor: Color(COLOR_ACCENT),
        child: Icon(
          Icons.call,
          color: isDarkMode(context) ? Colors.black : Colors.white,
        ),
      ),
      appBar: AppBar(
        brightness: isDarkMode(context) ? Brightness.dark : Brightness.light,
        backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
            color: isDarkMode(context) ? Colors.white : Colors.black),
        title: Text(
          'Trung tâm liên lạc',
          style: TextStyle(
              color: isDarkMode(context) ? Colors.white : Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        Material(
            elevation: 2,
            color: isDarkMode(context) ? Colors.black12 : Colors.white,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 16.0, left: 16, top: 16),
                    child: Text(
                      'Our Address',
                      style: TextStyle(
                          color:
                              isDarkMode(context) ? Colors.white : Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 16.0, left: 16, top: 16, bottom: 16),
                    child: Text('Quang Trung, Gò Vâp, HCM'),
                  ),
                  ListTile(
                    title: Text(
                      'E-mail us',
                      style: TextStyle(
                          color:
                              isDarkMode(context) ? Colors.white : Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('dung.197pm21901@vanlanguni.vn'),
                  )
                ]))
      ]),
    );
  }
}
