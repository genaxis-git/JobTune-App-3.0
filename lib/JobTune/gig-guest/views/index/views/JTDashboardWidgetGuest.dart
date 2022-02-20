import 'dart:async';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/Banking/utils/BankingContants.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTApps.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTNewVacancies.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/searching-result/JTSearchingResultUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/dashboard/model/db5/Db5Model.dart';
import 'package:prokit_flutter/dashboard/utils/DbColors.dart';
import 'package:prokit_flutter/dashboard/utils/DbDataGenerator.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/rating_bar.dart';

import 'JTDashboardScreenGuest.dart';
import 'JTServiceListCategory.dart';

class JTDashboardWidgetGuest extends StatefulWidget {
  static String tag = '/JTDashboardWidgetGuest';

  @override
  _JTDashboardWidgetGuestState createState() => _JTDashboardWidgetGuestState();
}

class _JTDashboardWidgetGuestState extends State<JTDashboardWidgetGuest> {
//  PageController pageController = PageController();

  List<Widget> pages = [];
  List<CategoryModel> categories = [];
  List<Db6BestDestinationData> mListings1 = [];
  int selectedIndex = 0;

  late List<NewVacancies> mListings3;

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

      if(profile[0]["address"] != ""){
        readAddress();
      }
      else{
        readCategory();
      }
    }
    else {
      readCategory();
    }
  }

  List selectedaddress = [];
  String fullname = "";
  String address = "";
  String tag = "";
  String tagname = "";
  String city = "";
  String state = "";
  String addressread = "";
  String displayaddress = "";
  String displaystatus = "false";
  List displaylist = [];
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
        displaystatus = "true";
        setState(() {
          fullname = selectedaddress[m]["added_name"];
          city = selectedaddress[m]["added_city"];
          state = selectedaddress[m]["added_state"];
          addressread = selectedaddress[m]["added_address"];
          tagname = selectedaddress[m]["added_tag"];
          if(selectedaddress[m]["added_tag"] != "Home" && selectedaddress[m]["added_tag"] != "Work" && selectedaddress[m]["added_tag"] != "School" && selectedaddress[m]["added_tag"] != "Family") {
            tag = "pin";
          }
          else{
            tag = selectedaddress[m]["added_tag"];
          }

          if(addressread.split(",").length > 3) {
            displayaddress = addressread.split(",")[0] + "," + addressread.split(",")[1] + "," + addressread.split(",")[2];
          }
          else{
            displayaddress = addressread;
          }
        });

        checkCategory(selectedaddress[m]["added_city"],selectedaddress[m]["added_state"],selectedaddress[m]["added_country"]);
      }
    }
  }

  List category = [];
  Future<void> readCategory() async {
    print(server + "jtnew_user_selectavailablecategory");
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectavailablecategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/'+category[m]["icon"]));
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

    if(category.length > 4){
      for(var m=0;m<4;m++) {
        categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/'+category[m]["icon"]));
      }
    }
    else{
      for(var m=0;m<category.length;m++) {
        categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/'+category[m]["icon"]));
      }
    }
  }

  List taggings = [];
  List tags = [];
  List place = [];
  List placecount = [];
  Future<void> serviceList() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectfeatured&city=&state=&country="
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      taggings = json.decode(response.body);
    });

    for(var m=0;m<taggings.length;m++) {
      if(taggings[m]["service_type"] == "Remote"){
        if(tags.contains("WFH") == false){
          tags.add("WFH");
          countService("Online/ Remote/ From home", "country/remote.jpg");
        }
      }
      else{
        if(tags.contains(taggings[m]["state"]) == false){
          tags.add(taggings[m]["state"]);
          http.Response response = await http.get(
              Uri.parse(
                  server + "jtnew_user_selectimage&place=" + taggings[m]["state"]
              ),
              headers: {"Accept": "application/json"}
          );

          this.setState(() {
            place = json.decode(response.body);
          });

          countService(taggings[m]["state"],place[0]["place_image"]);
        }
      }
    }
  }

  Future<void> countService(states,img) async {

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_filterservice&keyword=" + states
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      placecount = json.decode(response.body);
    });

    if(states == "Wilayah Persekutuan Kuala Lumpur"){
      states = "Kuala Lumpur";
    }
    if(states == "Wilayah Persekutuan Putrajaya"){
      states = "Putrajaya";
    }
    if(states == "Wilayah Persekutuan Labuan"){
      states = "Labuan";
    }
    if(states == "Online/ Remote/ From home"){
      states = "WFH";
    }

    mListings1.add(Db6BestDestinationData(name: states, image: image + img, rating: placecount.length.toString()));

  }


  // functions ends //

  @override
  void initState() {
    super.initState();
    mListings3 = getJobList();
    this.checkProfile();
    this.serviceList();
    init();
    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 7) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  init() async {
    pages = [
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Home.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Home Tuition/ Tutor",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Religious.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Religious",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Baby Sitting.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Baby Sitting",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Photographer.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Photography",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            image: NetworkImage(image + 'category/Mobile Salon.jpg'),
            height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Mobile Salon",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            image: NetworkImage(image + 'category/Kitchen Assistant.jpg'),
            height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Kitchen Assistant",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Lawn Mowing.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Lawn Mowing",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            image: NetworkImage(image + 'category/Data Entry.jpg'),
            height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Data Entry",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
    ];

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  int _currentPage = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 420.0,
              floating: true,
              pinned: false,
              snap: false,
              automaticallyImplyLeading : true,
              backgroundColor: appStore.appBarColor,
              flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (displaystatus == "true")
                              ? Card(
                                child: InkWell(
                                  onTap: (){
                                    mExpandedSheet(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
                                    child: ListTile(
                                      leading: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 0.0, left: 12.0, right: 0.0, bottom: 0.0),
                                            child: Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset(
                                                      'images/widgets/materialWidgets/mwInputSelectionWidgets/Checkbox/'+tag+'.png',
                                                    ).image),
                                                shape: BoxShape.rectangle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        city + ", " + state,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Text(
                                        displayaddress,
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(' Services Categories', style: boldTextStyle()).paddingAll(8),
                                  Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)).onTap(() {
                                    appStore.setDrawerItemIndex(-1);
                                    JTDashboardSreenUser().launch(context, isNewTask: true);
                                  }),
                                ],
                              ),
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
                                      // JTServiceListCategory().launch(context);
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
                              20.height,
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            height: 170,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                PageView(
                                  controller: pageController,
                                  scrollDirection: Axis.horizontal,
                                  children: pages,
                                  onPageChanged: (index) {
                                    selectedIndex = index;
                                    setState(() {});
                                  },
                                ).cornerRadiusWithClipRRect(8),
                                DotIndicator(
                                  pages: pages,
                                  indicatorColor: appColorPrimary,
                                  pageController: pageController,
                                ),
                              ],
                            ),
                          ),
                          30.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(' Product Listing', style: boldTextStyle()).paddingAll(8),
                              Text('  Across Malaysia', style: boldTextStyle()).paddingAll(8),
                              Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)).onTap(() {
                                appStore.setDrawerItemIndex(-1);
                                JTDashboardSreenUser().launch(context, isNewTask: true);
                              }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
              ),
            ),
          ];
        },
        // body: Container(height: 390, child: JTProductList()),
        // body: Container(
        //   height: 500,
        //   child: JTServiceListUser(),
        // ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(left: 16, right: 16),
          child: StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            primary: false,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            staggeredTileBuilder: (index) => StaggeredTile.fit(2),
            itemCount: mListings1.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => Container(
              margin: EdgeInsets.only(left: 4, bottom: 4, top: 4),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JTSearchingResultUser(
                      searchkey: mListings1[index].name.toString(),
                      page: "gig-guest",
                    )),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Image.network(mListings1[index].image.toString()),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(mListings1[index].name.toString(), style: primaryTextStyle(color: Colors.white)),
                            Container(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                                  child: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.bodyText2,
                                      children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                                            child: Icon(Icons.people_outline, color: db5_yellow, size: 16),
                                          ),
                                        ),
                                        TextSpan(text: mListings1[index].rating, style: secondaryTextStyle(size: 14, color: db5_white, fontFamily: fontMedium)),
                                      ],
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(color: db5_black_trans, borderRadius: BorderRadius.all(Radius.circular(12)))
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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

      if(profile[0]["address"] != ""){
        readAddress();
      }
      else{
        serviceList();
      }

    }
  }

  List selectedaddress = [];
  String fullname = "";
  String address = "";
  String tag = "";
  String tagname = "";
  String city = "";
  String state = "";
  String addressread = "";
  String displayaddress = "";
  String displaystatus = "false";
  List displaylist = [];
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
        displaystatus = "true";
        setState(() {
          fullname = selectedaddress[m]["added_name"];
          city = selectedaddress[m]["added_city"];
          state = selectedaddress[m]["added_state"];
          addressread = selectedaddress[m]["added_address"];
          tagname = selectedaddress[m]["added_tag"];
          if(selectedaddress[m]["added_tag"] != "Home" && selectedaddress[m]["added_tag"] != "Work" && selectedaddress[m]["added_tag"] != "School" && selectedaddress[m]["added_tag"] != "Family") {
            tag = "pin";
          }
          else{
            tag = selectedaddress[m]["added_tag"];
          }

          if(addressread.split(",").length > 3) {
            displayaddress = addressread.split(",")[0] + "," + addressread.split(",")[1] + "," + addressread.split(",")[2];
          }
          else{
            displayaddress = addressread;
          }
        });

        checkFeatured(selectedaddress[m]["added_city"],selectedaddress[m]["added_state"],selectedaddress[m]["added_country"]);
      }
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
          if(index == 0){
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('    Featured', style: boldTextStyle()).paddingBottom(8),
                GestureDetector(
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
                                image + servicelist[index]["profile_pic"],
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
                                maxLines: 2,
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
                ),
              ],
            );
          }
          else{
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
                            image + servicelist[index]["profile_pic"],
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
                            maxLines: 2,
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
            ? Flexible(
          child: Text(
            "RM " + min.toStringAsFixed(2) + " ~ RM " + max.toStringAsFixed(2),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decoration: TextDecoration.none,
              color: appStore.textPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
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

mExpandedSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.2,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          color: appStore.scaffoldBackground,
          child: GestureDetector(
            onTap: () {
              finish(context);
            },
            child: AddressList(),
          ),
        );
      },
    ),
  );
}

class AddressList extends StatefulWidget {
  const AddressList({Key? key}) : super(key: key);

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {

  List addresslist = [];
  List ids = [];
  var gender1;

  Future<void> readAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectalladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      addresslist = json.decode(response.body);

      for(var m=0; m<addresslist.length; m++){
        if(addresslist[m]["added_status"] == "1"){
          ids.add(addresslist[m]["address_id"]);
        }
      }
    });
  }

  Future<void> allzero(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_user_updatealladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    selectedone(id);
  }

  Future<void> selectedone(id) async {
    http.get(
        Uri.parse(
            server + "jtnew_user_updateoneaddress&id=" + id),
        headers: {"Accept": "application/json"}
    );

    checkSelected(id);
  }

  List checkinglist = [];
  List arrlist = [];
  Future<void> checkSelected(a) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectalladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      checkinglist = json.decode(response.body);
    });

    for(var m=0;m<checkinglist.length;m++){
      arrlist.add(checkinglist[m]["added_status"]);
    }

    if(arrlist.contains("1") == false){
      print(arrlist);
      print("belum");
      print(a);
      selectedone(a);
    }
    else{
      print(arrlist);
      print("dah");
      arrlist = [];
      Navigator.pop(context);
      Navigator.pop(context);
      JTDashboardScreenGuest().launch(context, isNewTask: true);
      // readAddress("last");
    }
  }

  @override
  void initState() {
    super.initState();
    this.readAddress();
  }

  @override
  Widget build(BuildContext context) {

    void _onHorizontalLoading1() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: appStore.scaffoldBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  16.width,
                  CircularProgressIndicator(
                    backgroundColor: Color(0xffD6D6D6),
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                  16.width,
                  Text(
                    "Please Wait....",
                    style: primaryTextStyle(color: appStore.textPrimaryColor),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
        itemCount: addresslist == null ? 0 : addresslist.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: appStore.textPrimaryColor,
              ),
              child: RadioListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  secondary: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: (addresslist[index]["added_tag"] != "Home" && addresslist[index]["added_tag"] != "Work" && addresslist[index]["added_tag"] != "School" && addresslist[index]["added_tag"] != "Family")
                              ? Image.asset(
                            'images/widgets/materialWidgets/mwInputSelectionWidgets/Checkbox/pin.png',
                          ).image
                              : Image.asset(
                            'images/widgets/materialWidgets/mwInputSelectionWidgets/Checkbox/'+addresslist[index]["added_tag"]+'.png',
                          ).image
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  title: Text(
                    addresslist[index]["added_city"] + ", " + addresslist[index]["added_state"],
                    style: boldTextStyle(),
                  ),
                  subtitle: Text(
                    addresslist[index]["added_address"],
                    style: secondaryTextStyle(),
                  ),
                  value: addresslist[index]["address_id"],
                  groupValue: gender1,
                  onChanged: (dynamic value) {
                    _onHorizontalLoading1();
                    allzero(addresslist[index]["address_id"]);
                  }),
            ),
          );
        }
    );
  }
}