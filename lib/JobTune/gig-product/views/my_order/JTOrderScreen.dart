import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'CartListView.dart';
import 'JTConfirmOrder.dart';
// import 'DTDrawerWidget.dart';
// import 'DTOrderSummaryScreen.dart';

import '../../../../main.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart' as server;

class DTCartScreen extends StatefulWidget {
  static String tag = '/DTCartScreen';

  @override
  DTCartScreenState createState() => DTCartScreenState();
}

class DTCartScreenState extends State<DTCartScreen> {
  List orderlist = [];

  Future<void> getOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final jobtuneUser = prefs.getString('user');
    final jobtuneUser = "hafeezhanapiah@gmail.com";

    http.Response response = await http.get(
        Uri.parse(server.server +
            "jtnew_product_selectbooking&j_userid=" +
            jobtuneUser),
        headers: {"Accept": "application/json"});

    this.setState(() {
      orderlist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getOrder();
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
          itemCount: orderlist == null ? 0 : orderlist.length,
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
                      child: Image.network(
                        server.productImage + orderlist[index]["product_photo"],
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
                        Text(orderlist[index]["name"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,
                        Row(
                          children: [
                            Text(
                              '\RM ' + orderlist[index]["price"],
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: appStore.textPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        8.height,
                        Text('Expected delivery : 28/7/2021',
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,
                        Text('Status : ' + orderlist[index]["booking_status"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        8.height,
                        Row(
                          children: [
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: BorderRadius.circular(4),
                                backgroundColor: (orderlist[index]
                                            ["booking_status"] ==
                                        "Received")
                                    ? Colors.lightGreen
                                    : (orderlist[index]["booking_status"] ==
                                            "Shipped")
                                        ? appColorPrimaryDark
                                        : Colors.grey,
                              ),
                              padding: EdgeInsets.all(4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Icon(Icons.remove, color: whiteColor).onTap(() {
                                  //   var qty = data.qty!;
                                  //   if (qty <= 1) return;
                                  //   var q = qty - 1;
                                  //   data.qty = q;

                                  //   calculate();
                                  // }),
                                  6.width,
                                  (orderlist[index]["booking_status"] ==
                                          "Received")
                                      ? Text('Order Received',
                                          style:
                                              boldTextStyle(color: whiteColor))
                                      : Text('Receive Order',
                                          style:
                                              boldTextStyle(color: whiteColor)),
                                  6.width,
                                  Icon(Icons.assignment_turned_in_outlined,
                                          color: whiteColor)
                                      .onTap(() {
                                    // mainCount = data.qty! + 1;
                                    // data.qty = mainCount;

                                    // calculate();
                                  }),
                                ],
                              ),
                            ).onTap((orderlist[index]["booking_status"] ==
                                    "Shipped")
                                ? () async {
                                    var bookingid =
                                        orderlist[index]["booking_id"];
                                    showInDialog(context,
                                        child: ConfirmOrderDialog(
                                            bookingid: bookingid),
                                        backgroundColor: Colors.transparent,
                                        contentPadding: EdgeInsets.all(0));
                                  }
                                : () async {}),
                          ],
                        ),
                      ],
                    ).expand(),
                  ],
                ));
          });
      // });
    }

    Widget webWidget() {
      return CartListView(mIsEditable: true, isOrderSummary: false);
    }

    return Scaffold(
      // appBar: appBar(context, 'Cart'),
      // drawer: DTDrawerWidget(),
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, 'My Order'),
      ),
      drawer: JTDrawerWidgetProduct(),
      body: ContainerX(
        mobile: mobileWidget(),
        web: webWidget(),
      ),
    );
  }
}
