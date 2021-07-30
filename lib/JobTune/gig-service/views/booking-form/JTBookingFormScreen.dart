import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/booking-form/webview_payment.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import '../../../../main.dart';
import '../../../JTDrawerWidget.dart';


class JTBookingFormScreen extends StatefulWidget {
  const JTBookingFormScreen({
    Key? key,
    required
    this.id,
  }) : super(key: key);
  final String id;
  @override
  _JTBookingFormScreenState createState() => _JTBookingFormScreenState();
}

class _JTBookingFormScreenState extends State<JTBookingFormScreen> {
  var expectedDelivery = '';
  //List<DTProductModel> data = getCartProducts();
//  var hour = TextEditingController();
  List<String> listOfQty = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23'];
  String? selectedIndexQty = '1';
  double subtotal = 0;
  double platformfee = 1.25;
  double total = 1.25;
  var detail = TextEditingController();
  int subTotal = 0;
  int totalAmount = 0;
  int shippingCharges = 0;
  int mainCount = 0;

  String? name = 'Austin';
  String? address = '381, Shirley St. Munster, New York';
  String? address2 = 'United States - 10005';

  // function starts //
  List profile = [];
  String email = "";
  String fullname = "";
  String userloc = "";
  String usercall = "";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      fullname = profile[0]["first_name"] + " " + profile[0]["last_name"] ;
      userloc = profile[0]["address"] ;
      usercall = profile[0]["phone_no"] ;
    });
  }

  List info = [];
  String servicename = "";
  String rate = "0";
  String desc = "";
  String category = "";
  String days = "";
  String hours = "";
  String location = "";
  String by = "Package";
  Future<void> readService() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectservice&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      info = json.decode(response.body);
    });

    setState(() {
      servicename = info[0]["name"];
      rate = double.parse(info[0]["rate"]).toStringAsFixed(2);
      desc = info[0]["description"];
      category = info[0]["category"];
      days = info[0]["available_day"];
      hours = info[0]["available_start"] + " to " + info[0]["available_end"];
      location = info[0]["location"];
      by = info[0]["rate_by"];
    });

    if(info[0]["rate_by"] == "Package " || info[0]["rate_by"] == "Package") {
      print("ini package");
      readPackage();
    }
  }

  List packs = [];
  List<String> listOfPackage = ['Choose package..'];
  String? selectedIndexPackage = 'Choose package..';
  Future<void> readPackage() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectpackage&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      packs = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      listOfPackage.add(packs[m]["package_name"] + " | RM " + packs[m]["package_rate"] + " | est: " + packs[m]["package_time"] + " Hr");
    }
  }


  @override
  void initState() {
    super.initState();
    this.readProfile();
    this.readService();
  }

  TimeOfDay selectedTimeIN = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

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

  Future<Null> _selectTimeIN(BuildContext context) async {
    final TimeOfDay? pickedIN = await showTimePicker(
        context: context,
        initialTime: selectedTimeIN,
        builder: (BuildContext context, Widget? child) {
          return CustomTheme(
            child: MediaQuery(
              data:
              MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            ),
          );
        });

    if (pickedIN != null)
      setState(() {
        selectedTimeIN = pickedIN;
      });
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
        decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.appBarColor!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(fullname, style: boldTextStyle(size: 18)),
                  ],
                ),
              ],
            ),
            Text(userloc, style: primaryTextStyle()),
            Text(email, style: primaryTextStyle()),
            Text(usercall, style: primaryTextStyle()),
            6.height,
          ],
        ),
      );
    }

    Widget itemTitle() {
      return Row(
        children: [
          Divider().expand(),
          10.width,
          Text('Service Selected', style: boldTextStyle(), maxLines: 1).center(),
          10.width,
          Divider().expand(),
        ],
      );
    }

    Widget deliveryDateAndPayBtn() {
      return Column(
        children: [
          20.height,
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: boxDecorationRoundedWithShadow(8, backgroundColor: Color(0xFF0A79DF)),
            child: Text('Checkout', style: boldTextStyle(color: white)),
          ).onTap(() {
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => WebviewPayment(
////                    postid: widget.id.toString(),
////                    nilaidb: total.toString(),
////                    fullname: Uri.encodeComponent(fullname.toString()),
////                    email: email.toString(),
////                    telno: Uri.encodeComponent(telno.toString()),
////                    platformdb: platformfee.toString(),
////                    proid: email.toString(),
////                    empid: empid.toString(),
////                    emprid: emprid.toString(),
////                    timein: timein.toString(),
////                    date: date.toString(),
////                    address: address.toString(),
////                    describe: Uri.encodeComponent(describe.toString()),
////                    timeout: timeout.toString(),
////                    input: input.toString(),
////                    service: Uri.encodeComponent(service.toString()),
////                    proname: Uri.encodeComponent(proname.toString()),
////                    hr: hr.toString(),
////                    emailid: emailid.toString(),
////                    protel: Uri.encodeComponent(protel.toString()),
////                    package: Uri.encodeComponent(package.toString()),
////                    insurancedb: insurance.toString(),
////                    adminfeedb: adminfee.toString(),
//                  )
//              ));
//            }
          }),
        ],
      ).paddingAll(8);
    }

    Widget mobileWidget() {
      return SingleChildScrollView(
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
            Container(
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
                        'images/dashboard/ic_chair2.jpg',
                        fit: BoxFit.fitHeight,
                        height: 180,
                        width: context.width(),
                      )
                    // Image.network(
                    //   data.image!,
                    //   fit: BoxFit.cover,
                    //   height: 100,
                    //   width: 100,
                    // ).cornerRadiusWithClipRRect(8),
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          servicename,
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis
                      ),
                      4.height,
                      Row(
                        children: [
                          JTpriceWidget(double.parse(rate)),
                        ],
                      ),
                      8.height,
                    ],
                  ).expand(),
                ],
              ),
            ),
            10.height,
            (by == "Hour " || by == "Hour")
            ? Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Card(
                            elevation: 1,
                            child: ListTile(
                              onTap: () {
                                _selectTimeIN(context);
                              },
                              title: Text(
                                'Start Shift',
                                style: primaryTextStyle(),
                              ),
                              subtitle: Text(
                                "${selectedTimeIN.hour < 10 ? "0${selectedTimeIN.hour}" : "${selectedTimeIN.hour}"} : ${selectedTimeIN.minute < 10 ? "0${selectedTimeIN.minute}" : "${selectedTimeIN.minute}"} ${selectedTimeIN.period != DayPeriod.am ? 'PM' : 'AM'}   ",
                                style: secondaryTextStyle(),
                              ),
                            )),
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: Card(
                          elevation: 1,
                          child: ListTile(
                            onTap: () {
                              _selectDate(context);
                            },
                            title: Text(
                              'Select date',
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
                    ),
                    8.width,
                  ],
                ),
                10.height,
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("  Pick hour:-"),
                      7.height,
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // if you need this
                            side: BorderSide(
                              color: Colors.black.withOpacity(0.6),
                              width: 1,
                            ),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            dropdownColor: appStore.appBarColor,
                            value: selectedIndexQty,
                            style: boldTextStyle(),
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: appStore.iconColor,
                            ),
                            underline: 0.height,
                            onChanged: (dynamic newValue) {
                              setState(() {
                                toast(newValue);
                                selectedIndexQty = newValue;

                                setState(() {
                                  subtotal = double.parse(rate) * double.parse(selectedIndexQty.toString());
                                  total = subtotal + platformfee;
                                });
                              });
                            },
                            items: listOfQty.map((category) {
                              return DropdownMenuItem(
                                child: Text(category, style: primaryTextStyle()).paddingLeft(8),
                                value: category,
                              );
                            }).toList(),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            )
            : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Card(
                            elevation: 1,
                            child: ListTile(
                              onTap: () {
                                _selectTimeIN(context);
                              },
                              title: Text(
                                'Start Shift',
                                style: primaryTextStyle(),
                              ),
                              subtitle: Text(
                                "${selectedTimeIN.hour < 10 ? "0${selectedTimeIN.hour}" : "${selectedTimeIN.hour}"} : ${selectedTimeIN.minute < 10 ? "0${selectedTimeIN.minute}" : "${selectedTimeIN.minute}"} ${selectedTimeIN.period != DayPeriod.am ? 'PM' : 'AM'}   ",
                                style: secondaryTextStyle(),
                              ),
                            )),
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: Card(
                          elevation: 4,
                          child: ListTile(
                            onTap: () {
                              _selectDate(context);
                            },
                            title: Text(
                              'Select date',
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
                    ),
                    8.width,
                  ],
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.height,
                      Text("  Pick package:-"),
                      7.height,
                      Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // if you need this
                            side: BorderSide(
                              color: Colors.black.withOpacity(0.6),
                              width: 1,
                            ),
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            dropdownColor: appStore.appBarColor,
                            value: selectedIndexPackage,
                            style: boldTextStyle(),
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: appStore.iconColor,
                            ),
                            underline: 0.height,
                            onChanged: (dynamic newValue) {
                              setState(() {
                                toast(newValue);
                                selectedIndexPackage = newValue;
                                print(selectedIndexPackage.toString());
                                var price = selectedIndexPackage.toString().split("|")[1].split(" ")[2];
                                print(price);
                                subtotal = double.parse(price);
                                total = subtotal + platformfee;
                              });
                            },
                            items: listOfPackage.map((category) {
                              return DropdownMenuItem(
                                child: Text(category, style: primaryTextStyle()).paddingLeft(8),
                                value: category,
                              );
                            }).toList(),
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
            10.height,
            TextFormField(
              controller: detail,
              maxLines: 3,
              style: primaryTextStyle(),
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                contentPadding: EdgeInsets.all(16),
                labelStyle: secondaryTextStyle(),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF0A79DF))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        color: appStore.textSecondaryColor!)),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            30.height,
            Divider(height: 20),
            20.height,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sub Total', style: boldTextStyle(size: 18)),
                    JTpriceWidget(subtotal),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Platform fee', style: boldTextStyle(size: 18)),
                    JTpriceWidget(platformfee),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount', style: boldTextStyle(size: 18)),
                    JTpriceWidget(total),
                  ],
                ),
                20.height,
              ],
            ),
            Column(
              children: [
                20.height,
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  decoration: boxDecorationRoundedWithShadow(8, backgroundColor: Color(0xFF0A79DF)),
                  child: Text('Checkout', style: boldTextStyle(color: white)),
                ).onTap(() {

                }),
              ],
            ).paddingAll(8)
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
//                  CartListView(mIsEditable: false, isOrderSummary: true),
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Sub Total', style: boldTextStyle(size: 18)),
                        JTpriceWidget(100),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping Charges', style: boldTextStyle(size: 18)),
                        JTpriceWidget(12),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount', style: boldTextStyle(size: 18)),
                        JTpriceWidget(112),
                      ],
                    ),
                    20.height,
                  ],
                ),
                Divider(height: 20),
                deliveryDateAndPayBtn(),
              ],
            ),
          ).expand(flex: 40),
        ],
      );
    }

    return Scaffold(
      appBar: JTappBar(context, 'Order Summary'),
      drawer: DTDrawerWidget(),
      body: JTContainerX(
        mobile: mobileWidget(),
        web: webWidget(),
      ),
    );
  }
}
