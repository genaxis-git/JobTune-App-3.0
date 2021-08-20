import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/main/utils/rating_bar.dart';

import 'JTDashboardScreenGuest.dart';


class JTServiceListCategory extends StatefulWidget {
  static String tag = '/JTServiceListCategory';

  const JTServiceListCategory({Key? key, required this.searchkey}) : super(key: key);
  final String searchkey;

  @override
  _JTServiceListCategoryState createState() => _JTServiceListCategoryState();
}

class _JTServiceListCategoryState extends State<JTServiceListCategory> {
  PageController pageController = PageController();
  List<Widget> pages = [];
  List<CategoryModel> categories = [];

  int selectedIndex = 0;
  var formKey = GlobalKey<FormState>();
  var searchCont = TextEditingController();

  // functions starts //

  List category = [];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectcategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/Man.png'));
    }
  }

  List profile = [];
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(lgid != "null") {
      http.Response response = await http.get(
          Uri.parse(
              "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectprofile&lgid=" + lgid),
          headers: {"Accept": "application/json"}
      );

      this.setState(() {
        profile = json.decode(response.body);
      });

      print(profile[0]["city"]+profile[0]["state"]+profile[0]["country"]);
      checkFeatured(profile[0]["city"],profile[0]["state"],profile[0]["country"]);
    }
    else {
      checkService();
    }
  }

  List servicelist = [];
  Future<void> checkFeatured(city,state,country) async {
    print("http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectservicecategory&city="+city
        +"&state="+state
        +"&country="+country
        +"&category=" + widget.searchkey);
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectservicecategory&city="+city
                +"&state="+state
                +"&country="+country
                +"&category=" + widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    checkBig(city,state,country);
  }

  Future<void> checkService() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectservicecategory&city=&state=&country=&category="+widget.searchkey+"&big="
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    readBig();
  }

  List otherlist = [];
  List identifycat = [];
  Future<void> checkBig(city,state,country) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_identifybigcat&cat="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      identifycat = json.decode(response.body);
    });

    var bigcat = identifycat[0]["big_category"];
    checkOther(city,state,country,bigcat);
  }

  Future<void> readBig() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_identifybigcat&cat="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      identifycat = json.decode(response.body);
    });

    var bigcat = identifycat[0]["big_category"];
    allOther(bigcat);
  }

  Future<void> checkOther(city,state,country,bigcat) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectotherservice&city="+city
                +"&state="+state
                +"&country="+country
                +"&category="+widget.searchkey
                +"&big="+bigcat
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      otherlist = json.decode(response.body);
    });
  }

  Future<void> allOther(bigcat) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectotherservice&city=&state=&country=&category="+widget.searchkey+"&big="+bigcat
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      otherlist = json.decode(response.body);
    });
  }

  // functions ends //


  @override
  void initState() {
    super.initState();
    this.readCategory();
    this.checkProfile();
//    init();
  }

  init() async {
    categories.add(CategoryModel(name: 'Baby Sitting', icon: 'images/defaultTheme/category/kids.png'));
    categories.add(CategoryModel(name: 'Mobile Salon', icon: 'images/defaultTheme/category/women.png'));
    categories.add(CategoryModel(name: 'Home Tuition/ Tutor', icon: 'images/defaultTheme/category/furniture.png'));
    categories.add(CategoryModel(name: 'Languages', icon: 'images/defaultTheme/category/Tv.png'));
    categories.add(CategoryModel(name: 'Religious', icon: 'images/defaultTheme/category/stationary.png'));
    categories.add(CategoryModel(name: 'Kitchen Assistance', icon: 'images/defaultTheme/category/electronics.png'));
    categories.add(CategoryModel(name: 'Runner', icon: 'images/defaultTheme/category/Man.png'));
    categories.add(CategoryModel(name: 'Server', icon: 'images/defaultTheme/category/women.png'));
    categories.add(CategoryModel(name: 'Data Entry', icon: 'images/defaultTheme/category/Tv.png'));
    categories.add(CategoryModel(name: 'Personal Shopper', icon: 'images/defaultTheme/category/fashion.png'));
    categories.add(CategoryModel(name: 'Lawn Mowing', icon: 'images/defaultTheme/category/Shoes.png'));
    categories.add(CategoryModel(name: 'Photographer', icon: 'images/defaultTheme/category/Man.png'));
    categories.add(CategoryModel(name: 'Personal Care', icon: 'images/defaultTheme/category/jewelry.png'));
    categories.add(CategoryModel(name: 'Coaching/ Training', icon: 'images/defaultTheme/category/sports.png'));

    pages = [
      Container(child: Image.asset('images/JobTune/banner/dt_advertise1.jpg', height: isMobile ? 150 : 350, fit: BoxFit.cover)),
      Container(child: Image.asset('images/JobTune/banner/dt_advertise2.jpg', height: isMobile ? 150 : 350, fit: BoxFit.cover)),
      Container(child: Image.asset('images/JobTune/banner/dt_advertise3.jpg', height: isMobile ? 150 : 350, fit: BoxFit.cover)),
      Container(child: Image.asset('images/JobTune/banner/dt_advertise4.jpg', height: isMobile ? 150 : 350, fit: BoxFit.cover)),
    ];

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, widget.searchkey),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JTDashboardScreenGuest()),
              );
            }),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              Text(' Services for Category ' + widget.searchkey, style: boldTextStyle()).paddingAll(8),
              Container(
                height: MediaQuery.of(context).size.height - 420,
                  child: JTServiceListUser(searchkey: widget.searchkey)
              ),
              10.height,
              Column(
                children: [
                  Image.network(
                      "http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/mobile/filter.jpg",
                      width: 250
                  ),
                  Text(
                    " We have more suggestions that may attract your interest. Let's start explore and browse together.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      JTDashboardSreenUser().launch(context, isNewTask: true);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Explore",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 18
                              )

                          ),
                          10.width,
                          Icon(Icons.work_outlined,color:Colors.white,size:18)
                        ],
                      ),
                    ),
                  ).paddingOnly(top: 10,left: 120,right: 120)
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}

class JTServiceListUser extends StatefulWidget {
  const JTServiceListUser({Key? key, required this.searchkey}) : super(key: key);
  final String searchkey;
  @override
  _JTServiceListUserState createState() => _JTServiceListUserState();
}

class _JTServiceListUserState extends State<JTServiceListUser> {

  // functions starts //

  List profile = [];
  String email = "";
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(lgid != "null") {
      http.Response response = await http.get(
          Uri.parse(
              "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectprofile&lgid=" + lgid),
          headers: {"Accept": "application/json"}
      );

      this.setState(() {
        profile = json.decode(response.body);
      });

      print(profile[0]["city"]+profile[0]["state"]+profile[0]["country"]);
      checkFeatured(profile[0]["city"],profile[0]["state"],profile[0]["country"]);
    }
    else {
      setState(() {
        email = lgid;
      });
      checkService();
    }
  }

  List servicelist = [];
  Future<void> checkFeatured(city,state,country) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectservicecategory&city="+city
                +"&state="+state
                +"&country="+country
                +"&category=" + widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    checkBig(city,state,country);
  }

  Future<void> checkService() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectservicecategory&city=&state=&country=&category="+widget.searchkey+"&big="
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    readBig();
  }

  List otherlist = [];
  List identifycat = [];
  Future<void> checkBig(city,state,country) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_identifybigcat&cat="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      identifycat = json.decode(response.body);
    });

    var bigcat = identifycat[0]["big_category"];
    checkOther(city,state,country,bigcat);
  }

  Future<void> readBig() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_identifybigcat&cat="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      identifycat = json.decode(response.body);
    });

    var bigcat = identifycat[0]["big_category"];
    allOther(bigcat);
  }

  Future<void> checkOther(city,state,country,bigcat) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectotherservice&city="+city
                +"&state="+state
                +"&country="+country
                +"&category="+widget.searchkey
                +"&big="+bigcat
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      otherlist = json.decode(response.body);
    });
  }

  Future<void> allOther(bigcat) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectotherservice&city=&state=&country=&category="+widget.searchkey+"&big="+bigcat
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      otherlist = json.decode(response.body);
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
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemCount: servicelist == null ? 0 : servicelist.length,
        itemBuilder: (BuildContext context, int index) {
          if(email != "null"){
            if(servicelist[index]["category"] == widget.searchkey) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JTServiceDetailScreen(
                          id: servicelist[index]["service_id"],
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
                              "http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + servicelist[index]["profile_pic"],
                              fit: BoxFit.cover,
                              height: 110,
                              width: 126,
                            ).cornerRadiusWithClipRRect(8),
                          ],
                        ),
                      ),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(servicelist[index]["name"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                  fontSize: 17
                              )
                          ),
                          3.height,
                          DisplayRating(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                          13.height,
                          DisplayRate(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                          5.height,
                          Text(servicelist[index]["location"], style: secondaryTextStyle(size: 14)),
                        ],
                      ).paddingAll(8).expand(),
                    ],
                  ),
                ),
              );
            }
            else{
              return Container();
            }
          }
          else{
            return GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JTServiceDetailScreen(
                        id: servicelist[index]["service_id"],
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
                            "http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + servicelist[index]["profile_pic"],
                            fit: BoxFit.cover,
                            height: 110,
                            width: 126,
                          ).cornerRadiusWithClipRRect(8),
                        ],
                      ),
                    ),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(servicelist[index]["name"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                                fontSize: 17
                            )
                        ),
                        3.height,
                        DisplayRating(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                        10.height,
                        DisplayRate(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                        7.height,
                        Text(servicelist[index]["location"], style: secondaryTextStyle(size: 14)),
                      ],
                    ).paddingAll(8).expand(),
                  ],
                ),
              ),
            );
          }
        }
    );
  }
}

class JTOtherLst extends StatefulWidget {
  const JTOtherLst({Key? key, required this.searchkey}) : super(key: key);
  final String searchkey;
  @override
  _JTOtherLstState createState() => _JTOtherLstState();
}

class _JTOtherLstState extends State<JTOtherLst> {

  // functions starts //

  List profile = [];
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(lgid != "null") {
      http.Response response = await http.get(
          Uri.parse(
              "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectprofile&lgid=" + lgid),
          headers: {"Accept": "application/json"}
      );

      this.setState(() {
        profile = json.decode(response.body);
      });

      print(profile[0]["city"]+profile[0]["state"]+profile[0]["country"]);
      checkFeatured(profile[0]["city"],profile[0]["state"],profile[0]["country"]);
    }
    else {
      checkService();
    }
  }

  List servicelist = [];
  Future<void> checkFeatured(city,state,country) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectservicecategory&city="+city
                +"&state="+state
                +"&country="+country
                +"&category=" + widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    checkBig(city,state,country);
  }

  Future<void> checkService() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectservicecategory&city=&state=&country=&category="+widget.searchkey+"&big="
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    readBig();
  }

  List otherlist = [];
  List identifycat = [];
  Future<void> checkBig(city,state,country) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_identifybigcat&cat="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      identifycat = json.decode(response.body);
    });

    var bigcat = identifycat[0]["big_category"];
    checkOther(city,state,country,bigcat);
  }

  Future<void> readBig() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_identifybigcat&cat="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      identifycat = json.decode(response.body);
    });

    var bigcat = identifycat[0]["big_category"];
    allOther(bigcat);
  }

  Future<void> checkOther(city,state,country,bigcat) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectotherservice&city="+city
                +"&state="+state
                +"&country="+country
                +"&category="+widget.searchkey
                +"&big="+bigcat
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      otherlist = json.decode(response.body);
    });
  }

  Future<void> allOther(bigcat) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectotherservice&city=&state=&country=&category="+widget.searchkey+"&big="+bigcat
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      otherlist = json.decode(response.body);
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
    if(otherlist.length > 0) {
      return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: otherlist == null ? 0 : otherlist.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JTServiceDetailScreen(
                        id: otherlist[index]["service_id"],
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
                            "http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + otherlist[index]["profile_pic"],
                            fit: BoxFit.cover,
                            height: 110,
                            width: 126,
                          ).cornerRadiusWithClipRRect(8),
                        ],
                      ),
                    ),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(otherlist[index]["name"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                                fontSize: 17
                            )
                        ),
                        3.height,
                        DisplayRating(id: otherlist[index]["service_id"],rate: otherlist[index]["rate"]),
                        10.height,
                        DisplayRate(id: otherlist[index]["service_id"],rate: otherlist[index]["rate"]),
                        7.height,
                        Text(otherlist[index]["location"], style: secondaryTextStyle(size: 14)),
                      ],
                    ).paddingAll(8).expand(),
                  ],
                ),
              ),
            );
          }
      );
    }
    else{
      return Center(
        child: Text(
          'Sorry, there is no service available in "' + widget.searchkey + '" for now..',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.blueGrey,
          ),
        ),
      );
    }
  }
}

class DisplayRating extends StatefulWidget {
  const DisplayRating({
    Key? key,
    required this.id,
    required this.rate,
  }) : super(key: key);
  final String id;
  final String rate;
  @override
  _DisplayRatingState createState() => _DisplayRatingState();
}

class _DisplayRatingState extends State<DisplayRating> {

  // functions starts //

  String averagerate = "0.0";
  Future<void> readAverage() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectaveragerating&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    setState(() {
      averagerate = response.body;
    });

    showRating(averagerate);
  }

  List<Widget> _children = [];
  void showRating(a){
    _children =
    List.from(_children)
      ..add(
          Row(
            children: [
              IgnorePointer(
                child: RatingBar(
                  onRatingChanged: (r) {},
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  initialRating: double.parse(double.parse(a).toStringAsFixed(1)),
                  maxRating: 5,
                  filledColor: Colors.yellow,
                  size: 14,
                ),
              ),
              5.width,
              Text('${double.parse(double.parse(a).toStringAsFixed(1))}', style: secondaryTextStyle(size: 12)),
            ],
          )
      );
  }

  @override
  void initState() {
    this.readAverage();
    super.initState();
  }

  // function ends //


  @override
  Widget build(BuildContext context) {
    return Row(
      children: _children,
    );
  }
}

class DisplayRate extends StatefulWidget {
  const DisplayRate({
    Key? key,
    required this.id,
    required this.rate,
  }) : super(key: key);
  final String id;
  final String rate;
  @override
  _DisplayRateState createState() => _DisplayRateState();
}

class _DisplayRateState extends State<DisplayRate> {

  // function starts //

  List servicelist = [];
  List numbers = [];
  double max = 0;
  double min = 0;
  Future<void> readPackage() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectpackage&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    for(var m=0;m<servicelist.length;m++) {
      numbers.add(servicelist[m]["package_rate"]);
    }

    min = double.parse(servicelist[0]["package_rate"]);
    for(var m=0;m<servicelist.length;m++) {
      if(double.parse(servicelist[m]["package_rate"])>max){
        max = double.parse(servicelist[m]["package_rate"]);
      }
      if(double.parse(servicelist[m]["package_rate"])<min){
        min = double.parse(servicelist[m]["package_rate"]);
      }
    }

    setState(() {
      print("result:" + min.toStringAsFixed(2) +" "+max.toStringAsFixed(2));
      min = min;
      max = max;
    });
  }

  @override
  void initState() {
    super.initState();
    this.readPackage();
  }
  // function ends //


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (widget.rate != "0.00")
            ? JTpriceWidget(double.parse(double.parse(widget.rate).toStringAsFixed(2)))
            : (min != max)
            ? Row(
          children: [
            JTpriceWidget(double.parse(min.toStringAsFixed(2))),
            Text(
              " to ",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            JTpriceWidget(double.parse(max.toStringAsFixed(2))),
          ],
        )
            : JTpriceWidget(double.parse(min.toStringAsFixed(2))),
      ],
    );
  }
}
