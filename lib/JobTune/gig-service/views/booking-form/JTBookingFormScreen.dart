import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/booking-form/webview_payment.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import '../../../../main.dart';
import '../../../JTDrawerWidget.dart';


class JTBookingFormScreen extends StatefulWidget {
  const JTBookingFormScreen({
    Key? key,
    required this.id,
    required this.proid,
    required this.img,
    required this.min,
    required this.max,
  }) : super(key: key);
  final String id;
  final String proid;
  final String img;
  final String min;
  final String max;
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
  double platformfee = 0.00;
  double total = 0.00;
  var detail = TextEditingController();
  var pickinghour = TextEditingController();
  int subTotal = 0;
  int totalAmount = 0;
  int shippingCharges = 0;
  int mainCount = 0;


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
            server + "jtnew_user_selectprofile&lgid=" + lgid),
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
            server + "jtnew_provider_selectservice&id=" + widget.id),
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

  List provider = [];
  String proname = "";
  String proemail = "";
  String protel = "";
  Future<void> readProvider() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectprofile&lgid=" + widget.proid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      provider = json.decode(response.body);
    });

    setState(() {
      proname = provider[0]["name"];
      proemail = provider[0]["email"];
      protel = provider[0]["phone_no"];
    });
  }

  List packs = [];
  List<String> listOfPackage = ['Choose package..'];
  String? selectedIndexPackage = 'Choose package..';
  Future<void> readPackage() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectpackage&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      packs = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      listOfPackage.add(packs[m]["package_name"] + " | RM " + packs[m]["package_rate"] + " | est: " + packs[m]["package_time"] + " Hr");
    }
  }

  String book = "";
  Future<void> sendBooking(starts,ends,quantity,desc,names,total) async {
    http.get(
        Uri.parse(
            server + "jtnew_user_insertbooking&serviceid=" + widget.id
                + "&client=" + email
                + "&starts=" + starts
                + "&ends=" + ends.toString()
                + "&quantity=" + quantity
                + "&address=" + userloc
                + "&desc=" + desc
                + "names=" + names
        ),
        headers: {"Accept": "application/json"}
    );

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectmaxbooking&lgid=" + email),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      book = response.body;
    });

    http.get(
        Uri.parse(
            server + "jtnew_user_insertpayment&id=" + book
                + "&total=" + total
                + "&type=gig-service"
        ),
        headers: {"Accept": "application/json"}
    );

    toast("Booking Success!");
  }

  @override
  void initState() {
    super.initState();
    this.readProfile();
    this.readProvider();
    this.readService();
  }

  // functions ends //

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
        print(selectedTimeIN);
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
                    child: Image.network(
                      "https://jobtune.ai/gig/JobTune/assets/img/" + widget.img,
                      fit: BoxFit.fitHeight,
                      height: 180,
                      width: context.width(),
                    )
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
                      (by == "Hour")
                      ? Row(
                        children: [
                          JTpriceWidget(double.parse(rate)),
                        ],
                      )
                      : (selectedIndexPackage == "Choose package..")
                        ? (min != max)
                          ? Row(
                            children: [
                              JTpriceWidget(double.parse(widget.min)),
                              Text(
                                " - ",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              JTpriceWidget(double.parse(widget.max)),
                            ],
                          )
                          : JTpriceWidget(double.parse(widget.min))
                        : JTpriceWidget(double.parse(selectedIndexPackage.toString().split("|")[1].split(" ")[2])),
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
                      child: Card(
                          elevation: 4,
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
                10.height,
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("  Pick hour:-"),
                      7.height,
                      TextFormField(
                        controller: pickinghour,
                        onChanged: (text) {
                          toast(pickinghour.text);
                          setState(() {
                            subtotal = double.parse(rate) * double.parse(pickinghour.text.toString());
                            total = subtotal + platformfee;
                          });
                        },
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Hour',
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
                      child: Card(
                          elevation: 4,
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
              keyboardType: TextInputType.text,
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
                  if(by == "Hour " || by == "Hour") {
                    var jammula;
                    var minitmula;
                    var jamakhir;
                    var minitakhir;
                    if(selectedTimeIN.hour < 10){
                      jammula = "0" + selectedTimeIN.hour.toString();
                    }
                    else{
                      jammula = selectedTimeIN.hour.toString();
                    }
                    if(selectedTimeIN.minute < 10){
                      minitmula = "0" + selectedTimeIN.minute.toString();
                    }
                    else{
                      minitmula = selectedTimeIN.minute.toString();
                    }
                    var pickedhr = int.parse(pickinghour.text.toString());
                    var pickedtime = jammula.toString()+":"+minitmula.toString()+":00";
                    var quantity = pickinghour.text.toString();
                    var starts = selectedDate.toString().split(" ")[0] + " " + pickedtime;
                    var addinghrs = TimeOfDay.fromDateTime(DateTime.parse(starts).add(Duration(hours: pickedhr)));
                    var ends = selectedDate.toString().split(" ")[0] + " " + addinghrs.hour.toString() + ":" + addinghrs.minute.toString() + ":00";
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => WebviewPayment(
                          postid: widget.id,
                          clientid: email,
                          starts: starts.toString(),
                          ends: ends.toString(),
                          quantity: quantity.toString(),
                          address: userloc,
                          desc: detail.text,
                          type: "gig-service",
                          total: total.toString(),
                          packname: servicename,
                          username: fullname,
                          teluser: usercall,
                          proname: proname,
                          proemail: proemail,
                          protel: protel,
                          servicename: servicename,
                        )
                    ));
                  }
                  else {
                    var jammula;
                    var minitmula;
                    var jamakhir;
                    var minitakhir;
                    if(selectedTimeIN.hour < 10){
                      jammula = "0" + selectedTimeIN.hour.toString();
                    }
                    else{
                      jammula = selectedTimeIN.hour.toString();
                    }
                    if(selectedTimeIN.minute < 10){
                      minitmula = "0" + selectedTimeIN.minute.toString();
                    }
                    else{
                      minitmula = selectedTimeIN.minute.toString();
                    }
                    var pickedhr = int.parse(selectedIndexPackage.toString().split(" | ")[2].split(" ")[1]);
                    var pickedtime = jammula+":"+minitmula+":00";
                    var quantity = selectedIndexPackage.toString().split(" | ")[2].split(" ")[1];
                    var starts = selectedDate.toString().split(" ")[0] + " " + pickedtime;
                    var addinghrs = TimeOfDay.fromDateTime(DateTime.parse(starts).add(Duration(hours: pickedhr)));
                    if(addinghrs.hour < 10){
                      jamakhir = "0" + addinghrs.hour.toString();
                    }
                    else{
                      jamakhir = addinghrs.hour.toString();
                    }
                    if(addinghrs.minute < 10){
                      minitakhir = "0" + addinghrs.minute.toString();
                    }
                    else{
                      minitakhir = addinghrs.minute.toString();
                    }
                    var ends = selectedDate.toString().split(" ")[0] + " " + jamakhir + ":" + minitakhir + ":00";
                    var pickedpack = selectedIndexPackage.toString().split(" | ")[0];
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => WebviewPayment(
                          postid: widget.id,
                          clientid: email,
                          starts: starts.toString(),
                          ends: ends.toString(),
                          quantity: quantity.toString(),
                          address: userloc,
                          desc: detail.text,
                          type: "gig-service",
                          total: total.toString(),
                          packname: pickedpack.toString(),
                          username: fullname,
                          teluser: usercall,
                          proname: proname,
                          proemail: proemail,
                          protel: protel,
                          servicename: servicename,
                        )
                    ));
                  }
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
                Column(
                  children: [
                    20.height,
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12),
                      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: Color(0xFF0A79DF)),
                      child: Text('Checkout', style: boldTextStyle(color: white)),
                    ).onTap(() {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => WebviewPayment(

                          )
                      ));
                    }),
                  ],
                ).paddingAll(8),
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
