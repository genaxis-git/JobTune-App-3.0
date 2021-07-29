import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';

import '../../../../main.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/timetable/JTScheduleScreenUser.dart';
import 'JTDrawerWidget.dart';
import 'JTAddressScreen.dart';
import 'JTProductDetailWidget.dart';
import 'JTReviewScreenUser.dart';
import 'JTReviewWidget.dart';

bool package = true;

class JTProductDetail extends StatefulWidget {
  static String tag = '/JTProductDetail';
  DTProductModel? productModel;

  JTProductDetail({this.productModel});

  @override
  _JTProductDetailState createState() => _JTProductDetailState();
}

class _JTProductDetailState extends State<JTProductDetail> {
  var discount = 0.0;

  var bookname = TextEditingController();
  var bookemail = TextEditingController();
  var bookphone = TextEditingController();
  var bookaddress = TextEditingController();
  var bookdesc = TextEditingController();

  var passFocus = FocusNode();
  DateTime selectedDate = DateTime.now();

  DTAddressListModel? mSelectedAddress;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.productModel != null) {
      if (widget.productModel!.price.validate() > widget.productModel!.discountPrice.validate()) {
        double mrp = widget.productModel!.price.validate().toDouble();
        double discountPrice = widget.productModel!.discountPrice.validate().toDouble();
        discount = (((mrp - discountPrice) / mrp) * 100);

        setState(() {});
      }
    } else {
      widget.productModel = getProducts()[2];
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        helpText: 'Select your Booking date',
        cancelText: 'Not Now',
        confirmText: "Book",
        fieldLabelText: 'Booking Date',
        fieldHintText: 'Month/Date/Year',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        context: context,
        builder: (BuildContext context, Widget? child) {
          return JTCustomTheme(
            child: child,
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        print(picked);
        selectedDate = picked;
      });
  }

  String hourcontroller = "00";
  String mincontroller = "00";
  int _hourController = 1;

  @override
  Widget build(BuildContext context) {
    Widget addToCartBtn() {
      return Container(
        height: 50,
        width: context.width() / 2,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
        child: Text('Add to Cart', style: boldTextStyle()),
      ).onTap(() {
        toast('Added to cart');
        // Do your logic
      });
    }

    Widget checkCalendar() {
      return Container(
        height: 50,
        width: context.width() / 2,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: appStore.scaffoldBackground, boxShadow: defaultBoxShadow(spreadRadius: 3.0)),
        child: Text('Check Slot', style: boldTextStyle()),
      ).onTap(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JTScheduleScreenUser()),
        );
        // Do your logic
      });
    }

    Widget buyNowBtn() {
      return Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        alignment: Alignment.center,
        width: context.width() / 2,
        decoration: BoxDecoration(color: Color(0xFF0A79DF), boxShadow: defaultBoxShadow()),
        child: Text('Book Now', style: boldTextStyle(color: white)),
      ).onTap(() {
        // Do your logic
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
          backgroundColor: appStore.scaffoldBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          builder: (builder) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking Form', style: boldTextStyle(size: 24)),
                    30.height,
                    TextFormField(
                      controller: bookname,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.name,
    //                          validator: (s) {
    //                            if (s!.trim().isEmpty) return errorThisFieldRequired;
    //                            if (!s.trim().validateEmail()) return 'Email is invalid';
    //                            return null;
    //                          },
    //                          onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
                      textInputAction: TextInputAction.next,
                    ),
                    16.height,
                    TextFormField(
                      controller: bookemail,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.name,
                      //                          validator: (s) {
                      //                            if (s!.trim().isEmpty) return errorThisFieldRequired;
                      //                            if (!s.trim().validateEmail()) return 'Email is invalid';
                      //                            return null;
                      //                          },
                      //                          onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
                      textInputAction: TextInputAction.next,
                    ),
                    16.height,
                    TextFormField(
                      controller: bookphone,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Phone No.',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.name,
                      //                          validator: (s) {
                      //                            if (s!.trim().isEmpty) return errorThisFieldRequired;
                      //                            if (!s.trim().validateEmail()) return 'Email is invalid';
                      //                            return null;
                      //                          },
                      //                          onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
                      textInputAction: TextInputAction.next,
                    ),
                    16.height,
                    TextFormField(
                      controller: bookaddress,
                      maxLines: 2,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Full Address',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.name,
                      //                          validator: (s) {
                      //                            if (s!.trim().isEmpty) return errorThisFieldRequired;
                      //                            if (!s.trim().validateEmail()) return 'Email is invalid';
                      //                            return null;
                      //                          },
                      //                          onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
                      textInputAction: TextInputAction.next,
                    ),
                    16.height,
                    TextFormField(
                      controller: bookdesc,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Description (optional)',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.name,
                      //                          validator: (s) {
                      //                            if (s!.trim().isEmpty) return errorThisFieldRequired;
                      //                            if (!s.trim().validateEmail()) return 'Email is invalid';
                      //                            return null;
                      //                          },
                      //                          onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
                      textInputAction: TextInputAction.next,
                    ),
                    16.height,
                    Card(
                        elevation: 4,
                        child: ListTile(
                          onTap: () {
                            _selectDate(context);
                          },
                          title: Text(
                            'Select your Booking date',
                            style: primaryTextStyle(),
                          ),
                          subtitle: Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                            style: secondaryTextStyle(),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.date_range,
                              color: appStore.iconColor,
                            ),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                        )),
                    16.height,
                    Text(
                      "   Select Starting time:-",
                      style: primaryTextStyle(),
                      maxLines: 2,
                    ),
                    10.height,
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Hour',
                              contentPadding: EdgeInsets.all(16),
                              labelStyle: secondaryTextStyle(),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                            ),
                            value: hourcontroller,
                            items:
                            <String>
                            ['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23']
                                .map((label) => DropdownMenuItem(
                              child: Text(label.toString()),
                              value: label,
                            ))
                                .toList(),
                            onChanged: (value) {

                            },
                          ),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Min',
                              contentPadding: EdgeInsets.all(16),
                              labelStyle: secondaryTextStyle(),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                            ),
                            value: mincontroller,
                            items:
                            <String>
                            ['00','15','30','45']
                                .map((label) => DropdownMenuItem(
                              child: Text(label.toString()),
                              value: label,
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        (package == true)
                            ? Expanded(
                                child: DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Hour',
                                    contentPadding: EdgeInsets.all(16),
                                    labelStyle: secondaryTextStyle(),
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                                  ),
                                  value: _hourController,
                                  items:
                                  [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
                                      .map((label) => DropdownMenuItem(
                                    child: Text(label.toString()),
                                    value: label,
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {

                                    });
                                  },
                                ),
                              )
                            : Container(),

//                        Expanded(
//                                child: DropdownButtonFormField<dynamic>(
//                                  isExpanded: true,
//                                  decoration: InputDecoration(
//                                    labelText: "Choose package",
//                                    labelStyle: TextStyle(fontSize: 14,color: Colors.grey.shade400),
//                                    enabledBorder: OutlineInputBorder(
//                                      borderRadius: BorderRadius.circular(20),
//                                      borderSide: BorderSide(
//                                        color: Colors.grey.shade300,
//                                      ),
//                                    ),
//                                    focusedBorder: OutlineInputBorder(
//                                        borderRadius: BorderRadius.circular(20),
//                                        borderSide: BorderSide(
//                                          color: Colors.blue,
//                                        )
//                                    ),
//                                  ),
//                                  value: packagecontroller,
//                                  items:
//                                  choices.map((label) => DropdownMenuItem(
//                                    child: Text(label.toString()),
//                                    value: label,
//                                  ))
//                                      .toList(),
//                                  onChanged: (value) {
//                                    setState(() {
//
//                                    });
//                                  },
//                                ),
//                              ),
                      ],
                    ),
                    16.height,
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                      child: Text('Pay Now', style: boldTextStyle(color: white, size: 18)),
                    ).onTap(() {
//                          DTSignUpScreen().launch(context);
                    }),
                  ]
                ),
              ),
            );
          },
        );
      });
    }

    Widget buttonWidget() {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
//          addToCartBtn(),
          checkCalendar(),
          buyNowBtn(),

        ],
      );
    }

    Widget productDetail() {
      return Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.productModel!.name!, style: boldTextStyle(size: 18)),
              10.height,
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
//                  JTpriceWidget(widget.productModel!.discountPrice, fontSize: 28, textColor: Color(0xFF0A79DF)),
                  8.width,
//                  JTpriceWidget(widget.productModel!.price, applyStrike: true, fontSize: 18),
                  16.width,
                  Text('${discount.toInt()}% off', style: boldTextStyle(color: Color(0xFF0A79DF))).visible(discount != 0.0),
                ],
              ),
              10.height,
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                    child: Row(
                      children: [
                        Icon(Icons.star_border, color: Colors.white, size: 14),
                        8.width,
                        Text(widget.productModel!.rating.toString(), style: primaryTextStyle(color: white)),
                      ],
                    ),
                  ).onTap(() {
                    JTReviewScreenUser().launch(context);
                  }),
                  8.width,
                  Text('${Random.secure().nextInt(100).toString()} ratings', style: secondaryTextStyle(size: 16)).onTap(() {
                    JTReviewScreenUser().launch(context);
                  }),
                ],
              ),
            ],
          ).paddingAll(16),
          Divider(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Please come to', style: primaryTextStyle()),
                      10.width,
                      Text(mSelectedAddress != null ? mSelectedAddress!.name.validate() : 'John Doe', style: boldTextStyle()).expand(),
                    ],
                  ).expand(),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(border: Border.all(color: Color(0xFF0A79DF)), borderRadius: BorderRadius.circular(3)),
                    child: Text('Change', style: primaryTextStyle()),
                  ).onTap(() async {
                    var res = await JTAddressScreen().launch(context);
                    if (res is DTAddressListModel) {
                      mSelectedAddress = res;

                      toast('Address Updated');
                    }

                    setState(() {});
                  }),
                ],
              ),
              4.height,
              Text(mSelectedAddress != null ? mSelectedAddress!.addressLine1.validate() : '4683 Stadium Drive, Cambridge, MA', style: secondaryTextStyle()),
              16.height,
              Divider(height: 0),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 20, 10, 30),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce vitae blandit ante. Donec aliquam aliquam nibh in tristique. Quisque molestie eget nisl et malesuada. Maecenas feugiat lectus rutrum lacus condimentum.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Tags: ",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 120,),
                        Text(
                          "Baby Sitting",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Available Day: ",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 68,),
                        Text(
                          "Monday, Tuesday, Friday",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Operating Hours: ",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 52,),
                        Text(
                          "09:30:00 to 15:00:00",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
              Divider(height: 0),
            ],
          ).paddingAll(16),
          JTsettingItem(context, 'Location Available', leading: Icon(MaterialCommunityIcons.map_marker, color: Color(0xFF0A79DF)), textSize: 15, padding: 0.0, onTap: () {
            locationAvailable(context);
          }),
          JTsettingItem(context, 'Packages', leading: Icon(FontAwesome.list, color: Color(0xFF0A79DF), size: 18), textSize: 15, padding: 0.0, onTap: () {
            packagesAvailable(context);
          }),
        ],
      );
    }

    Widget mobileWidget() {
      return Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: context.height() * 0.45,
                  child: Image.asset(
                    widget.productModel!.image!,
                    width: context.width(),
                    height: context.height() * 0.45,
                    fit: BoxFit.cover,
                  ),
                ),
                10.height,
                productDetail(),
              ],
            ),
          ),
          Positioned(bottom: 0, child: buttonWidget()),
        ],
      );
    }

    Widget webWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    16.height,
                    Container(
                      height: context.height() * 0.45,
                      margin: EdgeInsets.all(8),
                      child: Image.network(
                        widget.productModel!.image!,
                        width: context.width(),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    20.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        addToCartBtn().expand(flex: 20),
                        buyNowBtn().expand(flex: 20),
                      ],
                    ),
                  ],
                ),
              ).expand(flex: 40),
              VerticalDivider(width: 0),
              Container(
                decoration: JTboxDecoration(bgColor: appStore.scaffoldBackground),
                child: SingleChildScrollView(
                  child: productDetail(),
                ),
              ).expand(flex: 60),
            ],
          ),
          16.height,
          widget.productModel != null ? Text('${widget.productModel!.name.validate()} Reviews', style: boldTextStyle()).paddingAll(16) : SizedBox(),
          JTReviewWidget(list: getReviewList()),
        ],
      );
    }

    return Scaffold(
      appBar: JTappBar(context, 'Detail'),
      drawer: JTDrawerWidgetUser(),
      body: JTContainerX(
        mobile: mobileWidget(),
        web: SingleChildScrollView(child: webWidget()),
        useFullWidth: true,
      ),
    );
  }
}

void locationAvailable(BuildContext aContext) {
  showModalBottomSheet(
    context: aContext,
    backgroundColor: appStore.scaffoldBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (builder) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Johor Bahru",
                        style: boldTextStyle(size: 15),
                        maxLines: 2,
                      ),
                      4.height,
                    ],
                  ).expand()
                ],
              ),
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Taman Baru Uda",
                        style: boldTextStyle(size: 15),
                        maxLines: 2,
                      ),
                      4.height,
                    ],
                  ).expand()
                ],
              ),
              16.height,
            ],
          ),
        ),
      );
    },
  );
}

void packagesAvailable(BuildContext aContext) {
  showModalBottomSheet(
    context: aContext,
    backgroundColor: appStore.scaffoldBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (builder) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jamuan Hari Jadi (100 pax) RM 500",
                        style: boldTextStyle(size: 15),
                        maxLines: 2,
                      ),
                      4.height,
                    ],
                  ).expand()
                ],
              ),
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jamuan Akikah (100 pax) RM 600",
                        style: boldTextStyle(size: 15),
                        maxLines: 2,
                      ),
                      4.height,
                    ],
                  ).expand()
                ],
              ),
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jamuan Doa Selamat (100 pax) RM 300",
                        style: boldTextStyle(size: 15),
                        maxLines: 2,
                      ),
                      4.height,
                    ],
                  ).expand()
                ],
              ),
              16.height,
            ],
          ),
        ),
      );
    },
  );
}

void mMoreOfferBottomSheet(BuildContext aContext) {
  showModalBottomSheet(
    context: aContext,
    backgroundColor: appStore.scaffoldBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (builder) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialCommunityIcons.truck_delivery, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("\$10 Delivery in 2 days, Monday", style: boldTextStyle()),
                      4.height,
                      Text(
                        "lorem meh",
                        style: secondaryTextStyle(size: 14),
                        maxLines: 2,
                      ),
                    ],
                  ).expand()
                ],
              ),
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(FontAwesome.exchange, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("7 Days return policy", style: boldTextStyle()),
                      4.height,
                      Text(
                        "lorem meh",
                        style: secondaryTextStyle(size: 14),
                        maxLines: 2,
                      ),
                    ],
                  ).expand()
                ],
              ),
              16.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(MaterialIcons.attach_money, color: Color(0xFF0A79DF)),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Cash on Delivery", style: boldTextStyle()),
                      4.height,
                      Text(
                        "lorem meh",
                        style: secondaryTextStyle(size: 14),
                        maxLines: 2,
                      ),
                    ],
                  ).expand()
                ],
              ),
              16.height,
            ],
          ),
        ),
      );
    },
  );
}

