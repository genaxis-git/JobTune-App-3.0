import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDrawerWidgetNomad.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardScreenProduct.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTflutter_rating_bar.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/clocking/JTClockingScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/model/DTReviewModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';


class JTManageJobScreen extends StatefulWidget {
  @override
  _JTManageJobScreenState createState() => _JTManageJobScreenState();
}

class _JTManageJobScreenState extends State<JTManageJobScreen> {

  List<user> userdetails = [
    user(
      rank: '2021-09-15',
      name: '2021-10-01',
      email: '09:00:00',
      designation: 'Designer',
      birthday: '16:00:00',
      location: 'Mumbai',
    ),
    user(
      rank: '2021-10-10',
      name: '2021-10-20',
      email: '08:30:00',
      designation: 'Designer',
      birthday: '18:30:00',
      location: 'Mumbai',
    ),
  ];

  // function starts //

  @override
  void initState() {
    super.initState();
  }
  // function ends //

  @override
  Widget build(BuildContext context) {

    Widget mHeading(var value) {
      return Text(value, style: boldTextStyle());
    }

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: appStore.appBarColor,
            title: appBarTitleWidget(context, 'Welcome Employer'),
            bottom: TabBar(
              onTap: (index) {
                print(index);
              },
              indicatorColor: Colors.blue,
              labelColor: appStore.textPrimaryColor,
              labelStyle: boldTextStyle(),
              tabs: [
                Tab(
                  text: "Job Alert",
                ),
                Tab(
                  text: "Job Matching",
                ),
                Tab(
                  text: "Job Schedule",
                ),
              ],
            ),
          ),
          drawer: JTDrawerWidgetNomad(),
          body: TabBarView(
            children: [
              ContainerX(
                mobile: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      Center(
                        child: Text("No application receive yet."),
                      )
                    ],
                  ),
                ),
              ),
              ContainerX(
                mobile: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text("No matching candidates yet."),
                      )
                    ],
                  ),
                ),
              ),
              ContainerX(
                mobile: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 16,left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      20.height,
                      Text('Active Gig Employment Schedule:', style: boldTextStyle()).paddingBottom(5),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: <DataColumn>[
                            DataColumn(label: mHeading('Start'), tooltip: 'Rank'),
                            DataColumn(label: mHeading('End')),
                            DataColumn(label: mHeading('Job Position')),
                            DataColumn(label: mHeading('In')),
                            DataColumn(label: mHeading('Out')),
                          ],
                          rows: userdetails
                              .map(
                                (data) => DataRow(
                              cells: [
                                DataCell(Text(data.rank!, style: secondaryTextStyle())),
                                DataCell(Text(data.name!, style: secondaryTextStyle())),
                                DataCell(Text(data.designation!, style: secondaryTextStyle())),
                                DataCell(Text(data.email!, style: secondaryTextStyle())),
                                DataCell(Text(data.birthday!, style: secondaryTextStyle())),
                              ],
                            ),
                          )
                              .toList(),
                        ).visible(userdetails.isNotEmpty),
                      ),
                      50.height,
                      Text('Still Showing Ad:', style: boldTextStyle()).paddingBottom(5),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: <DataColumn>[
                            DataColumn(label: mHeading('Ad Expiry'), tooltip: 'Rank'),
                            DataColumn(label: mHeading('Job Position')),
                            DataColumn(label: mHeading('Remaining Time')),
                          ],
                          rows: userdetails
                              .map(
                                (data) => DataRow(
                              cells: [
                                DataCell(Text(data.rank!, style: secondaryTextStyle())),
                                DataCell(Text(data.designation!, style: secondaryTextStyle())),
                                DataCell(Text(data.email!, style: secondaryTextStyle())),
                              ],
                            ),
                          )
                              .toList(),
                        ).visible(userdetails.isNotEmpty),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WriteReviewDialog extends StatefulWidget {
  const WriteReviewDialog({
    Key? key,
    required this.bid,
    required this.sid,
    required this.provider,
  }) : super(key: key);
  final String bid;
  final String sid;
  final String provider;
  @override
  _WriteReviewDialogState createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  var reviewCont = TextEditingController();
  var reviewFocus = FocusNode();
  double ratting = 0.0;

  // function starts //

  Future<void> sendRating(rate,comm) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_user_insertrating&bid=" + widget.bid
                + "&sid=" + widget.sid
                + "&to=" + widget.provider
                + "&rating=" + rate
                + "&comment=" + comm
                + "&from=" + lgid
        ),
        headers: {"Accept": "application/json"}
    );

    finish(context);
    toast("Your rating have been submitted. Thank you!");
  }

  // function ends //

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: dynamicBoxConstraints(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Write a Review', style: boldTextStyle(size: 18)),
                  IconButton(
                    icon: Icon(Icons.close, color: appStore.iconColor),
                    onPressed: () {
                      finish(context);
                    },
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  finish(context);
                },
                child: Container(padding: EdgeInsets.all(4), alignment: Alignment.centerRight),
              ),
              8.height,
              Center(
                child: RatingBar(
                  onRatingUpdate: (r) {
                    ratting = r;
                  },
                  itemSize: 35.0,
                  glow: false,
                  initialRating: 0.0,
                  allowHalfRating: false,
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star, color: Colors.amber),
                    half: Icon(Icons.star, color: Colors.amber),
                    empty: Icon(Icons.star_border, color: Colors.amber),
                  ),
                ),
              ),
              16.height,
              TextField(
                controller: reviewCont,
                focusNode: reviewFocus,
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  labelText: 'Write here',
                  contentPadding: EdgeInsets.all(16),
                  labelStyle: secondaryTextStyle(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                //Normal textInputField will be displayed
                maxLines: 5,
                textInputAction: TextInputAction.newline, // when user presses enter it will adapt to it
              ),
              30.height,
              GestureDetector(
                onTap: () {
                  sendRating(ratting.toString(),reviewCont.text);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Center(
                    child: Text("Submit", style: boldTextStyle(color: white)),
                  ),
                ),
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}

class user {
  String? rank;
  String? name;
  String? email;
  String? designation;
  String? birthday;
  String? location;

  user({this.rank, this.name, this.email, this.designation, this.birthday, this.location});
}