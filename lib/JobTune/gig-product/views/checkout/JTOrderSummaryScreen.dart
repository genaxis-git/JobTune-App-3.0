import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAddressScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../main.dart';
import 'CartListView.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart' as server;

import '../payment/payment_webview.dart';
// import '../JTDrawerWidget.dart';

// ignore: must_be_immutable
class DTOrderSummaryScreen extends StatefulWidget {
  static String tag = '/DTOrderSummaryScreen';
  // List<DTProductModel> data;

  // DTOrderSummaryScreen(this.data);

  final String productid;
  final String providerid;
  final String name;
  final String category;
  final String price;
  final String additionalfee;
  final String totalprice;
  final String description;
  final String expected;
  final String availableday;
  final String location;
  final String productphoto;
  final String postdate;

  const DTOrderSummaryScreen({
    Key? key,
    required this.productid,
    required this.providerid,
    required this.name,
    required this.category,
    required this.price,
    required this.additionalfee,
    required this.totalprice,
    required this.description,
    required this.expected,
    required this.availableday,
    required this.location,
    required this.productphoto,
    required this.postdate,
  });

  @override
  DTOrderSummaryScreenState createState() => DTOrderSummaryScreenState();
}

class DTOrderSummaryScreenState extends State<DTOrderSummaryScreen> {
  var expectedDelivery = '';

  //List<DTProductModel> data = getCartProducts();

  int subTotal = 0;
  int totalAmount = 0;
  int shippingCharges = 0;
  int mainCount = 0;

  // int totalHarga = widget.price.toInt() + widget.additionalfee.toInt();

  String? name;
  String? address;
  String? address2;

  List userlist = [];

  Future<void> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(server.server +
            "jtnew_user_selectprofile&lgid=" +
            jobtuneUser.toString()),
        headers: {"Accept": "application/json"});

    this.setState(() {
      userlist = json.decode(response.body);
    });
  }

  Future<void> insertBooking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email');
    // final jobtuneUser = "hafeezhanapiah@gmail.com";
    final nameUser = userlist[0]["first_name"] + " " + userlist[0]["last_name"];
    final addressUser = userlist[0]["address"];
    final phoneUser = userlist[0]["phone_no"];
    final expectedDeliveryUser = expectedDelivery;
    final posttotalamount = widget.price.toInt() + widget.additionalfee.toInt();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => WebviewPayment(
            productid: widget.productid,
            providerid: widget.providerid.toString(),
            clientid: jobtuneUser.toString(),
            clientlocation: addressUser.toString(),
            expecteddelivery: expectedDelivery.toString(),
            clientname: nameUser.toString(),
            clientphone: phoneUser.toString(),
            totalamount: posttotalamount.toString(),
            productname: widget.name.toString())));

    // print(widget.productid);
    // print(widget.providerid);
    // print(jobtuneUser);
    // print(addressUser);
    // print(expectedDelivery);
    // print(nameUser);
    // print(phoneUser);
    // print(posttotalamount.toString());
    // print(widget.name);

    // http.get(
    //     Uri.parse(server.server +
    //         "jtnew_product_insertbooking&j_productid=" +
    //         widget.productid +
    //         "&j_providerid=" +
    //         widget.providerid +
    //         "&j_userid=" +
    //         jobtuneUser.toString() +
    //         "&j_location=" +
    //         addressUser +
    //         "&j_expecteddelivery=" +
    //         expectedDeliveryUser),
    //     headers: {"Accept": "application/json"});

    // toast("Purchased successfully");
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    DateTime dateTime = DateTime.now();
    DateTime expectedTime =
        dateTime.add(Duration(days: widget.expected.toInt()));

    expectedDelivery =
        '${expectedTime.day} ${getMonth(expectedTime.month)} ${expectedTime.year}';

    getUser();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget addressView() {
      return Container(
          padding: EdgeInsets.all(8),
          decoration: boxDecorationRoundedWithShadow(8,
              backgroundColor: appStore.appBarColor!),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              itemCount: userlist == null ? 0 : userlist.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                                userlist[index]["first_name"] +
                                    " " +
                                    userlist[index]["last_name"],
                                style: boldTextStyle(size: 18)),
                            10.width,
                            Container(
                              child: Text('Home', style: secondaryTextStyle()),
                              padding: EdgeInsets.only(left: 8, right: 8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ],
                        ),
                        // Icon(Icons.phone, color: appColorPrimary).onTap(() {
                        //   launch('tel:+913972847376');
                        // }),
                      ],
                    ),
                    Text(userlist[index]["address"], style: primaryTextStyle()),
                    // Text(
                    //     userlist[index]["postcode"] +
                    //         " " +
                    //         userlist[index]["city"] +
                    //         ", " +
                    //         userlist[index]["state"],
                    //     style: primaryTextStyle()),
                    6.height,
                    // Text('Change', style: secondaryTextStyle()).onTap(() async {
                    //   // DTAddressListModel? data =
                    //   //     await DTAddressScreen().launch(context);

                    //   // if (data != null) {
                    //   //   name = data.name;
                    //   //   address = data.addressLine1;
                    //   //   address2 = data.addressLine2;

                    //   //   setState(() {});
                    //   // }
                    // }),
                  ],
                );
              }));
    }

    Widget itemTitle() {
      return Row(
        children: [
          Divider().expand(),
          10.width,
          Text('Item', style: boldTextStyle(), maxLines: 1).center(),
          10.width,
          Divider().expand(),
        ],
      );
    }

    Widget itemView() {
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
                server.productImage + widget.productphoto,
                fit: BoxFit.fitHeight,
                height: 180,
                width: context.width(),
              ),
            ),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.name,
                    style: primaryTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                4.height,
                Row(
                  children: [
                    priceWidget(widget.price.toInt()),
                    // 8.width,
                    // priceWidget(widget.price.toInt(), applyStrike: true),
                  ],
                ),
                8.height,
              ],
            ).expand(),
          ],
        ),
      );
    }

    Widget deliveryDateAndPayBtn() {
      return Column(
        children: [
          Row(
            children: [
              Icon(Feather.truck, size: 26, color: appColorPrimary),
              10.width,
              Text('Expected Delivery - $expectedDelivery',
                      style: boldTextStyle(), maxLines: 1)
                  .expand(),
            ],
          ),
          20.height,
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: boxDecorationRoundedWithShadow(8,
                backgroundColor: appColorPrimary),
            child: Text('Continue to Pay', style: boldTextStyle(color: white)),
          ).onTap(() {
            insertBooking();
          }),
        ],
      ).paddingAll(8);
    }

    Widget mobileWidget() {
      return SingleChildScrollView(
        physics: ScrollPhysics(),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addressView(),
                20.height,
                itemTitle(),
                8.height,
              ],
            ).paddingAll(8),
            itemView(),
            20.height,
            totalAmountWidget(
                widget.price.toInt(),
                widget.additionalfee.toInt(),
                widget.price.toInt() + widget.additionalfee.toInt()),
            Divider(height: 20),
            deliveryDateAndPayBtn(),
          ],
        ),
      );
    }

    Widget webWidget() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  16.height,
                  addressView(),
                  16.height,
                  itemTitle(),
                  16.height,
                  CartListView(mIsEditable: false, isOrderSummary: true),
                ],
              ),
            ),
          ).expand(flex: 60),
          VerticalDivider(width: 0),
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                20.height,
                totalAmountWidget(widget.price.toInt(),
                    widget.additionalfee.toInt(), widget.totalprice.toInt()),
                Divider(height: 20),
                deliveryDateAndPayBtn(),
              ],
            ),
          ).expand(flex: 40),
        ],
      );
    }

    return Scaffold(
      appBar: appBar(context, 'Order Summary'),
      // drawer: JTDrawerWidget(),
      body: ContainerX(
        mobile: mobileWidget(),
        web: webWidget(),
      ),
    );
  }
}
