import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-service/models/JTflutter_rating_bar.dart';
import 'package:prokit_flutter/defaultTheme/model/DTReviewModel.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';

import '../../../../main.dart';
import 'JTDrawerWidget.dart';
import 'JTProductDetailWidget.dart';
import 'JTReviewWidget.dart';

class JTReviewScreen extends StatefulWidget {
  static String tag = '/JTReviewScreen';

  const JTReviewScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _JTReviewScreenState createState() => _JTReviewScreenState();
}

class _JTReviewScreenState extends State<JTReviewScreen> {
  List<DTReviewModel> list = getReviewList();
  var scrollController = ScrollController();

  // functions starts //

  String averagerate = "0.0";
  Future<void> readAverage() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_averagereview&id=" + widget.id),
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
            server + "jtnew_user_selectreview&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      ratinglist = json.decode(response.body);
    });

    setState(() {
      totalrating = ratinglist.length.toString();
    });
  }

  List countrate = [];
  double zero = 0.0;
  double one = 0.0;
  double two = 0.0;
  double three = 0.0;
  double four = 0.0;
  double five = 0.0;
  Future<void> readRatings() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_countrating&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      countrate = json.decode(response.body);
    });

    setState(() {
      for(var m =0;m<countrate.length;m++) {
        if(countrate[m]["amount"] == "0.0") {
          zero = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        }
        else if(countrate[m]["amount"] == "1.0") {
          one = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        }
        else if(countrate[m]["amount"] == "2.0") {
          two = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        }
        else if(countrate[m]["amount"] == "3.0") {
          three = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        }
        else if(countrate[m]["amount"] == "4.0") {
          four = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        }
        else if(countrate[m]["amount"] == "5.0") {
          five = (double.parse(countrate[m]["COUNT(amount)"]) / double.parse(totalrating));
        }
      }


    });
  }

  @override
  void initState() {
    this.readTotal();
    this.readAverage();
    this.readRatings();
    super.initState();
  }

  // function ends //

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    print(five);
    Widget reviewListing() {
      return JTReviewWidget(id:widget.id);
    }


    return Scaffold(
      appBar: JTappBar(context, 'Review & Rating'),
      drawer: JTDrawerWidgetUser(),
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
              reviewListing(),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class WriteReviewDialog extends StatelessWidget {
  var reviewCont = TextEditingController();
  var reviewFocus = FocusNode();
  double ratting = 0.0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: JTdynamicBoxConstraints(),
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
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
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
                  if (reviewCont.text != '') {
                    var reviewData = DTReviewModel();
                    reviewData.name = "Benjamin";
                    reviewData.comment = reviewCont.text.validate();
                    reviewData.ratting = ratting;
                    finish(context, reviewData);
                    toast('Review is submitted');
                  } else {
                    toast(errorThisFieldRequired);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.all(Radius.circular(5))),
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

