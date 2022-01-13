import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/Banking/utils/BankingContants.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTServiceListCategory.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/searching-result/JTSearchingResultUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/main/utils/rating_bar.dart';

import 'JTProductDetailWidget.dart';

class JTDashboardWidgetUser extends StatefulWidget {
  static String tag = '/JTDashboardWidgetUser';

  @override
  _JTDashboardWidgetUserState createState() => _JTDashboardWidgetUserState();
}

class _JTDashboardWidgetUserState extends State<JTDashboardWidgetUser> {
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
            server + "jtnew_user_selectavailablecategory&city="+city
                +"&state="+state
                +"&country="+country
        ),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/'+category[m]["icon"]));
    }
  }

  List category = [];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectavailablecategory&city=&state=&country="),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/'+category[m]["icon"]));
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
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: (clocking.length > 0) ? 520.0 : 240.0,
              floating: true,
              pinned: true,
              snap: false,
              automaticallyImplyLeading : false,
              backgroundColor: appStore.appBarColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                color: appColorPrimary,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                              ),
                            ).visible(false),
                            Column(
                              children: [
                                10.height,
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Form(
                                    key: formKey,
                                    child: TextFormField(
                                      controller: searchCont,
                                      style: primaryTextStyle(),
                                      decoration: InputDecoration(
                                        labelText: 'Search',
                                        suffixIcon: IconButton(
                                          onPressed: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => JTSearchingResultUser(
                                                searchkey: searchCont.text,
                                              )),
                                            );
                                          },
                                          icon: Icon(Icons.search),
                                        ),
                                        contentPadding: EdgeInsets.all(16),
                                        labelStyle: secondaryTextStyle(),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                                      ),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        10.height,
                        Text(' Services Categories', style: boldTextStyle()).paddingAll(8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(right: 8, top: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: categories.map((e) {
                              return Container(
                                width: isMobile ? 100 : 120,
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: appColorPrimary),
                                      child: Image.asset(e.icon!, height: 30, width: 30, color: white),
                                    ),
                                    4.height,
                                    Text(
                                        e.name!,
                                        style: primaryTextStyle(size: 12),
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ],
                                ),
                              ).onTap(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => JTServiceListCategory(
                                    searchkey: e.name!,
                                  )),
                                );
                              });
                            }).toList(),
                          ),
                        ),
                        25.height,
                        (clocking.length > 0)
                            ? Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(' Standby List', style: boldTextStyle()).paddingAll(8),
                              ],
                            ),
                            6.height,
                            SizedBox(
                                height: width * 0.63,
                                child: JTNextList()
                            ),
                          ],
                        )
                            : Container(),
                        Text('    Featured', style: boldTextStyle()).paddingBottom(8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
            height: 500,
            child: JTServiceListUser(),
        ),
      )
    );
  }
}



class JTServiceListUser extends StatefulWidget {
  @override
  _JTServiceListUserState createState() => _JTServiceListUserState();
}

class _JTServiceListUserState extends State<JTServiceListUser> {

  // functions starts //

  List profile = [];
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(lgid == "null"){
      serviceList();
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

      checkFeatured(profile[0]["city"],profile[0]["state"],profile[0]["country"]);
    }
  }

  List servicelist = [];
  Future<void> checkFeatured(city,state,country) async {
    print(server + "jtnew_user_selectfeatured&city="+city
        +"&state="+state
        +"&country="+country);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectfeatured&city="+city
                +"&state="+state
                +"&country="+country
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });
  }

  Future<void> serviceList() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectfeatured&city=&state=&country="
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
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
      itemCount: servicelist == null ? 0 : servicelist.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => JTServiceDetailScreen(
                    id: servicelist[index]["service_id"],
                    page: "detail",
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
                        "https://jobtune.ai/gig/JobTune/assets/img/" + servicelist[index]["profile_pic"],
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
                    Text(servicelist[index]["location"], style: secondaryTextStyle(size: 13)),
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
            server + "jtnew_provider_selectpackage&id=" + widget.id),
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
      print("result:" + min.toString()+" "+max.toString());
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
            JTpriceWidget(min),
            Text(
              " ~ ",
            style: TextStyle(
                fontSize: 18,
              ),
            ),
            JTpriceWidget(max),
          ],
        )
        : JTpriceWidget(min),
      ],
    );
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
            server + "jtnew_user_selectaveragerating&id=" + widget.id),
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

class ShowsRating extends StatefulWidget {
  const ShowsRating({
    Key? key,
    required this.show,
  }) : super(key: key);
  final String show;
  @override
  _ShowsRatingState createState() => _ShowsRatingState();
}

class _ShowsRatingState extends State<ShowsRating> {

  // functions starts //

  @override
  void initState() {
    super.initState();
  }

  // function ends //


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IgnorePointer(
          child: RatingBar(
            onRatingChanged: (r) {},
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            initialRating: double.parse(double.parse(widget.show).toStringAsFixed(1)),
            maxRating: 5,
            filledColor: Colors.yellow,
            size: 14,
          ),
        ),
        5.width,
        Text('${double.parse(double.parse(widget.show).toStringAsFixed(1))}', style: secondaryTextStyle(size: 12)),
      ],
    );
  }
}


class JTNextList extends StatefulWidget {
  @override
  _JTNextListState createState() => _JTNextListState();
}

class _JTNextListState extends State<JTNextList> {

  // functions starts //

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

  @override
  void initState() {
    super.initState();
    this.readClocking();
  }

  // functions ends //
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.all(8),
        itemCount: clocking == null ? 0 : clocking.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              showInDialog(context,
                  child: BookingDetail(
                    bid: clocking[index]["booking_id"],
                    name: clocking[index]["name"],
                    packname: clocking[index]["package_name"],
                    start: clocking[index]["service_start"],
                    hr: clocking[index]["package_quantity"],
                    desc: clocking[index]["description"],
                    address: clocking[index]["location"],
                    guest: clocking[index]["first_name"] + " " + clocking[index]["last_name"],
                  ),
                  backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
            },
            child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: FractionalOffset.centerLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network("https://jobtune.ai/gig/JobTune/assets/img/" + clocking[index]["profile_pic"], height: width * 0.38, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
                        )),
                    Container(
                      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                      margin: EdgeInsets.only(left: 10, right: 10, top: 0),
                      decoration: BoxDecoration(
                        color: white,
                        shape: BoxShape.rectangle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Colors.grey, blurRadius: 0.5, spreadRadius: 1),
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(clocking[index]["name"], style: primaryTextStyle(fontFamily: fontMedium), maxLines: 2),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("Starts at: "+clocking[index]["service_start"] + " (" + clocking[index]["package_quantity"]+" Hr)",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    ),),
                                  InkWell(
                                    onTap: () async {
                                      List<Location> locations = await locationFromAddress(clocking[index]["location"]);
                                      print("coordinate: ");
                                      print(locations[0].toString().split(",")[0].split(": ")[1]);
                                      print(locations[0].toString().split(",")[1].split(": ")[1]);
                                      var latitude = locations[0].toString().split(",")[0].split(": ")[1];
                                      var longitude = locations[0].toString().split(",")[1].split(": ")[1];

                                      String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                                      if (await canLaunch(googleUrl)) {
                                        await launch(googleUrl);
                                      } else {
                                        throw 'Could not open the map.';
                                      }
                                    },
                                    child: Text(
                                      "Go",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontMedium,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          );
        }
    );
  }
}

class BookingDetail extends StatefulWidget {
  const BookingDetail({
    Key? key,
    required this.bid,
    required this.name,
    required this.packname,
    required this.start,
    required this.hr,
    required this.desc,
    required this.address,
    required this.guest,

  }) : super(key: key);
  final String bid;
  final String name;
  final String packname;
  final String start;
  final String hr;
  final String desc;
  final String address;
  final String guest;

  @override
  _BookingDetailState createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {


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
                  Text('Booking Details', style: boldTextStyle(size: 18)),
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
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Booking ID: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "JT"+ widget.bid,
                      ),
                    ],
                  ),
                  5.height,
                  Row(
                    children: [
                      Text(
                        "Service: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        widget.name,
                      ),
                    ],
                  ),
                  (widget.packname == widget.name)
                  ? Container()
                  : Column(
                    children: [
                      5.height,
                      Row(
                        children: [
                          Text(
                            "Package: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            widget.packname,
                          ),
                        ],
                      ),
                    ],
                  ),
                  5.height,
                  (widget.packname == widget.name)
                  ? Row(
                    children: [
                      Text(
                        "Start: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        widget.start + " ( " + widget.hr + " Hr )",
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      Text(
                        "Start: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        widget.start + " ( est: " + widget.hr + " Hr )",
                      ),
                    ],
                  ),
                  25.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Customer Details', style: boldTextStyle(size: 18)),
                    ],
                  ),
                  20.height,
                  Row(
                    children: [
                      Text(
                        "Name: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        widget.guest,
                      ),
                    ],
                  ),
                  5.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Address: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        widget.address.replaceAll(",",",\n"),
                      ),
                    ],
                  ),
                  (widget.desc != "")
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      15.height,
                      Text(
                        "Remarks: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(widget.desc)
                          )
                        ],
                      )
                    ],
                  )
                  : Container(),
                ],
              ),
              30.height,
              GestureDetector(
                onTap: () async {
                  finish(context);
                  List<Location> locations = await locationFromAddress(widget.address);
                  print("coordinate: ");
                  print(locations[0].toString().split(",")[0].split(": ")[1]);
                  print(locations[0].toString().split(",")[1].split(": ")[1]);
                  var latitude = locations[0].toString().split(",")[0].split(": ")[1];
                  var longitude = locations[0].toString().split(",")[1].split(": ")[1];

                  String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                  if (await canLaunch(googleUrl)) {
                    await launch(googleUrl);
                  } else {
                    throw 'Could not open the map.';
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Go Now", style: boldTextStyle(color: white)),
                        5.width,
                        Icon(Icons.location_pin, color: Colors.white, size: 16)
                      ],
                    ),
                  ),
                ),
              ),
              10.height,
              GestureDetector(
                onTap: () {
                  finish(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Center(
                    child: Text("Close", style: boldTextStyle(color: white)),
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