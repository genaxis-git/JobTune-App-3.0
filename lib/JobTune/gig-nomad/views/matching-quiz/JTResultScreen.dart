import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTServiceListCategory.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/account/employee/JTAccountScreenEmployee.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/index/JTDashboardScreenNomad.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/job-detail/JTJobDetailScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/searching-result/JTSearchingResultUser.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/Banking/utils/BankingContants.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/theme3/model/T3_Model.dart';
import 'package:prokit_flutter/theme3/screen/T3Listing.dart';
import 'package:prokit_flutter/theme3/utils/T3DataGenerator.dart';
import 'package:prokit_flutter/theme3/utils/T3Images.dart';
import 'package:prokit_flutter/theme3/utils/colors.dart';
import 'package:prokit_flutter/theme3/utils/strings.dart';

import '../../../../main.dart';
import 'JTMatchingQuiz.dart';
import 'JTResultScreen.dart';


class JTResultScreen extends StatefulWidget {
  static var tag = "/JTResultScreen";

  const JTResultScreen({
    Key? key,
    required this.id
  }) : super(key: key);
  final String id;

  @override
  JTResultScreenState createState() => JTResultScreenState();
}

class JTResultScreenState extends State<JTResultScreen> {

  PageController pageController = PageController();
  List<Widget> pages = [];
  List<CategoryModel> categories = [];

  int selectedIndex = 0;
  var formKey = GlobalKey<FormState>();
  var searchCont = TextEditingController();

  // functions starts //

  List profile = [];
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(lgid != "null") {
      http.Response response = await http.get(
          Uri.parse(
              server + "jtnew_user_selectprofile&lgid=" + lgid),
          headers: {"Accept": "application/json"}
      );

      this.setState(() {
        profile = json.decode(response.body);
      });

      print(profile[0]["city"]+profile[0]["state"]+profile[0]["country"]);
      checkCategory(profile[0]["city"],profile[0]["state"],profile[0]["country"]);
    }
    else {
      readCategory();
    }
  }

  Future<void> checkCategory(city,state,country) async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectavailablejob&city="+city
                +"&state="+state
                +"&country="+country
        ),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["job_category"], icon: 'images/defaultTheme/category/Man.png'));
    }
  }

  List category = [];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectavailablejob&city=&state=&country="),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["job_category"], icon: 'images/defaultTheme/category/Man.png'));
    }
  }

  List clocking = [];
  Future<void> readClocking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectstandby&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      clocking = json.decode(response.body);
    });
  }

  // functions ends //


  @override
  void initState() {
    super.initState();
    this.checkProfile();
    this.readClocking();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, 'Daily Job Matching'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JTAccountScreenEmployee()),
              );
            }),
      ),
      backgroundColor: appStore.scaffoldBackground,
      body: JTContainerX(
        mobile: Stack(
          children: [
            SafeArea(
              child: Observer(
                builder: (_) => Container(
                  color: appStore.scaffoldBackground,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.all(17),
                        child: Column(
                          children: [
                            Text("CHECK OUT THE LIST OF JOB YOU MAY TRY CURATED FOR YOUR MOOD", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87, fontFamily: "Bold"), maxLines: 3),
                            Text("\nHere are suggestion generated based on the result from the quiz.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.black54), maxLines: 3),
                          ],
                        ),
                      ),
                      Expanded(
                        child: JTJobListUser(id: widget.id),
                      ),
                      Container(height: 50,),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(bottom: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      alignment: Alignment.center,
                      width: context.width(),
                      decoration: BoxDecoration(gradient: LinearGradient(colors: <Color>[t3_colorPrimary, t3_colorPrimaryDark]), boxShadow: defaultBoxShadow()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Retake Quiz ",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          7.width,
                          Icon(
                              Icons.replay,
                              size: 18,
                              color: Colors.white,
                          ),
                        ],
                      )
                    ).onTap(() {
                      // Do your logic
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JTMatchingScreen1()),
                      );
                    })
                  ],
                )
            ),
          ],
        ),
      ),


    );
  }
}


class JTJobListUser extends StatefulWidget {
  const JTJobListUser({
    Key? key,
    required this.id
  }) : super(key: key);
  final String id;

  @override
  _JTJobListUserState createState() => _JTJobListUserState();
}

class _JTJobListUserState extends State<JTJobListUser> {

  // functions starts //

  String? cattype;
  List profile = [];
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    var total = int.parse(widget.id);
    if(total >= 7 && total <= 9){
      cattype = "Front";
    }
    else if(total == 6){
      cattype = "any";
    }
    else if(total <= 5){
      cattype = "Back";
    }

    if(lgid == "null"){
      serviceList(cattype);
    }
    else {
      http.Response response = await http.get(
          Uri.parse(
              server + "jtnew_user_selectprofile&lgid=" + lgid),
          headers: {"Accept": "application/json"}
      );

      this.setState(() {
        profile = json.decode(response.body);
      });

      checkFeatured(profile[0]["city"],profile[0]["state"],profile[0]["country"],cattype);
    }
  }

  List joblist = [];
  Future<void> checkFeatured(city,state,country,cattype) async {
    print(server + "jtnew_user_selectsuggestjob&city="+city
        +"&state="+state
        +"&country="+country
        +"&type="+cattype);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectsuggestjob&city="+city
                +"&state="+state
                +"&country="+country
                +"&type="+cattype
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      joblist = json.decode(response.body);
    });
  }

  Future<void> serviceList(cattype) async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectsuggestjob&city=&state=&country=&type="+cattype
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      joblist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkProfile();
  }

  // functions ends //
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: joblist == null ? 0 : joblist.length,
        itemBuilder: (BuildContext context, int index) {
          final DateFormat formatter = DateFormat('d MMM yyyy');
          final String formatted = formatter.format(DateTime.parse(joblist[index]["job_startdate"]));
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JTJobDetailScreen(
                      id: joblist[index]["job_id"],
                    )),
              );
            },
            child: Container(
              decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.appBarColor!),
              margin: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    width: 126,
                    child: Stack(
                      children: [
                        Image.network(
                          image + joblist[index]["profile_pic"],
                          fit: BoxFit.cover,
                          height: 110,
                          width: 126,
                        ).cornerRadiusWithClipRRect(8),
                        Positioned(
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                                color: (joblist[index]["job_type"] == "Gig")
                                    ? Colors.lightBlueAccent
                                    : (joblist[index]["job_type"] == "Contract")
                                    ? Colors.green
                                    : Colors.orangeAccent,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ) // green shaped
                            ),
                            child: Text(joblist[index]["job_type"],style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(joblist[index]["job_name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                              fontSize: 17
                          )
                      ),
                      3.height,
                      JTpriceWidget(double.parse(double.parse(joblist[index]["job_rate"]).toStringAsFixed(2))),
                      5.height,
                      Text("Starts at " + formatted, style: secondaryTextStyle(size: 13)),
                      10.height,
                      Text(joblist[index]["job_city"], style: secondaryTextStyle(size: 13)),
                    ],
                  ).paddingAll(8).expand(),
                ],
              ),
            ),
          );
        }
    );
  }
}