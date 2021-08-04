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

  Future<void> getOngoingOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email').toString();
    // final jobtuneUser = "shahirah@gmail.com";

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
    init();
  }

  init() async {
    getOngoingOrder();
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
      return Container(
        decoration: boxDecorationRoundedWithShadow(8,
            backgroundColor: appStore.appBarColor!),
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: orderlist == null ? 0 : orderlist.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
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
                      Text(orderlist[index]["name"],
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      4.height,
                      Row(
                        children: [
                          priceWidget(10),
                          // 8.width,
                          // priceWidget(data.price, applyStrike: true),
                        ],
                      ),
                      8.height,
                      Text('Delivery date : 28/7/2021',
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      4.height,
                      Text('Status : Pending',
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      4.height,
                      Text('Co-De : None',
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      8.height,
                      Row(
                        children: [
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: BorderRadius.circular(4),
                              backgroundColor: appColorPrimaryDark,
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
                          ).onTap(() async {
                            // DTAddressListModel? model = await showInDialog(context,
                            //     child: AddAddressDialog(),
                            //     backgroundColor: Colors.transparent,
                            //     contentPadding: EdgeInsets.all(0));

                            // if (model != null) {
                            //   list.add(model);

                            //   setState(() {});
                            // }
                          }),
                          8.width,
                          Container(
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: BorderRadius.circular(4),
                              backgroundColor: appColorPrimaryDark,
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
                                Icon(Icons.edit_outlined, color: whiteColor)
                                    .onTap(() {
                                  // mainCount = data.qty! + 1;
                                  // data.qty = mainCount;

                                  // calculate();
                                }),
                              ],
                            ),
                          ).onTap(() async {
                            // DTAddressListModel? model = await showInDialog(context,
                            //     child: UpdateStatusDialog(),
                            //     backgroundColor: Colors.transparent,
                            //     contentPadding: EdgeInsets.all(0));

                            // if (model != null) {
                            //   list.add(model);

                            //   setState(() {});
                            // }
                          }),
                        ],
                      ),
                    ],
                  ).expand(),
                ],
              );
            }),
      );
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
