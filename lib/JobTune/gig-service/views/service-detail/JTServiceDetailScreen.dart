import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/register-login/JTSignInScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/booking-form/JTBookingFormScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/page-view/JTPageScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';
import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../../../main.dart';
import '../index/JTDrawerWidget.dart';
import '../index/JTProductDetailWidget.dart';
import '../index/JTReviewScreenUser.dart';
import 'JTChangeAddress.dart';
import 'JTCheckSlotScreen.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

bool package = true;

class JTServiceDetailScreen extends StatefulWidget {
  static String tag = '/JTServiceDetailScreen';

  const JTServiceDetailScreen({
    Key? key,
    required this.id,
    required this.page
  }) : super(key: key);
  final String id;
  final String page;

  @override
  _JTServiceDetailScreenState createState() => _JTServiceDetailScreenState();
}

class _JTServiceDetailScreenState extends State<JTServiceDetailScreen> {
  var discount = 0.0;

  var bookname = TextEditingController();
  var bookemail = TextEditingController();
  var bookphone = TextEditingController();
  var bookaddress = TextEditingController();
  var bookdesc = TextEditingController();

  var passFocus = FocusNode();
  DateTime selectedDate = DateTime.now();

  DTAddressListModel? mSelectedAddress;

  // functions starts //

  List profile = [];
  String email = "";
  String fullname = "";
  String address = "";
  String telno = "";
  String nric = "";
  String gender = "";
  String race = "";
  String pic = "";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      // fullname = profile[0]["first_name"] + " " + profile[0]["last_name"] ;
      // address = profile[0]["address"] ;
      telno = profile[0]["phone_no"] ;
      gender = profile[0]["gender"] ;
      race = profile[0]["race"] ;
      nric = profile[0]["nric"] ;
      pic = profile[0]["profile_pic"] ;
    });
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
    print(server + "jtnew_provider_selectservice&id=" + widget.id);
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

    var res = info[0]["location"].split(",");
    for(var m = 0; m<res.length; m++) {
      _locatioanavailable(res[m]);
    }

    readLikes(info[0]["provider_id"],info[0]["service_id"]);
    readProvider(info[0]["provider_id"],info[0]["service_id"]);
  }

  String img = "no profile.png";
  String providername = " ";
  List provider = [];
  Future<void> readProvider(a,b) async {
    print(server + "jtnew_provider_selectprofile&lgid=" + a);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectprofile&lgid=" + a),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      provider = json.decode(response.body);
    });

    setState(() {
      providername = provider[0]["name"];
      if(provider[0]["profile_pic"] != "") {
        img = provider[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
    });

    readPackage(b);
  }

  List servicelist = [];
  List numbers = [];
  String packagelist = "";
  double max = 0;
  double min = 0;
  Future<void> readPackage(b) async {

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectpackage&id=" + b),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    min = double.parse(servicelist[0]["package_rate"]);
    for(var m=0;m<servicelist.length;m++) {
      packagelist = servicelist[m]["package_name"] + " (RM " + servicelist[m]["package_rate"] + ") est: " + servicelist[m]["package_time"] + " Hrs.";
      _packagename(packagelist);
      if(double.parse(servicelist[m]["package_rate"])>max){
        max = double.parse(servicelist[m]["package_rate"]);
      }
      if(double.parse(servicelist[m]["package_rate"])<min){
        min = double.parse(servicelist[m]["package_rate"]);
      }
    }

    setState(() {
      print("result:" + min.toString()+" "+max.toString());
      min = min;
      max = max;
    });
  }

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
  }

  String totalreview = "0";
  List reviewlist = [];
  List reviewarr = [0];
  String reviewavg = "0.0";
  Future<void> readReviews() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectreview&id=" + proid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      reviewlist = json.decode(response.body);
    });

    setState(() {
      totalreview = reviewlist.length.toString();
    });

    averageReview();
  }

  String averagereview = "0.0";
  Future<void> averageReview() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_averagereview&id=" + proid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      averagereview = response.body;
    });
  }

  List selectedaddress = [];
  Future<void> readAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectalladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      selectedaddress = json.decode(response.body);
    });

    for(var m=0; m<selectedaddress.length; m++){
      if(selectedaddress[m]["added_status"] == "1"){
        setState(() {
          address = selectedaddress[m]["added_address"];
          fullname = selectedaddress[m]["added_name"];
        });
      }
    }
  }

  List likes = [];
  Future<void> readLikes(id,service) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    print(server + "jtnew_provider_selecttotallike&id="+ id);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selecttotallike&id="+ id
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      likes = json.decode(response.body);
    });

    for(var m=0;m<likes.length;m++){
      if(likes[m]["service_id"] == service && likes[m]["user"] == lgid){
        likestatus = "true";
      }
    }

    readFollows(id);
  }

  List follows = [];
  Future<void> readFollows(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectfollowing&id="+ id
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      follows = json.decode(response.body);
    });

    for(var m=0;m<follows.length;m++){
      if(follows[m]["user"] == lgid){
        setState(() {
          followstatus = "true";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    this.readService();
    this.readAddress();
    this.readProfile();
    this.readAverage();
    this.readTotal();
    this.readReviews();
  }

  // function ends //

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        helpText: 'Select your Booking date',
        cancelText: 'Not Now',
        confirmText: "Book",
        fieldLabelText: 'Booking Date',
        fieldHintText: 'Month/Date/Year',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        context: context,
        builder: (BuildContext context, Widget? child) {
          return JTCustomTheme(
            child: child,
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        print(picked);
        selectedDate = picked;
      });
  }

  String hourcontroller = "00";
  String mincontroller = "00";
  int _hourController = 1;
  int _count = 0;
  List<Widget> _children = [];
  List<Widget> _package = [];
  List<Widget> _location = [];

  void _add(a) {
    _children =
    List.from(_children)
      ..add(Column(
        children: [
          16.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
              10.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a,
                    style: boldTextStyle(size: 15),
                    maxLines: 2,
                  ),
                  4.height,
                ],
              ).expand()
            ],
          ),
        ],
      )
      );
    setState(() => ++_count);
  }

  void _packagename(a){
    _package =
    List.from(_package)
      ..add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
            10.width,
            Text(
              a,
              style: boldTextStyle(size: 15),
              maxLines: 2,
            ),
            25.height,
          ],
        ),
      );
  }

  void _locatioanavailable(a){
    _location =
    List.from(_location)
      ..add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
            10.width,
            Text(
              a,
              style: boldTextStyle(size: 15),
              maxLines: 2,
            ),
            25.height,
          ],
        ),
      );
  }

  void _launchCaller() async {
    const url = "tel:0163929098" ;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _makeSocialMediaRequest(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _callNumber() async{
    var number = provider[0]["phone_no"]; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  String likestatus = "false";
  String followstatus = "false";

  @override
  Widget build(BuildContext context) {
    Widget checkCalendar() {
      return Container(
        height: 50,
        width: context.width() / 2,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
        child: Text('Check Slot', style: boldTextStyle()),
      ).onTap(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WebViewCalendar(id:proid)),
        );
        // Do your logic
      });
    }

    Widget likeprovider() {
      return Container(
        height: 50,
        width: context.width() / 2,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
        child: (likestatus == "true")
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Liked ', style: boldTextStyle()),
                Icon(Icons.favorite, color: Colors.red, size: 25)
                ],
              )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Like ', style: boldTextStyle()),
                Icon(Icons.favorite_border, size: 25),
              ],
            )

      ).onTap(() async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String lgid = prefs.getString('email').toString();

        if(likestatus == "true"){
          setState(() {
            likestatus = "false";
          });

          http.get(
              Uri.parse(
                  server + "jtnew_user_deletelikeservice&id=" + info[0]["service_id"]
                      + "&user=" + lgid
              ),
              headers: {"Accept": "application/json"}
          );
        }
        else{
          setState(() {
            likestatus = "true";
          });

          http.get(
              Uri.parse(
                  server + "jtnew_user_insertlikeservice&id=" + info[0]["service_id"]
                      + "&user=" + lgid
                      + "&provider=" + info[0]["provider_id"]
              ),
              headers: {"Accept": "application/json"}
          );
        }
      });
    }

    Widget followprovider() {
      return Container(
        height: 50,
        width: context.width() / 2,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
        child: (followstatus == "true")
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Following ', style: boldTextStyle()),
                Icon(Icons.check_rounded, color: Colors.blueAccent, size: 21)
                ],
              )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Follow  ', style: boldTextStyle()),
                Icon(Icons.person_add_alt_1, size: 21),
              ],
            )

      ).onTap(() async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String lgid = prefs.getString('email').toString();

        if(lgid != "null"){
          if(followstatus == "true"){
            setState(() {
              followstatus = "false";
            });

            http.get(
                Uri.parse(
                    server + "jtnew_user_deletefollowing&user=" + lgid
                        + "&provider=" + info[0]["provider_id"]
                ),
                headers: {"Accept": "application/json"}
            );
          }
          else{
            setState(() {
              followstatus = "true";
            });

            http.get(
                Uri.parse(
                    server + "jtnew_user_insertfollowing&&user=" + lgid
                        + "&provider=" + info[0]["provider_id"]
                ),
                headers: {"Accept": "application/json"}
            );
          }
        }
        else{
          showInDialog(context,
              child: AlertLoginFirst(),
              backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
        }
      });
    }

    Widget buyNowBtn() {
      return Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        width: context.width() / 2,
        decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
        child: Text('Book Now', style: boldTextStyle(color: white)),
      ).onTap(() {
        // Do your logic
        if(fullname != "" || telno != "" || nric != "" || gender != "" || race != "" || address != "" || pic != "") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JTBookingFormScreen(
                  id: widget.id,
                  proid: proid,
                  img: img,
                  min: min.toString(),
                  max: max.toString(),
                ),
              ));
        }
        else {
          showInDialog(context,
              child: AlertCompleteProfile(),
              backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
        }
      });
    }

    Widget callNow() {
      return Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        width: context.width() / 2,
        decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
        child: Text('Contact Provider', style: boldTextStyle(color: white)),
      ).onTap(() {
        // Do your logic
        print("ayam");
        showCupertinoModalPopup(context: context, builder: (BuildContext context) => CustomTheme(
          child: CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    final Uri _phoneLaunchUri = Uri(scheme: 'tel', path: provider[0]["phone_no"]);
                    _makeSocialMediaRequest(_phoneLaunchUri.toString());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Call',
                        style: primaryTextStyle(size: 18),
                      ),
                      Icon(
                        Icons.call,
                        color: Colors.blueAccent,
                      )
                    ],
                  )),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      var uri = 'sms:'+provider[0]["phone_no"]+'?body=hello%20there';
                      await launch(uri);
                    } else if (Platform.isIOS) {
                      // iOS
                      var uri = 'sms:'+provider[0]["phone_no"]+'&body=hello%20there';
                      await launch(uri);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chat (Phone)',
                        style: primaryTextStyle(size: 18),
                      ),
                      Icon(
                        Icons.chat_rounded,
                        color: Colors.blueAccent,
                      )
                    ],
                  )),
              CupertinoActionSheetAction(
                  onPressed: () async {
                    final link = WhatsAppUnilink(
                      phoneNumber: '+60' + provider[0]["phone_no"],
                      text: "Hello there!",
                    );
                    await launch('$link');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chat (Whatsapp)',
                        style: primaryTextStyle(size: 18),
                      ),
                      FaIcon(FontAwesomeIcons.whatsapp,color: Colors.green,),
                    ],
                  )),
              CupertinoActionSheetAction(
                onPressed: () async {
                  final Uri params = Uri(
                    scheme: 'mailto',
                    path: provider[0]["email"],
                    query: 'subject=Service Detail Inquiries', //add subject and body here
                  );

                  var url = params.toString();
                  if (await canLaunch(url)) {
                  await launch(url);
                  } else {
                  throw 'Could not launch $url';
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Email',
                      style: primaryTextStyle(size: 18),
                    ),
                    Icon(
                      Icons.email_outlined,
                      color: Colors.blueAccent,
                    )
                  ],
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  finish(context);
                },
                child: Text(
                  'Cancel',
                  style: primaryTextStyle(color: redColor, size: 18),
                )),
          ),
        ));
        // UrlLauncher.launch('tel:+${provider[0]["phone_no"].toString()}');
      });
    }

    Widget loginBtn() {
      return Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        width: context.width() / 2,
        decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
        child: Text('Login to Chat', style: boldTextStyle(color: white)),
      ).onTap(() {
        // Do your logic
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JTSignInScreen(),
            ));
      });
    }

    Widget buttonWidget() {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // checkCalendar(),
          followprovider(),
          (email != "null")
          ? callNow()
          : loginBtn(),

        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, 'Detail'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if(widget.page == "location-sorting" || widget.page == "category-sorting" || widget.page == "provider-page" || widget.page == "notifications" || widget.page == "ratings"){
                Navigator.pop(
                  context,
                );
              }
              else{
                JTDashboardSreenUser().launch(context, isNewTask: true);
              }
            }
        ),
      ),
      drawer: JTDrawerWidgetUser(),
      body: JTContainerX(
        mobile: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: context.height() * 0.45,
                    child: Image.network(
                      image + img,
                      width: context.width(),
                      height: context.height() * 0.45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  10.height,
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              servicename,
                              style: boldTextStyle(size: 18)
                          ),
                          5.height,
                          Row(
                            children: [
                              Text(
                                  " by ",
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  JTProviderPageScreen(
                                    id: widget.id,
                                    provider: provider[0]["email"],
                                  ).launch(context, isNewTask: true);
                                },
                                child: Text(
                                  providername,
                                  style: TextStyle(
                                    color: Color(0xFF0A79DF),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  (rate != "0.00")
                                      ? JTpriceWidget(double.parse(rate), fontSize: 28, textColor: Color(0xFF0A79DF))
                                      : (min != max)
                                      ? Row(
                                    children: [
                                      JTpriceWidget(min, fontSize: 28, textColor: Color(0xFF0A79DF)),
                                      Text(
                                        " to ",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      JTpriceWidget(max, fontSize: 28, textColor: Color(0xFF0A79DF)),
                                    ],
                                  )
                                      : JTpriceWidget(min, fontSize: 28, textColor: Color(0xFF0A79DF)),
                                ],
                              ),
                              (email != proid)
                              ? (likestatus == "true")
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async{
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      final String lgid = prefs.getString('email').toString();

                                      if(lgid != "null"){
                                        setState(() {
                                          likestatus = "false";
                                        });

                                        http.get(
                                            Uri.parse(
                                                server + "jtnew_user_deletelikeservice&id=" + info[0]["service_id"]
                                                    + "&user=" + lgid
                                            ),
                                            headers: {"Accept": "application/json"}
                                        );
                                      }
                                      else{
                                        showInDialog(context,
                                            child: AlertLoginFirst(),
                                            backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
                                      }
                                    },
                                    child: Icon(Icons.favorite, color: Colors.red, size: 32),
                                  ),
                                  SizedBox(width: 10,)
                                ],
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async{
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      final String lgid = prefs.getString('email').toString();

                                      if(lgid != "null"){
                                        setState(() {
                                          likestatus = "true";
                                        });

                                        http.get(
                                            Uri.parse(
                                                server + "jtnew_user_insertlikeservice&id=" + info[0]["service_id"]
                                                    + "&user=" + lgid
                                                    + "&provider=" + info[0]["provider_id"]
                                            ),
                                            headers: {"Accept": "application/json"}
                                        );
                                      }
                                      else{
                                        showInDialog(context,
                                            child: AlertLoginFirst(),
                                            backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
                                      }
                                    },
                                    child: Icon(Icons.favorite_border, size: 30),

                                  ),
                                  SizedBox(width: 10,)
                                ],
                              )
                              : Container()
                            ],
                          ),

                          // 10.height,
                          // Row(
                          //   children: [
                          //     (double.parse(averagereview).toStringAsFixed(1) != "0.0")
                          //         ? Container(
                          //       decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(16)),
                          //       padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                          //       child: Row(
                          //         children: [
                          //           Icon(Icons.star_border, color: Colors.white, size: 14),
                          //           8.width,
                          //           Text(double.parse(averagereview).toStringAsFixed(1), style: primaryTextStyle(color: white)),
                          //         ],
                          //       ),
                          //     ).onTap(() {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => JTReviewScreenUser(id: widget.id)),
                          //       );
                          //     })
                          //         : Container(
                          //       decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(16)),
                          //       padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                          //       child: Row(
                          //         children: [
                          //           Icon(Icons.star_border, color: Colors.white, size: 14),
                          //           8.width,
                          //           Text(double.parse(averagereview).toStringAsFixed(1), style: primaryTextStyle(color: white)),
                          //         ],
                          //       ),
                          //     ),
                          //     8.width,
                          //     (totalreview != "0")
                          //         ? Text(totalreview + ' reviews', style: secondaryTextStyle(size: 16)).onTap(() {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => JTReviewScreen(id: proid)),
                          //       );
                          //     })
                          //         : Row(
                          //       children: [
                          //         Text('No reviews yet', style: secondaryTextStyle(size: 16)).onTap(() {
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => JTReviewScreen(id: proid)),
                          //           );
                          //         })
                          //         // TextButton.icon(
                          //         //     onPressed: () {
                          //         //       toast('Flat button with icon');
                          //         //     },
                          //         //     icon: Icon(
                          //         //       Icons.add_circle_outline,
                          //         //       color: Colors.indigoAccent,
                          //         //     ),
                          //         //     label: Text(
                          //         //       '',
                          //         //       style: primaryTextStyle(),
                          //         //     )),
                          //       ],
                          //     )
                          //   ],
                          // ),

                        10.height,
                        Row(
                          children: [
                            (double.parse(averagerate).toStringAsFixed(1) != "0.0")
                            ? Container(
                              decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(16)),
                              padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.star_border, color: Colors.white, size: 14),
                                  8.width,
                                  Text(double.parse(averagerate).toStringAsFixed(1), style: primaryTextStyle(color: white)),
                                ],
                              ),
                            ).onTap(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JTReviewScreenUser(id: widget.id)),
                              );
                            })
                            : Container(
                              decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(16)),
                              padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.star_border, color: Colors.white, size: 14),
                                  8.width,
                                  Text(double.parse(averagerate).toStringAsFixed(1), style: primaryTextStyle(color: white)),
                                ],
                              ),
                            ).onTap(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JTReviewScreenUser(id: widget.id)),
                              );
                            }),
                            8.width,
                            (totalrating != "0")
                            ? Text(totalrating + ' reviews', style: secondaryTextStyle(size: 16)).onTap(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JTReviewScreenUser(id: widget.id)),
                              );
                            })
                            : Text('No reviews yet', style: secondaryTextStyle(size: 16)).onTap(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JTReviewScreenUser(id: widget.id)),
                              );
                            })
                          ],
                        ),
                      ],
                      ).paddingAll(16),
                      Divider(height: 20,color: Colors.black26),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // (fullname == "" && address == "")
                          // ? Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Row(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Text('Please come to', style: primaryTextStyle()),
                          //             10.width,
                          //             Text('[ add receiver ]', style: boldTextStyle()).expand(),
                          //           ],
                          //         ).expand(),
                          //         Container(
                          //           padding: EdgeInsets.all(4),
                          //           decoration: BoxDecoration(border: Border.all(color: appColorPrimary), borderRadius: BorderRadius.circular(3)),
                          //           child: Text('Add address', style: primaryTextStyle()),
                          //         ).onTap(() async {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                 builder: (context) => JTChangeAddressScreen(
                          //                   id: widget.id,
                          //                   page: widget.page,
                          //                 ),
                          //               ));
                          //         }),
                          //       ],
                          //     ),
                          //     4.height,
                          //     Text(address, style: secondaryTextStyle()),
                          //     16.height,
                          //     Divider(height: 0),
                          //   ],
                          // )
                          // : Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Row(
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Text('Please come to', style: primaryTextStyle()),
                          //             10.width,
                          //             Text(fullname, style: boldTextStyle()).expand(),
                          //           ],
                          //         ).expand(),
                          //         Container(
                          //           padding: EdgeInsets.all(4),
                          //           decoration: BoxDecoration(border: Border.all(color: appColorPrimary), borderRadius: BorderRadius.circular(3)),
                          //           child: Text('Change', style: primaryTextStyle()),
                          //         ).onTap(() async {
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                 builder: (context) => JTChangeAddressScreen(
                          //                   id: widget.id,
                          //                   page: widget.page,
                          //                 ),
                          //               ));
                          //         }),
                          //       ],
                          //     ),
                          //     4.height,
                          //     Text(address, style: secondaryTextStyle()),
                          //     16.height,
                          //     Divider(height: 0),
                          //   ],
                          // ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 20, 10, 30),
                            child: Text(
                              desc.replaceAll("<br>", "\n"),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tags: ",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Operating Hours: ",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Available Day: ",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      hours,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    (days.split(",").length <= 3)
                                    ? Text(
                                      days,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    )
                                    : (days.split(",").length == 4)
                                    ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          days.split(",")[0] + "," + days.split(",")[1] + "," + days.split(",")[2],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          days.split(",")[3],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    )
                                    : (days.split(",").length == 5)
                                    ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          days.split(",")[0] + "," + days.split(",")[1] + "," + days.split(",")[2],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          days.split(",")[3] + "," + days.split(",")[4],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    )
                                    : (days.split(",").length ==6)
                                    ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          days.split(",")[0] + "," + days.split(",")[1] + "," + days.split(",")[2],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          days.split(",")[3] + "," + days.split(",")[4] + "," + days.split(",")[5],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    )
                                    : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          days.split(",")[0] + "," + days.split(",")[1] + "," + days.split(",")[2],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          days.split(",")[3] + "," + days.split(",")[4] + "," + days.split(",")[5],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          days.split(",")[6],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                  ],
                                ),
                              ],
                            )
                          ),
                          Divider(height: 0),
                        ],
                      ).paddingAll(16),
                      (by == "Package" || by == "Package ")
                          ? JTsettingItem(context, 'Packages', leading: Icon(FontAwesome.list, color: Color(0xFF0A79DF), size: 18), textSize: 15, padding: 0.0, onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: appStore.scaffoldBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                          ),
                          builder: (builder) {
                            return SingleChildScrollView(
                              padding: EdgeInsets.all(16),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _package,
                                ),
                              ),
                            );
                          },
                        );
                      })
                          : Container(),
                      JTsettingItem(context, 'Location Available', leading: Icon(MaterialCommunityIcons.map_marker, color: Color(0xFF0A79DF)), textSize: 15, padding: 0.0, onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: appStore.scaffoldBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                          ),
                          builder: (builder) {
                            return SingleChildScrollView(
                              padding: EdgeInsets.all(16),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _location,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            (email != proid)
            ? Positioned(bottom: 0, child: buttonWidget())
            : Container(),
          ],
        ),
        useFullWidth: true,
      ),
    );
  }
}

void locationAvailable(BuildContext aContext) {
  showModalBottomSheet(
    context: aContext,
    backgroundColor: appStore.scaffoldBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (builder) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Johor Bahru",
                        style: boldTextStyle(size: 15),
                        maxLines: 2,
                      ),
                      4.height,
                    ],
                  ).expand()
                ],
              ),
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Taman Baru Uda",
                        style: boldTextStyle(size: 15),
                        maxLines: 2,
                      ),
                      4.height,
                    ],
                  ).expand()
                ],
              ),
              16.height,
            ],
          ),
        ),
      );
    },
  );
}


class DisplayPackage extends StatefulWidget {
  const DisplayPackage({Key? key, required this.searchkey}) : super(key: key);
  final String searchkey;
  @override
  _DisplayPackageState createState() => _DisplayPackageState();
}

class _DisplayPackageState extends State<DisplayPackage> {

  // functions starts //

  List category = [];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectcategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });
  }

  // functions ends //

  @override
  Widget build(BuildContext aContext) {
    return Container();
  }
}

void packagesAvailable(BuildContext aContext) {
  showModalBottomSheet(
    context: aContext,
    backgroundColor: appStore.scaffoldBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (builder) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jamuan Hari Jadi (100 pax) RM 500",
                        style: boldTextStyle(size: 15),
                        maxLines: 2,
                      ),
                      4.height,
                    ],
                  ).expand()
                ],
              ),
              16.height,
            ],
          ),
        ),
      );
    },
  );
}

void mMoreOfferBottomSheet(BuildContext aContext) {
  showModalBottomSheet(
    context: aContext,
    backgroundColor: appStore.scaffoldBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (builder) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.truck_delivery, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("\$10 Delivery in 2 days, Monday", style: boldTextStyle()),
                      4.height,
                      Text(
                        "lorem meh",
                        style: secondaryTextStyle(size: 14),
                        maxLines: 2,
                      ),
                    ],
                  ).expand()
                ],
              ),
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(FontAwesome.exchange, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("7 Days return policy", style: boldTextStyle()),
                      4.height,
                      Text(
                        "lorem meh",
                        style: secondaryTextStyle(size: 14),
                        maxLines: 2,
                      ),
                    ],
                  ).expand()
                ],
              ),
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialIcons.attach_money, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cash on Delivery", style: boldTextStyle()),
                      4.height,
                      Text(
                        "lorem meh",
                        style: secondaryTextStyle(size: 14),
                        maxLines: 2,
                      ),
                    ],
                  ).expand()
                ],
              ),
              16.height,
            ],
          ),
        ),
      );
    },
  );
}

class AlertCompleteProfile extends StatefulWidget {
  @override
  _AlertCompleteProfileState createState() => _AlertCompleteProfileState();
}

class _AlertCompleteProfileState extends State<AlertCompleteProfile> {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: appStore.iconColor),
                    onPressed: () {
                      finish(context);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.network(
                      "https://bobdomo.com/jobtuneai/JobTune/gig/JobTune/assets/mobile/warn.jpg",
                      width: context.width() * 0.70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              10.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Please complete your profile.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Please make sure your details such as name, phone number, NRIC Number, gender, race, address, and profile picture has been completed by you before proceed with booking..",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          finish(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Later", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                      5.width,
                      GestureDetector(
                        onTap: () {
                          finish(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JTProfileScreenUser()),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Go to Profile", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}

class AlertLoginFirst extends StatefulWidget {
  @override
  _AlertLoginFirstState createState() => _AlertLoginFirstState();
}

class _AlertLoginFirstState extends State<AlertLoginFirst> {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: appStore.iconColor),
                    onPressed: () {
                      finish(context);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.network(
                      "https://jobtune.ai/gig/JobTune/assets/mobile/resized/hr.jpg",
                      width: context.width() * 0.70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              10.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login with Us! ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "We need you to login with us first so that our provider would know who are their future client.",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          finish(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Later", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                      5.width,
                      GestureDetector(
                        onTap: () {
                          finish(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JTSignInScreen()),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Login Now", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}