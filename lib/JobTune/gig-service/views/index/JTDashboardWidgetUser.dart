import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'dart:math';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/Banking/utils/BankingContants.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardWidgetGuest.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTServiceListCategory.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/searching-result/JTSearchingResultUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTCartScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTCategoryDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSearchScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSignInScreen.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/main/utils/rating_bar.dart';

import 'JTProductDetailScreen.dart';
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

  // functions ends //


  @override
  void initState() {
    super.initState();
    this.readCategory();
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
    Widget searchTxt() {
      return Container(
        width: dynamicWidth(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: viewLineColor),
          color: appStore.scaffoldBackground,
        ),
        margin: EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(AntDesign.search1, color: appStore.textSecondaryColor),
            10.width,
            Text('Search', style: boldTextStyle(color: appStore.textSecondaryColor)),
          ],
        ),
        padding: EdgeInsets.all(10),
      ).onTap(() {
        DTSearchScreen().launch(context);
      });
    }

    Widget horizontalList() {
      return SingleChildScrollView(
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
                  Text(e.name!, style: primaryTextStyle(size: 12), maxLines: 1, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
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
      );
    }

    Widget horizontalProductListView() {
      return ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: (_, index) {
          DTProductModel data = getProducts()[index];

          return Container(
            decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.appBarColor!),
            width: 220,
            margin: EdgeInsets.only(right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                10.height,
                Stack(
                  children: [
                    Image.asset(
                      'images/dashboard/ic_chair2.jpg',
                      fit: BoxFit.fitHeight,
                      height: 180,
                      width: context.width(),
                    ).cornerRadiusWithClipRRect(8),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: data.isLiked.validate() ? Icon(Icons.favorite, color: Colors.red, size: 16) : Icon(Icons.favorite_border, size: 16),
                    ),
                  ],
                ).expand(),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                    4.height,
                    Row(
                      children: [
                        IgnorePointer(
                          child: RatingBar(
                            onRatingChanged: (r) {},
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            initialRating: data.rating!,
                            maxRating: 5,
                            filledColor: Colors.yellow,
                            size: 14,
                          ),
                        ),
                        5.width,
                        Text('${data.rating}', style: secondaryTextStyle(size: 12)),
                      ],
                    ),
                    4.height,
                    Row(
                      children: [
                        priceWidget(data.discountPrice),
                        8.width,
                        priceWidget(data.price, applyStrike: true),
                      ],
                    ),
                  ],
                ).paddingAll(8),
                10.height,
              ],
            ),
          ).onTap(() async {
            int? index = await JTProductDetail(productModel: data).launch(context);
            if (index != null) appStore.setDrawerItemIndex(index);
          });
        },
        /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.width() > 1550
                        ? 4
                        : context.width() > 1080
                            ? 3
                            : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: cardWidth / cardHeight,
                  ),*/
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: getProducts().length,
      );
    }

    Widget bannerWidget() {
      return Container(
        margin: EdgeInsets.only(left: 8),
        child: Row(
          children: [
            Image.asset('images/JobTune/banner/dt_advertise1.jpg', fit: BoxFit.cover).cornerRadiusWithClipRRect(8).expand(),
            8.width,
            Image.asset('images/JobTune/banner/dt_advertise2.jpg', fit: BoxFit.cover).cornerRadiusWithClipRRect(8).expand(),
            8.width,
            Image.asset('images/JobTune/banner/dt_advertise4.jpg', fit: BoxFit.cover).cornerRadiusWithClipRRect(8).expand(),
            8.width,
            Image.asset('images/JobTune/banner/dt_advertise3.jpg', fit: BoxFit.cover).cornerRadiusWithClipRRect(8).expand(),
          ],
        ),
      );
    }

    Widget mobileWidget() {
      return Container(
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

                    ],
                  ),
                ],
              ),
              10.height,
              Text(' Services Available', style: boldTextStyle()).paddingAll(8),
              horizontalList(),
              20.height,
              Text(' Featured', style: boldTextStyle()).paddingAll(8),
              ListView.builder(
                padding: EdgeInsets.all(8),
                itemBuilder: (_, index) {
                  DTProductModel data = getProducts()[index];

                  return Container(
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
                              Image.asset(
                                data.image!,
                                fit: BoxFit.cover,
                                height: 110,
                                width: 126,
                              ).cornerRadiusWithClipRRect(8),
                              Positioned(
                                right: 10,
                                top: 10,
                                child: data.isLiked.validate()
                                    ? Icon(Icons.favorite, color: Colors.red, size: 16)
                                    : Icon(Icons.favorite_border, size: 16),
                              ),
                            ],
                          ),
                        ),
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                            4.height,
                            Row(
                              children: [
                                IgnorePointer(
                                  child: RatingBar(
                                    onRatingChanged: (r) {},
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    initialRating: data.rating!,
                                    maxRating: 5,
                                    filledColor: Colors.yellow,
                                    size: 14,
                                  ),
                                ),
                                5.width,
                                Text('${data.rating}', style: secondaryTextStyle(size: 12)),
                              ],
                            ),
                            4.height,
                            Row(
                              children: [
//                                JTpriceWidget(data.discountPrice),
                                8.width,
//                                JTpriceWidget(data.price, applyStrike: true),
                              ],
                            ),
                          ],
                        ).paddingAll(8).expand(),
                      ],
                    ),
                  ).onTap(() async {
                    int? index = await JTProductDetail(productModel: data).launch(context);
                    if (index != null) appStore.setDrawerItemIndex(index);
                  });
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: getProducts().length,
              ),
            ],
          ),
        ),
      );
    }

    Widget webWidget() {
      return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 60),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('images/app/app_icon.png', height: 100),
                  25.width,
                  Container(
                    padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                    decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.circular(8)),
                    child: Text('Sign In', style: boldTextStyle(color: white, size: 18)),
                  ).onTap(() {
                    DTSignInScreen().launch(context);
                  }),
                  16.width,
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.shopping_cart, size: 30, color: appStore.iconColor),
                  ).onTap(() {
                    DTCartScreen().launch(context);
                  }),
                  16.width
                ],
              ),
              Container(
                margin: EdgeInsets.all(8),
                width: context.width(),
                decoration: boxDecoration(showShadow: true, radius: 10, bgColor: Colors.transparent),
                height: 280,
                child: Stack(
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
                    AnimatedPositioned(
                      duration: Duration(seconds: 1),
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: DotIndicator(
                        pageController: pageController,
                        pages: pages,
                        indicatorColor: appColorPrimary,
                        onDotTap: (index) {
                          selectedIndex = index;

                          pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.linear);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Text('Horizontal ListView', style: boldTextStyle()).paddingAll(8),
              8.height,
              horizontalList(),
              8.height,
              Text('Top Picks For You', style: boldTextStyle()).paddingAll(8),
              8.height,
              Container(height: 300, child: horizontalProductListView()),
              8.height,
              Text('Latest Offers For You', style: boldTextStyle()).paddingAll(8),
              8.height,
              bannerWidget(),
              8.height,
              Text('Recommended For You', style: boldTextStyle()).paddingAll(8),
              8.height,
              Container(height: 300, child: horizontalProductListView()),
              Text('Recommended Offers For You', style: boldTextStyle()).paddingAll(8),
              8.height,
              bannerWidget(),
            ],
          ),
        ),
      );
    }
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ContainerX(
        mobile: Container(
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
                        DTCategoryDetailScreen().launch(context);
                      });
                    }).toList(),
                  ),
                ),
                25.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(' Standby List', style: boldTextStyle()).paddingAll(8),
                  ],
                ),
                10.height,
                SizedBox(
                    height: width * 0.77,
                    child: JTNextList()
                ),
                Text(' Featured', style: boldTextStyle()).paddingAll(8),
                Container(
                  height: 500,
                  child: JTServiceListUser()
                ),
              ],
            ),
          ),
        ),
        web: webWidget(),
      ),
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
              "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectprofile&lgid=" + lgid),
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
    print("http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectfeatured&city="+city
        +"&state="+state
        +"&country="+country);
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectfeatured&city="+city
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
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectfeatured&city=&state=&country="
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
                    Text(servicelist[index]["name"], style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                    3.height,
                    DisplayRating(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                    15.height,
                    DisplayRate(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
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
              " to ",
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
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectstandby&id=" + lgid),
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
          return Container(
              width: MediaQuery.of(context).size.width / 1.5,
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: FractionalOffset.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network("http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + clocking[index]["profile_pic"], height: width * 0.38, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
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
                                Text("Starts at: ",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                  ),),
                                Text(" " +clocking[index]["service_start"] + " (" + clocking[index]["package_quantity"]+" Hr)",
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
              ));
        }
    );
  }
}