import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/theme10/models/T10Models.dart';
import 'package:prokit_flutter/theme10/utils/T10Colors.dart';
import 'package:prokit_flutter/theme10/utils/T10Constant.dart';
import 'package:prokit_flutter/theme10/utils/T10DataGenerator.dart';
import 'package:prokit_flutter/theme10/utils/T10Strings.dart';
import 'package:prokit_flutter/theme3/utils/colors.dart';
import 'package:prokit_flutter/theme8/utils/T8Colors.dart';

import '../../../../main.dart';
import 'JTServiceTagsScreen.dart';


class JTProviderPageScreen extends StatefulWidget {
  static String tag = '/JTProviderPageScreen';

  const JTProviderPageScreen({
    Key? key,
    required this.id,
    required this.provider
  }) : super(key: key);
  final String id;
  final String provider;

  @override
  JTProviderPageScreenState createState() => JTProviderPageScreenState();
}

class JTProviderPageScreenState extends State<JTProviderPageScreen> {
  late List<T10Images> mList;

  // starts function //

  List servicelist = [];
  Future<void> checkFeatured() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectserviceforpage&id="+widget.provider
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });

  }

  List likes = [];
  Future<void> readLikes() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selecttotallike&id="+widget.provider
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      likes = json.decode(response.body);
    });
  }

  List follows = [];
  String nums = "0";
  Future<void> readFollows() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectfollowing&id="+widget.provider
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      follows = json.decode(response.body);
    });

    setState(() {
      nums = follows.length.toString();
    });

    finish(context);
  }

  String img = "no profile.png";
  String providername = " ";
  String category = " ";
  String city = " ";
  String state = " ";
  String desc = " ";
  List provider = [];
  Future<void> readProvider() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectprofile&lgid=" + widget.provider),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      provider = json.decode(response.body);
    });

    setState(() {
      providername = provider[0]["name"];
      category = provider[0]["industry_type"];
      city = provider[0]["city"];
      state = provider[0]["state"];
      desc = provider[0]["description"];
      if(provider[0]["profile_pic"] != "") {
        img = provider[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
    });
  }

  // ends function //

  @override
  void initState() {
    super.initState();
    mList = getProfile();
    this.readProvider();
    this.checkFeatured();
    this.readFollows();
    this.readLikes();
  }

  void _onLoading() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appStore.scaffoldBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 100),
          content: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Color(0xffD6D6D6),
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                ),
                SizedBox(height: 16),
                Text("Loading...", style: primaryTextStyle(color: appStore.textPrimaryColor)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    var width = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.4,
                floating: false,
                pinned: true,
                titleSpacing: 0,
                backgroundColor: innerBoxIsScrolled ? Colors.blueGrey : t3_white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: appStore.scaffoldBackground,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: context.width(),
                          child: SafeArea(
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              color: appStore.appBarColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    color: appStore.iconColor,
                                    onPressed: () {
                                      // JTDashboardSreenUser().launch(context, isNewTask: true);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTServiceDetailScreen(
                                                id: widget.id,
                                                page: "detail"
                                            )),
                                      );
                                    },
                                  ),
                                  Center(
                                    child: text(
                                      "Profile",
                                      fontFamily: fontBold,
                                      textColor: appStore.textPrimaryColor,
                                      fontSize: textSizeLargeMedium,
                                    ),
                                  ),
                                  SizedBox(width: 50,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: spacing_standard_new),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(spacing_middle), bottomRight: Radius.circular(spacing_standard_new)),
                                        child: CachedNetworkImage(
                                          placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                                          imageUrl: image + img,
                                          fit: BoxFit.cover,
                                          height: width * 0.35,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: spacing_standard_new),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          text(providername, textColor: appStore.textPrimaryColor, fontFamily: fontMedium, fontSize: textSizeLargeMedium),
                                          text(category, textColor: appStore.textSecondaryColor),
                                          SizedBox(height: spacing_control),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: spacing_control),
                                                    child: Icon(Icons.location_on, color: appStore.iconColor, size: 18),
                                                  ),
                                                ),
                                                TextSpan(text: city + ", " + state, style: TextStyle(fontSize: textSizeMedium, color: appStore.textSecondaryColor)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: spacing_standard),
                                          Row(
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  text(servicelist.length.toString(), textColor: appStore.textPrimaryColor, fontFamily: fontMedium),
                                                  text("Posts", textColor: appStore.textSecondaryColor),
                                                ],
                                              ),
                                              Container(
                                                height: width * 0.1,
                                                width: 0.5,
                                                color: t10_view_color,
                                                margin: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new),
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  text(likes.length.toString(), textColor: appStore.textPrimaryColor, fontFamily: fontMedium),
                                                  text("Likes", textColor: appStore.textSecondaryColor),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  width: MediaQuery. of(context). size. width,
                                  margin: EdgeInsets.all(spacing_standard_new),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      text(theme10_about, textColor: appStore.textPrimaryColor, fontFamily: fontMedium, fontSize: textSizeLargeMedium),
                                      3.height,
                                      Text(desc.replaceAll("<br>", "\n"), style: secondaryTextStyle()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: t3_colorPrimary,
                    indicatorColor: t3_colorPrimary,
                    unselectedLabelColor: appStore.textPrimaryColor,
                    tabs: [
                      Tab(text: "Posts"),
                      Tab(text: "Followers (" + nums + ")"),
                      Tab(text: "Tags"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              Container(
                child: JTPostList(searchkey: widget.provider,),
              ),
              Container(
                margin: EdgeInsets.only(left: 8, top: 20, right: 8),
                child: JTFollowers(searchkey: widget.provider,),
              ),
              Container(
                margin: EdgeInsets.only(left: 3, top: 0, right: 3),
                child: JTTagList(searchkey: widget.provider,),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class JTPostList extends StatefulWidget {
  static String tag = '/JTPostList';

  const JTPostList({
    Key? key,
    required this.searchkey,
  }) : super(key: key);
  final String searchkey;

  @override
  JTPostListState createState() => JTPostListState();
}

class JTPostListState extends State<JTPostList> {
  late List<T10Product> mList;

  // starts function //

  List servicelist = [];
  Future<void> checkFeatured() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectserviceforpage&id="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });

  }

  // ends function //

  @override
  void initState() {
    super.initState();
    this.checkFeatured();
    mList = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    var width = MediaQuery.of(context).size.width;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: servicelist == null ? 0 : servicelist.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JTServiceDetailScreen(
                        id: servicelist[index]["service_id"],
                        page: "provider-page"
                    )),
              );
            },
            child: Container(
                margin: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new, bottom: spacing_standard_new),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(spacing_middle)),
                            child: CachedNetworkImage(
                              placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                              imageUrl: image + servicelist[index]["profile_pic"],
                              fit: BoxFit.cover,
                              height: width * 0.2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: spacing_standard_new,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(servicelist[index]["name"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: appStore.textSecondaryColor
                                  )
                              ),
                              Text(servicelist[index]["category"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                      color: appStore.textSecondaryColor,
                                      fontSize: 17
                                  )
                              ),
                              3.height,
                              // DisplayRating(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                              13.height,
                              DisplayRate(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                              5.height,
                              Text(servicelist[index]["location"], style: secondaryTextStyle(size: 13)),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: <Widget>[
                              //     Row(
                              //       children: <Widget>[
                              //         text(model.price, textColor: appStore.textSecondaryColor),
                              //         SizedBox(width: spacing_control),
                              //         text(model.subPrice, textColor: appStore.textSecondaryColor, lineThrough: true),
                              //       ],
                              //     ),
                              //     Row(
                              //       children: <Widget>[
                              //         Icon(Icons.remove_circle, color: t10_textColorSecondary, size: 20),
                              //         SizedBox(width: 4),
                              //         text("2", textColor: appStore.textSecondaryColor, fontFamily: fontMedium, fontSize: textSizeLargeMedium),
                              //         SizedBox(width: 4),
                              //         Icon(Icons.add_circle, color: t10_textColorSecondary, size: 20)
                              //       ],
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: spacing_standard_new),
                    Divider(color: t10_view_color, height: 0.5)
                  ],
                ))
          );
        });
  }
}


class JTFollowers extends StatefulWidget {
  static String tag = '/JTFollowers';

  const JTFollowers({
    Key? key,
    required this.searchkey,
  }) : super(key: key);
  final String searchkey;

  @override
  JTFollowersState createState() => JTFollowersState();
}

class JTFollowersState extends State<JTFollowers> {
  late List<T10Product> mList;

  // starts function //

  List follows = [];
  Future<void> readFollows() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectfollowing&id="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      follows = json.decode(response.body);
    });
  }

  // ends function //

  @override
  void initState() {
    super.initState();
    this.readFollows();
    mList = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    var width = MediaQuery.of(context).size.width;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: follows == null ? 0 : follows.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: (){
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => JTServiceDetailScreen(
                //           id: follows[index]["service_id"],
                //           page: "provider-page"
                //       )),
                // );
              },
              child: Container(
                  margin: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new, bottom: spacing_standard_new),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          (follows[index]["profile_pic"] != "")
                          ? Expanded(
                            child: Image.network(
                                image + follows[index]["profile_pic"],
                                height: 80,
                                fit: BoxFit.cover)
                                .cornerRadiusWithClipRRect(50),
                          )
                          : Expanded(
                            child: Image.network(
                                image + "no profile.png",
                                height: 80,
                                fit: BoxFit.cover)
                                .cornerRadiusWithClipRRect(50),
                          ),
                          SizedBox(
                            width: spacing_standard_new,
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                (follows[index]["first_name"] + " " + follows[index]["last_name"] != " ")
                                ? Text(follows[index]["first_name"] + " " + follows[index]["last_name"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: appStore.textSecondaryColor
                                    )
                                )
                                : Text("unknown",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: appStore.textSecondaryColor
                                    )
                                ),
                                (follows[index]["city"] + ", " + follows[index]["state"] != ", ")
                                ? Text(follows[index]["city"] + ", " + follows[index]["state"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        color: appStore.textSecondaryColor,
                                        fontSize: 17
                                    )
                                )
                                : Text("unknown",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        color: appStore.textSecondaryColor,
                                        fontSize: 17
                                    )
                                ),
                                3.height,
                                10.height,
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: spacing_standard_new),
                      Divider(color: Colors.blueGrey, height: 0.5)
                    ],
                  ))
          );
        });
  }
}


class JTTagList extends StatefulWidget {
  static String tag = '/JTTagList';

  const JTTagList({
    Key? key,
    required this.searchkey,
  }) : super(key: key);
  final String searchkey;

  @override
  JTTagListState createState() => JTTagListState();
}

class JTTagListState extends State<JTTagList> {
  late List<T10Product> mList;

  // starts function //

  List servicelist = [];
  List category = [];

  Future<void> checkFeatured() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_countservicecategory&id="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });
  }


  // ends function //

  @override
  void initState() {
    super.initState();
    this.checkFeatured();
    mList = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    var width = MediaQuery.of(context).size.width;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: servicelist == null ? 0 : servicelist.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JTServiceTagScreen(
                          id: servicelist[index]["category"],
                          provider: widget.searchkey
                      )),
                );
              },
              child: Container(
                margin: EdgeInsets.only(left: 16, bottom: 16, right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(image + "category/" + servicelist[index]["bgimage"]),
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.indigoAccent),
                          width: width / 7,
                          height: width / 7,
                          padding: EdgeInsets.all(12),
                          child: Image.asset('images/defaultTheme/category/' + servicelist[index]["icon"],color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              servicelist[index]["category"],
                              style: TextStyle(
                                fontFamily: fontMedium,
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900
                              ),
                            ),
                            Text(
                              servicelist[index]["COUNT(*)"] + " posts",
                              style: TextStyle(
                                fontFamily: fontMedium,
                                color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    // Text(, style: secondaryTextStyle()),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JTServiceTagScreen(
                                  id: servicelist[index]["category"],
                                  provider: widget.searchkey
                              )),
                        );
                      },
                      child: Container(
                          decoration: boxDecoration(bgColor: t8_colorPrimary, radius: 16),
                          padding: EdgeInsets.fromLTRB(16, 4, 16, 5),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Center(
                                child: text("View", textColor: Colors.white, fontFamily: fontMedium, textAllCaps: false),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: t8_colorPrimaryDark),
                                  width: 35,
                                  height: 35,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: t8_white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              )
          );
        });
  }
}




class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        decoration: boxDecoration(radius: 10, bgColor: appStore.isDarkModeOn ? appStore.scaffoldBackground : t3_gray, showShadow: true),
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
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
            : JTpriceWidget(double.parse(min.toStringAsFixed(2))),
      ],
    );
  }
}