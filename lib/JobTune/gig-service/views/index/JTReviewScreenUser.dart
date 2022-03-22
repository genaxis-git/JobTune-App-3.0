import 'dart:math';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/register-login/JTSignInScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTflutter_rating_bar.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/model/DTReviewModel.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import '../../../../main.dart';
import 'JTDrawerWidget.dart';
import 'JTProductDetailWidget.dart';
import 'JTReviewWidget.dart';

class JTReviewScreenUser extends StatefulWidget {
  static String tag = '/JTReviewScreenUser';

  const JTReviewScreenUser({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _JTReviewScreenUserState createState() => _JTReviewScreenUserState();
}

class _JTReviewScreenUserState extends State<JTReviewScreenUser> {
  List<DTReviewModel> list = getReviewList();
  var scrollController = ScrollController();

  // functions starts //

  String averagerate = "0.0";
  Future<void> readAverage() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectaveragerating&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      averagerate = response.body;
    });
  }

  String totalrating = "0";
  List ratinglist = [];
  Future<void> readTotal() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selecttotalrate&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      ratinglist = json.decode(response.body);
    });

    setState(() {
      totalrating = ratinglist.length.toString();
    });

    readRatings();
  }

  List countrate = [];
  double zero = 0.0;
  double one = 0.0;
  double two = 0.0;
  double three = 0.0;
  double four = 0.0;
  double five = 0.0;
  Future<void> readRatings() async {
    print(server + "jtnew_user_countrating&id=" + widget.id);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_countrating&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      countrate = json.decode(response.body);
    });

    for(var m =0;m<countrate.length;m++) {
      print("hangpa");
      print(countrate[m]["amount"]);
      print(double.parse(countrate[m]["COUNT(amount)"]));
      print(double.parse(totalrating));
      if(countrate[m]["amount"] == "0.0") {
        setState(() {
          zero = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        });
      }
      else if(countrate[m]["amount"] == "1.0") {
        setState(() {
          one = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        });
      }
      else if(countrate[m]["amount"] == "2.0") {
        setState(() {
          two = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        });
      }
      else if(countrate[m]["amount"] == "3.0") {
        setState(() {
          three = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        });
      }
      else if(countrate[m]["amount"] == "4.0") {
        setState(() {
          four = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        });
      }
      else {
        setState(() {
          five = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        });
      }
    }
  }


  List info = [];
  String servicename = "";
  String rate = "0";
  String desc = "";
  String category = "";
  String days = "";
  String hours = "";
  String location = "";
  String proid = "";
  String by = "Package";
  String id = "";
  Future<void> readService() async {

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectservice&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      info = json.decode(response.body);
    });

    setState(() {
      servicename = info[0]["name"];
      proid = info[0]["provider_id"];
      id = info[0]["service_id"];
      rate = double.parse(info[0]["rate"]).toStringAsFixed(2);
      desc = info[0]["description"];
      category = info[0]["category"];
      days = info[0]["available_day"];
      hours = info[0]["available_start"] + " to " + info[0]["available_end"];
      location = info[0]["location"];
      by = info[0]["rate_by"];
    });
  }

  String identity = "";
  Future<void> checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(lgid == null){
      setState(() {
        identity = "null";
      });
    }
    else{
      identity = lgid;
    }
  }

  @override
  void initState() {
    this.checkUser();
    this.readService();
    this.readTotal();
    this.readAverage();
    // this.readRatings();
    super.initState();
  }

  // function ends //

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget reviewListing() {
      return JTReviewWidget(id:widget.id);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, 'Review & Rating'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JTServiceDetailScreen(
                      id: widget.id,
                      page: "details",
                    )),
              );
            }
        ),
      ),
      body: JTContainerX(
        mobile: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(gradient: JTdefaultThemeGradient()),
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: JTdynamicBoxConstraints(),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(child: Text(double.parse(averagerate).toStringAsFixed(1), style: boldTextStyle(size: 40, color: white))),
                          IgnorePointer(
                            child: RatingBar(
                              onRatingUpdate: (r) {},
                              itemSize: 14.0,
                              itemBuilder: (context, _) => Icon(Icons.star_border, color: Colors.amber),
                              initialRating: double.parse(double.parse(averagerate).toStringAsFixed(1)),
                            ),
                          ),
                          10.height,
                          FittedBox(child: Text(totalrating, style: boldTextStyle(color: white))),
                        ],
                      ).paddingOnly(left: 8, right: 8).expand(flex: 1),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('5', style: primaryTextStyle(color: white)),
                              10.width,
                              LinearProgressIndicator(
                                value: five,
                                backgroundColor: white.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(white),
                              ).expand(),
                              10.width,
                            ],
                          ),
                          Row(
                            children: [
                              Text('4', style: primaryTextStyle(color: white)),
                              10.width,
                              LinearProgressIndicator(
                                value: four,
                                backgroundColor: white.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(white),
                              ).expand(),
                              10.width,
                            ],
                          ),
                          Row(
                            children: [
                              Text('3', style: primaryTextStyle(color: white)),
                              10.width,
                              LinearProgressIndicator(
                                value: three,
                                backgroundColor: white.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(white),
                              ).expand(),
                              10.width,
                            ],
                          ),
                          Row(
                            children: [
                              Text('2', style: primaryTextStyle(color: white)),
                              10.width,
                              LinearProgressIndicator(
                                value: two,
                                backgroundColor: white.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(white),
                              ).expand(),
                              10.width,
                            ],
                          ),
                          Row(
                            children: [
                              Text('1', style: primaryTextStyle(color: white)),
                              10.width,
                              LinearProgressIndicator(
                                value: one,
                                backgroundColor: white.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(white),
                              ).expand(),
                              10.width,
                            ],
                          ),
                        ],
                      ).expand(flex: 2),
                    ],
                  ),
                ),
              ),
              8.height,
              (identity != "null")
              ? Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(8)),
                child: Text('Write a Review', style: boldTextStyle(color: appColorPrimary)),
              ).onTap(() async {
                showInDialog(context,
                    child: WriteReviewDialog(
                      bid: "",
                      sid: widget.id,
                      provider: proid,
                    ),
                    backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
              })
              : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(8)),
                child: Text('Login to Write a Review', style: boldTextStyle(color: appColorPrimary)),
              ).onTap(() async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JTSignInScreen()),
                );
              }),
              reviewListing(),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
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

    var currentdate = DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now());

    print(server + "jtnew_provider_insertnewnoti"
        + "&subject=" + "New Review For You.."
        + "&message=" + "You have received new review from me: \n\nRating: "+rate+"\nComment: "+comm+"\n\nThis review may help you to acknowledge others' opinion and level of satisfaction towards your service."
        + "&attachment=" + ""
        + "&from=" + lgid
        + "&to=" + widget.provider
        + "&date=" + currentdate);
    http.get(
        Uri.parse(
            server + "jtnew_provider_insertnewnoti"
                + "&subject=" + "New Review For You.."
                + "&message=" + "You have received new review from me: \n\nRating: "+rate+"\nComment: "+comm+"\n\nThis review may help you to acknowledge others' opinion and level of satisfaction towards your service."
                + "&attachment=" + ""
                + "&from=" + lgid
                + "&to=" + widget.provider
                + "&date=" + currentdate
        ),
        headers: {"Accept": "application/json"}
    );

    finish(context);
    toast("Your rating have been submitted. Thank you!");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => JTReviewScreenUser(id: widget.sid)),
    );
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
                maxLength: 250,
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

