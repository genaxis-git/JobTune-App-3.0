import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTApps.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTNewVacancies.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardProductWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/dashboard/model/db1/Db1Model.dart';
import 'package:prokit_flutter/dashboard/utils/DbDataGenerator.dart';
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
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/main/utils/rating_bar.dart';

import 'JTDashboardScreenGuest.dart';
import 'JTProductDetailScreenGuest.dart';
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

  int selectedIndex = 0;

  late List<NewVacancies> mListings3;

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
    mListings3 = getJobList();
    this.readCategory();
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
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Home.jpg'),
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
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Religious.jpg'),
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
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Baby Sitting.jpg'),
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
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Photographer.jpg'),
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
            image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Mobile Salon.jpg'),
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
            image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Kitchen Assistant.jpg'),
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
              image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Lawn Mowing.jpg'),
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
            image: NetworkImage('https://jobtune.ai/gig/JobTune/assets/img/category/Data Entry.jpg'),
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
    var width = MediaQuery.of(context).size.width;

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
              DTCategoryDetailScreen().launch(context);
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
            int? index = await JTProductDetailScreenGuest(productModel: data).launch(context);
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
                      15.height,
//                      searchTxt(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(' Services Available', style: boldTextStyle()).paddingAll(8),
                              Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)).onTap(() {
                                appStore.setDrawerItemIndex(-1);

                                if (isMobile) {
                                  JTDashboardSreenUser().launch(context, isNewTask: true);
                                } else {
//                                  DTDashboardScreen().launch(context, isNewTask: true);
                                }
                              }),
                            ],
                          ),
                          horizontalList(),
                          20.height,
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        height: 200,
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
                    ],
                  ),
                ],
              ),
              15.height,
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(' New Vacancies', style: boldTextStyle()).paddingAll(8),
              //     Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)),
              //   ],
              // ),
              // 10.height,
              // SizedBox(
              //   height: width * 0.55,
              //   child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: mListings3.length,
              //       shrinkWrap: true,
              //       itemBuilder: (context, index) {
              //         return Recommended(mListings3[index], index);
              //       }),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(' Product Listing', style: boldTextStyle()).paddingAll(8),
                  Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)),
                ],
              ),
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
                                child: data.isLiked.validate() ? Icon(Icons.favorite, color: Colors.red, size: 16) : Icon(Icons.favorite_border, size: 16),
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
                                priceWidget(data.discountPrice),
                                8.width,
                                priceWidget(data.price, applyStrike: true),
                              ],
                            ),
                          ],
                        ).paddingAll(8).expand(),
                      ],
                    ),
                  ).onTap(() async {
                    int? index = await JTProductDetailScreenGuest(productModel: data).launch(context);
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
                  searchTxt().expand(),
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
                        15.height,
//                      searchTxt(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(' Services Categories', style: boldTextStyle()).paddingAll(8),
                                Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)).onTap(() {
                                  appStore.setDrawerItemIndex(-1);

                                  if (isMobile) {
                                    JTDashboardSreenUser().launch(context, isNewTask: true);
                                  } else {
//                                  DTDashboardScreen().launch(context, isNewTask: true);
                                  }
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
                      ],
                    ),
                  ],
                ),
                15.height,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(' New Vacancies', style: boldTextStyle()).paddingAll(8),
                //     Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)),
                //   ],
                // ),
                // 10.height,
                // SizedBox(
                //   height: width * 0.55,
                //   child: ListView.builder(
                //       scrollDirection: Axis.horizontal,
                //       itemCount: mListings3.length,
                //       shrinkWrap: true,
                //       itemBuilder: (context, index) {
                //         return Recommended(mListings3[index], index);
                //       }),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(' Product Listing', style: boldTextStyle()).paddingAll(8),
                    Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)),
                  ],
                ),
                Container(height: 500, child: JTProductList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Recommended extends StatelessWidget {
  late NewVacancies model;

  Recommended(NewVacancies model, int pos) {
    this.model = model;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
        width: MediaQuery.of(context).size.width / 1.5,
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Container(
                alignment: FractionalOffset.centerLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(model.img, height: width * 0.38, width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
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
                      Text(model.name, style: primaryTextStyle(fontFamily: fontMedium), maxLines: 2),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(model.info, style: primaryTextStyle(color: Colors.black)),
                          Text(model.duration, style: primaryTextStyle(color: Colors.black)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}