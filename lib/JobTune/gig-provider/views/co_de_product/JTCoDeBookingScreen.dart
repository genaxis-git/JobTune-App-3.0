import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:prokit_flutter/JobTune/constructor/server.dart' as server;

// import 'CartListView.dart';
// import 'JTAddCoDe.dart';
// import 'DTDrawerWidget.dart';
import 'JTCoDeVerify.dart';

import '../../../../main.dart';

class JTCoDeProduct extends StatefulWidget {
  static String tag = '/DTCartScreen';

  @override
  JTCoDeProductState createState() => JTCoDeProductState();
}

class JTCoDeProductState extends State<JTCoDeProduct> {
  List codelist = [];

  Future<void> getOngoingOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(server.server +
            "jtnew_product_selectcodeassignment&j_providerid=" +
            jobtuneUser),
        headers: {"Accept": "application/json"});

    this.setState(() {
      codelist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // getCoDeData();
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
      return ListView.builder(
          itemCount: codelist == null ? 0 : codelist.length,
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
                      height: 80,
                      width: 80,
                      // child: Image.asset(
                      //   'images/JobTune/banner/dt_advertise1.jpg',
                      //   fit: BoxFit.cover,
                      //   height: 100,
                      //   width: 100,
                      // ).cornerRadiusWithClipRRect(8),
                      // margin: EdgeInsets.symmetric(horizontal: 16.0),
                      // alignment: FractionalOffset.center,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            server.image + codelist[index]["profile_pic"]),
                        // radius: 35,
                      ),
                    ),
                    12.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(codelist[index]["name"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,
                        Row(
                          children: [
                            Text(
                              '\RM ' + codelist[index]["payment"],
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
                        Text('Product : ' + codelist[index]["ProductName"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,
                        Text('Date : ' + codelist[index]["start_date"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,
                        Text('Status : ' + codelist[index]["status"],
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        4.height,

                        // Text('Co-De : ',
                        //     style: primaryTextStyle(),
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis),

                        // Text('Co-De : None',
                        //     style: primaryTextStyle(),
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis),
                        8.height,
                        Row(
                          children: [
                            // Container(
                            //   decoration: boxDecorationWithRoundedCorners(
                            //     borderRadius: BorderRadius.circular(4),
                            //     backgroundColor: appColorPrimaryDark,
                            //   ),
                            //   padding: EdgeInsets.all(4),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       // Icon(Icons.remove, color: whiteColor).onTap(() {
                            //       //   var qty = data.qty!;
                            //       //   if (qty <= 1) return;
                            //       //   var q = qty - 1;
                            //       //   data.qty = q;

                            //       //   calculate();
                            //       // }),
                            //       6.width,
                            //       Text('Co-De',
                            //           style: boldTextStyle(color: whiteColor)),
                            //       6.width,
                            //       Icon(Icons.add, color: whiteColor).onTap(() {
                            //         // mainCount = data.qty! + 1;
                            //         // data.qty = mainCount;

                            //         // calculate();
                            //       }),
                            //     ],
                            //   ),
                            // ).onTap(() async {
                            //   // var bookingid = orderlist[index]["booking_id"];
                            //   // showInDialog(context,
                            //   //     child: AddCoDeDialog(
                            //   //       productbookingid: bookingid,
                            //   //     ),
                            //   //     backgroundColor: Colors.transparent,
                            //   //     contentPadding: EdgeInsets.all(0));

                            //   // if (model != null) {
                            //   //   list.add(model);

                            //   //   setState(() {});
                            //   // }
                            // }),
                            // 8.width,
                            Container(
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: BorderRadius.circular(4),
                                backgroundColor: (codelist[index]["status"] ==
                                        "verified")
                                    ? Colors.lightGreen
                                    : (codelist[index]["status"] == "completed")
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
                                  (codelist[index]["status"] == "verified")
                                      ? Text('Verified',
                                          style:
                                              boldTextStyle(color: whiteColor))
                                      : (codelist[index]["status"] ==
                                              "Completed")
                                          ? Text('Verify',
                                              style: boldTextStyle(
                                                  color: whiteColor))
                                          : Text('Pending',
                                              style: boldTextStyle(
                                                  color: whiteColor)),
                                  6.width,
                                  (codelist[index]["status"] == "verified")
                                      ? Icon(Icons.check_rounded,
                                              color: whiteColor)
                                          .onTap(() {})
                                      : Icon(Icons.edit_outlined,
                                              color: whiteColor)
                                          .onTap(() {}),
                                ],
                              ),
                            ).onTap((codelist[index]["status"] == "verified")
                                ? () async {}
                                : (codelist[index]["status"] == "completed")
                                    ? () async {
                                        var bookingid =
                                            codelist[index]["co_de_booking_id"];
                                        showInDialog(context,
                                            child: JTCoDeVerify(
                                              codebookingid: bookingid,
                                            ),
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
    }

    // Widget webWidget() {
    //   return CartListView(mIsEditable: true, isOrderSummary: false);
    // }

    return Scaffold(
      // appBar: appBar(context, 'Cart'),
      // drawer: DTDrawerWidget(),
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, 'Co-Dependent'),
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
        // web: webWidget(),
      ),
    );
  }
}
