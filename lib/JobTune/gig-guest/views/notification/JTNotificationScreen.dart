import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/notification/JTNotificationWidget.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:prokit_flutter/JobTune/constructor/server.dart' as server;

import '../../../../main.dart';

class JTNotificationScreen extends StatefulWidget {
  static String tag = '/DTCartScreen';

  @override
  JTNotificationScreenState createState() => JTNotificationScreenState();
}

class JTNotificationScreenState extends State<JTNotificationScreen> {
  List codebookinglist = [];

  Future<void> getProduct() async {
    http.Response response = await http.get(
        Uri.parse(server.server + "jtnew_product_selectcodebooking"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      codebookinglist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
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

    // Widget browseWidget() {
    //   return ListView.builder(
    //       itemCount: codebookinglist == null ? 0 : codebookinglist.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return Container(
    //           decoration: boxDecorationRoundedWithShadow(8,
    //               backgroundColor: appStore.appBarColor!),
    //           margin: EdgeInsets.all(8),
    //           padding: EdgeInsets.all(8),
    //           child: Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Container(
    //                 height: 100,
    //                 width: 100,
    //                 child: Image.asset(
    //                   'images/defaultTheme/walkthrough1.png',
    //                   fit: BoxFit.cover,
    //                   height: 100,
    //                   width: 100,
    //                 ).cornerRadiusWithClipRRect(8),
    //               ),
    //               12.width,
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text(codebookinglist[index]["name"],
    //                       style: primaryTextStyle(),
    //                       maxLines: 1,
    //                       overflow: TextOverflow.ellipsis),
    //                   4.height,
    //                   Row(
    //                     children: [
    //                       Text(
    //                         '\RM ' + codebookinglist[index]["payment"],
    //                         style: TextStyle(
    //                           decoration: TextDecoration.none,
    //                           color: appStore.textPrimaryColor,
    //                           fontSize: 18,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                   8.height,
    //                   Text(
    //                       'Delivery date : ' +
    //                           codebookinglist[index]["start_date"],
    //                       style: primaryTextStyle(),
    //                       maxLines: 1,
    //                       overflow: TextOverflow.ellipsis),
    //                   8.height,
    //                   Row(
    //                     children: [
    //                       Container(
    //                         decoration: boxDecorationWithRoundedCorners(
    //                           borderRadius: BorderRadius.circular(4),
    //                           backgroundColor: appColorPrimaryDark,
    //                         ),
    //                         padding: EdgeInsets.all(4),
    //                         child: Row(
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: [
    //                             Text('Accept',
    //                                 style: boldTextStyle(color: whiteColor)),
    //                             6.width,
    //                             Icon(Icons.check_rounded, color: whiteColor)
    //                                 .onTap(() {}),
    //                           ],
    //                         ),
    //                       ).onTap(() async {}),
    //                     ],
    //                   ),
    //                 ],
    //               ).expand(),
    //             ],
    //           ),
    //         );
    //       });
    // }

    Widget bookingWidget() {
      return ListView.builder(
          itemCount: codebookinglist == null ? 0 : codebookinglist.length,
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
                      'images/defaultTheme/walkthrough1.png',
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
                      Text(codebookinglist[index]["name"],
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      4.height,
                      Row(
                        children: [
                          Text(
                            '\RM ' + codebookinglist[index]["payment"],
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: appStore.textPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      8.height,
                      Text(
                          'Delivery date : ' +
                              codebookinglist[index]["start_date"],
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
                                Text('Accept',
                                    style: boldTextStyle(color: whiteColor)),
                                6.width,
                                Icon(Icons.check_rounded, color: whiteColor)
                                    .onTap(() {
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
                        ],
                      ),
                    ],
                  ).expand(),
                ],
              ),
            );
          });
    }

    return SafeArea(
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: appStore.appBarColor,
                title: appBarTitleWidget(context, 'Notifications'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                      Navigator.pop(
                        context,
                      );
                    }
                ),
              ),
              body: ContainerX(
                mobile: JTNotificationWidget(),
              ),
              // ContainerX(
              //   mobile: mobileWidget(),
              //   web: webWidget(),
              // ),
            )));
  }
}
