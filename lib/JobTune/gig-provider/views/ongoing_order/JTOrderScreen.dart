import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:prokit_flutter/JobTune/constructor/server.dart' as server;

import 'CartListView.dart';
import 'JTAddCoDe.dart';
import 'JTUpdateOrder.dart';
// import 'DTDrawerWidget.dart';
// import 'DTOrderSummaryScreen.dart';

import '../../../../main.dart';

class DTCartScreen extends StatefulWidget {
  static String tag = '/DTCartScreen';

  @override
  DTCartScreenState createState() => DTCartScreenState();
}

class DTCartScreenState extends State<DTCartScreen> {
  List orderlist = [];
  List codelist = [];

  Future<void> getCoDeData(productbookingid) async {
    http.Response response = await http.get(
        Uri.parse(server.server +
            "jtnew_product_selectcode&j_productbookingid=" +
            productbookingid),
        headers: {"Accept": "application/json"});

    this.setState(() {
      codelist = json.decode(response.body);
    });
  }

  Future<void> getOngoingOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(server.server +
            "jtnew_product_selectbookingprovider&j_providerid=" +
            jobtuneUser),
        headers: {"Accept": "application/json"});

    this.setState(() {
      orderlist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    initOngoingOrder();
  }

  initOngoingOrder() async {
    getOngoingOrder();
    // getCoDeData();
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
          physics: ScrollPhysics(),
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
                            // 8.width,
                            // priceWidget(data.price, applyStrike: true),
                          ],
                        ),
                        8.height,
                        Text('Order date : ' + orderlist[index]["booking_date"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,
                        Text(
                            'Location : ' +
                                orderlist[index]["delivery_location"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,
                        Text('Status : ' + orderlist[index]["booking_status"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,

                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: codelist == null ? 0 : codelist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(
                                  'Co-De : ' +
                                      codelist[index]["code_count"] +
                                      " " +
                                      codelist[index]["role"],
                                  style: primaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis);
                            }),

                        // Text('Co-De : None',
                        //     style: primaryTextStyle(),
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis),
                        8.height,
                        Row(
                          children: [
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: BorderRadius.circular(4),
                                backgroundColor: (orderlist[index]
                                            ["booking_status"] ==
                                        "Pending")
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
                                  Text('Co-De',
                                      style: boldTextStyle(color: whiteColor)),
                                  6.width,
                                  Icon(Icons.add, color: whiteColor).onTap(() {
                                    // mainCount = data.qty! + 1;
                                    // data.qty = mainCount;

                                    // calculate();
                                  }),
                                ],
                              ),
                            ).onTap((orderlist[index]["booking_status"] ==
                                    "Pending")
                                ? () async {
                                    var bookingid =
                                        orderlist[index]["booking_id"];
                                    var productid =
                                        orderlist[index]["product_id"];
                                    // Navigator.pushNamed(context, '/page2')
                                    //     .then((_) => setState(() {}));
                                    showInDialog(context,
                                        child: AddCoDeDialog(
                                            productbookingid: bookingid,
                                            productid: productid),
                                        backgroundColor: Colors.transparent,
                                        contentPadding: EdgeInsets.all(0));

                                    // if (model != null) {
                                    //   list.add(model);

                                    //   setState(() {});
                                    // }
                                  }
                                : () async {}),
                            8.width,
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: BorderRadius.circular(4),
                                backgroundColor: (orderlist[index]
                                            ["booking_status"] ==
                                        "Received")
                                    ? Colors.lightGreen
                                    : (orderlist[index]["booking_status"] ==
                                            "Shipped")
                                        ? Colors.grey
                                        : appColorPrimaryDark,
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
                                  Text('Status',
                                      style: boldTextStyle(color: whiteColor)),
                                  6.width,
                                  (orderlist[index]["booking_status"] ==
                                          "Received")
                                      ? Icon(Icons.check_rounded,
                                          color: whiteColor)
                                      : Icon(Icons.edit_outlined,
                                          color: whiteColor),
                                ],
                              ),
                            ).onTap((orderlist[index]["booking_status"] ==
                                    "Pending")
                                ? () async {
                                    var bookingid =
                                        orderlist[index]["booking_id"];
                                    showInDialog(context,
                                        child: UpdateOrderDialog(
                                            bookingid: bookingid),
                                        backgroundColor: Colors.transparent,
                                        contentPadding: EdgeInsets.all(0));

                                    // if (model != null) {
                                    //   list.add(model);

                                    //   setState(() {});
                                    // }
                                  }
                                : () async {}),
                          ],
                        ),
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
        title: appBarTitleWidget(context, 'Ongoing Order'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(
                context,
                // MaterialPageRoute(
                //     builder: (context) => ),
              );
            }),
      ),
      body: ContainerX(
        mobile: mobileWidget(),
        web: webWidget(),
      ),
    );
  }
}
