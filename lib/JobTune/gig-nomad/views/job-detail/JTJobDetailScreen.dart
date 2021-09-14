
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/register-login/JTSignInScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import '../../../../main.dart';

bool package = true;

class JTJobDetailScreen extends StatefulWidget {
  static String tag = '/JTJobDetailScreen';

  const JTJobDetailScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _JTJobDetailScreenState createState() => _JTJobDetailScreenState();
}

class _JTJobDetailScreenState extends State<JTJobDetailScreen> {
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
      fullname = profile[0]["first_name"] + " " + profile[0]["last_name"] ;
      address = profile[0]["address"] ;
      telno = profile[0]["phone_no"] ;
      gender = profile[0]["gender"] ;
      race = profile[0]["race"] ;
      nric = profile[0]["nric"] ;
      pic = profile[0]["profile_pic"] ;
    });
  }

  List info = [];
  String img = "no profile.png";
  String name = "";
  String desc = "";
  String rate = "0.0";
  String category = "";
  String startdate = "";
  String enddate = "";
  String starttime = "";
  String endtime = "";
  String alamat = "";
  String phone = "";
  String emp = "";
  String needed = "";
  String pref = "";
  String jobtype = "";
  Future<void> readService() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_employer_selectjob&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      info = json.decode(response.body);
    });

    setState(() {
      name = info[0]["job_name"];
      desc = info[0]["job_description"];
      rate = info[0]["job_rate"];
      img = info[0]["profile_pic"];
      category = info[0]["job_category"];
      final DateFormat formatter = DateFormat('d MMM yyyy');
      startdate = formatter.format(DateTime.parse(info[0]["job_startdate"]));
      enddate = formatter.format(DateTime.parse(info[0]["job_enddate"]));
      starttime = info[0]["job_starttime"];
      endtime = info[0]["job_endtime"];
      alamat = info[0]["job_address"];
      phone = info[0]["phone_no"];
      emp = info[0]["email"];
      needed = info[0]["worker_needed"];
      pref = info[0]["job_gender"];
      jobtype = info[0]["job_type"];
    });
  }

  List servicelist = [];
  List numbers = [];
  String packagelist = "";
  double max = 0;
  double min = 0;
  Future<void> readPackage(b) async {
    print(server + "jtnew_provider_selectpackage&id=" + b);
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

  Future<void> sendApply() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_insertapplication&id=" + widget.id + "&name=" + lgid + "&empr=" + emp),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      averagerate = response.body;
    });

    toast("Application Sent!");
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

  @override
  void initState() {
    super.initState();
    this.readService();
    this.readProfile();
    this.readAverage();
    this.readTotal();
  }

  // function ends //

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }


  String hourcontroller = "00";
  String mincontroller = "00";
  int _hourController = 1;
  int _count = 0;
  List<Widget> _children = [];
  List<Widget> _package = [];
  List<Widget> _location = [];

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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => WebViewCalendar(id:proid)),
        // );
        // Do your logic
      });
    }

    Widget buyNowBtn() {
      return Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        width: context.width(),
        decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
        child: Text('Apply Now', style: boldTextStyle(color: white)),
      ).onTap(() {
        // Do your logic
        if(fullname != "" || telno != "" || nric != "" || gender != "" || race != "" || address != "" || pic != "") {
          sendApply();
        }
        else {
          showInDialog(context,
              child: AlertCompleteProfile(),
              backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
        }
      });
    }

    Widget loginBtn() {
      return Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        width: context.width(),
        decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
        child: Text('Login to Apply', style: boldTextStyle(color: white)),
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
          (email != "null")
              ? buyNowBtn()
              : loginBtn(),

        ],
      );
    }
    return Scaffold(
      appBar: JTappBar(context, 'Detail'),
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
                              name,
                              style: boldTextStyle(size: 18)
                          ),
                          10.height,
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              JTpriceWidget(double.parse(rate), fontSize: 28, textColor: Color(0xFF0A79DF)),
                            ],
                          ),
                          10.height,
                          Row(
                            children: [
                              8.width,
                            ],
                          ),
                        ],
                      ).paddingAll(16),
                      Divider(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              4.height,
                              Row(
                                children: [
                                  Icon(MaterialCommunityIcons.map_marker, color: Colors.grey, size:15),
                                  10.width,
                                  Container(
                                      child: Flexible(
                                        child: Text(alamat,
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(MaterialCommunityIcons.email, color: Colors.grey, size:15),
                                  10.width,
                                  Text(emp, style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(MaterialCommunityIcons.phone, color: Colors.grey, size:15),
                                  10.width,
                                  Text(phone, style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),),
                                ],
                              ),
                              16.height,
                              Divider(height: 0),
                            ],
                          ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    SizedBox(width: 110,),
                                    Text(
                                      category + " (" + jobtype + ")",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Preference: ",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 76,),
                                    Text(
                                      pref,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Open to: ",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 92,),
                                    Text(
                                      needed + " people",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Working Hours: ",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 52,),
                                    Text(
                                      starttime + " to " + endtime,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (jobtype == "Gig")
                                    ? Text(
                                      "Date: ",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                    : Text(
                                      "Start: ",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 114,),
                                    Container(
                                        height: 35,
                                        width: 185,
                                        child: Flexible(
                                            child: (jobtype == "Gig")
                                                ? Text(
                                                    startdate + " to " + enddate,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.justify,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                : Text(
                                                  startdate,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 16,
                                                  ),
                                            ),
                                        )
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                                SizedBox(height: 20,),
                              ],
                            ),
                          ),
                        ],
                      ).paddingAll(16),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(bottom: 0, child: buttonWidget()),
          ],
        ),
        useFullWidth: true,
      ),
    );
  }
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
                      "https://jobtune.ai/gig/JobTune/assets/mobile/warn.jpg",
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