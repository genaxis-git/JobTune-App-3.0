import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUsers.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTAddressScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTBankScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTContactScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTEmergencyScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTPersonalScreenUser.dart';
import '../../../../main.dart';
import 'JTProfileWidgetUser.dart';


class JTProfileScreenUser extends StatelessWidget {
  static var tag = "/JTProfileScreenUser";

  Widget counter(String counter, String counterName) {
    return Column(
      children: <Widget>[
        jtprofile_counter(counter),
        jtprofile_text(counterName, textColor: appStore.textPrimaryColor, fontSize: 18.0, fontFamily: 'Medium'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    jtchangeStatusColor(appStore.appBarColor!);
    final profileImg = Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: FractionalOffset.center,
      child: CircleAvatar(
        backgroundImage: AssetImage("images/dashboard/db_profile.jpeg"),
        radius: 50,
      ),
    );
    final profileContent = Container(
      margin: EdgeInsets.only(top: 55.0),
      decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            jtprofile_text("John Doe", textColor: appStore.textPrimaryColor, fontSize: 20.0, fontFamily: 'Medium'),
            jtprofile_text("johndoe@mail.com", textColor: Colors.blueAccent, fontSize: 16.0, fontFamily: 'Medium'),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. \nFusce vitae blandit ante. Donec aliquam aliquam nibh in tristique. Quisque molestie eget nisl et malesuada. Maecenas feugiat lectus rutrum lacus condimentum.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Divider(color: Color(0XFFDADADA), height: 0.5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: Column(
                    children: [
                      Text(
                        "50",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "Booking",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          letterSpacing: 1,
                          fontFamily: 'Medium'
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                  child: Column(
                    children: [
                      Text(
                        "500",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "Spent",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            letterSpacing: 1,
                            fontFamily: 'Medium'
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, 'My Profile'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTAccountScreenUsers()),
              );
            }
        ),
      ),
      body: Observer(
        builder: (_) => SingleChildScrollView(
          padding: EdgeInsets.only(top: 70, left: 2, right: 2),
          physics: ScrollPhysics(),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Stack(
                    children: <Widget>[
                      profileContent,
                      profileImg,
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            jtprofile_rowHeading("PERSONAL"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTPersonalScreenUser()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText("John Doe"),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        SizedBox(height: 8),
                        jtprofile_profileText("Male"),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        SizedBox(height: 8),
                        jtprofile_profileText("South poul, Less Vegas street. \n396568 ", maxline: 2),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            jtprofile_rowHeading("CONTACTS"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTContactScreenUser()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText("+91 36982145"),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        SizedBox(height: 8),
                        jtprofile_profileText("Astoncina@gmail.com"),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            jtprofile_rowHeading("ADDRESS"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTAddressScreenUser()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText("South poul, Less Vegas street. \n396568 "),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            jtprofile_rowHeading("BANK INFORMATION"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTBankScreenUser()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        jtprofile_profileText("Western Union"),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        SizedBox(height: 8),
                        jtprofile_profileText("90987123"),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            jtprofile_rowHeading("EMERGENCY CONTACT"),
                            IconButton(
                              icon: Icon(AntDesign.edit, color: Colors.black,),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTEmergencyScreenUser()),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        jtprofile_profileText("Mariah Doe"),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          child: jtprofile_view(),
                        ),
                        SizedBox(height: 8),
                        jtprofile_profileText("+91 36981234"),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

