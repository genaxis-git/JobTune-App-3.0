import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'CartListView.dart';
// import 'DTDrawerWidget.dart';
// import 'DTOrderSummaryScreen.dart';

import '../../../../main.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart' as server;

class JTMyProduct extends StatefulWidget {
  static String tag = '/DTCartScreen';

  @override
  JTMyProductState createState() => JTMyProductState();
}

class JTMyProductState extends State<JTMyProduct> {
  List productlist = [];
  bool isSwitched = false;

  Future<void> getProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email');
    // final jobtuneUser = "syeeraayeem@gmail.com";

    http.Response response = await http.get(
        Uri.parse(server.server +
            "jtnew_product_selectmyproduct&j_providerid=" +
            jobtuneUser.toString()),
        headers: {"Accept": "application/json"});

    this.setState(() {
      productlist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getProduct();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget checkOutBtn() {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        decoration:
            boxDecorationRoundedWithShadow(8, backgroundColor: appColorPrimary),
        child: Text('Checkout', style: boldTextStyle(color: white)),
      ).onTap(() {
        // DTOrderSummaryScreen(getCartProducts()).launch(context);
      });
    }

    Widget mobileWidget() {
      return ListView.builder(
          itemCount: productlist == null ? 0 : productlist.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                decoration: boxDecorationRoundedWithShadow(8,
                    backgroundColor: appStore.appBarColor!),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.asset(
                        'images/JobTune/banner/dt_advertise1.jpg',
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ).cornerRadiusWithClipRRect(8),
                    ),
                    12.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(productlist[index]["name"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,
                        Row(
                          children: [
                            Text(
                              '\RM ' + productlist[index]["price"],
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: appStore.textPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            // 8.width,
                            // priceWidget(data.price, applyStrike: true),
                          ],
                        ),
                        4.height,
                        // Text('Delivery date : 28/7/2021',
                        //     style: primaryTextStyle(),
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis),
                        // 4.height,
                        Transform.scale(
                          scale: 1.2,
                          child: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                print(isSwitched);
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ),
                        8.height,
                      ],
                    ).expand(),
                  ],
                ));
          });
    }

    Widget webWidget() {
      return CartListView(mIsEditable: true, isOrderSummary: false);
    }

    return Scaffold(
      // appBar: appBar(context, 'Cart'),
      // drawer: DTDrawerWidget(),
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, 'My Product'),
      ),
      // drawer: JTDrawerWidgetProduct(),
      body: ContainerX(
        mobile: mobileWidget(),
        web: webWidget(),
      ),
    );
  }
}
