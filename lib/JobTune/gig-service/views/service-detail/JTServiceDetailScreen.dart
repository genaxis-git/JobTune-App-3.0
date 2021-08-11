import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/booking-form/JTBookingFormScreen.dart';
import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';

import '../../../../main.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/timetable/JTScheduleScreenUser.dart';
import '../index/JTDrawerWidget.dart';
import '../index/JTAddressScreen.dart';
import '../index/JTProductDetailWidget.dart';
import '../index/JTReviewScreenUser.dart';
import '../index/JTReviewWidget.dart';

bool package = true;

class JTServiceDetailScreen extends StatefulWidget {
  static String tag = '/JTServiceDetailScreen';

  const JTServiceDetailScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _JTServiceDetailScreenState createState() => _JTServiceDetailScreenState();
}

class _JTServiceDetailScreenState extends State<JTServiceDetailScreen> {
  var discount = 0.0;

  var bookname = TextEditingController();
  var bookemail = TextEditingController();
  var bookphone = TextEditingController();
  var bookaddress = TextEditingController();
  var bookdesc = TextEditingController();

  var passFocus = FocusNode();
  DateTime selectedDate = DateTime.now();

  DTAddressListModel? mSelectedAddress;

  // functions starts //

  List profile = [];
  String email = "";
  String fullname = "";
  String address = "";
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
      address = profile[0]["address"] ;
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
  String proid = "";
  String by = "Package";
  String id = "";
  Future<void> readService() async {
    print("http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectservice&id=" + widget.id);
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
      proid = info[0]["provider_id"];
      id = info[0]["service_id"];
      rate = double.parse(info[0]["rate"]).toStringAsFixed(2);
      desc = info[0]["description"];
      category = info[0]["category"];
      days = info[0]["available_day"];
      hours = info[0]["available_start"] + " to " + info[0]["available_end"];
      location = info[0]["location"];
      by = info[0]["rate_by"];
    });

    var res = info[0]["location"].split(",");
    for(var m = 0; m<res.length; m++) {
      _locatioanavailable(res[m]);
    }

    readProvider(info[0]["provider_id"],info[0]["service_id"]);
  }

  String img = "no profile.png";
  List provider = [];
  Future<void> readProvider(a,b) async {
    print("http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectprofile&lgid=" + a);
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectprofile&lgid=" + a),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      provider = json.decode(response.body);
    });

    setState(() {
      if(provider[0]["profile_pic"] != "") {
        img = provider[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
    });

    readPackage(b);
  }

  List servicelist = [];
  List numbers = [];
  String packagelist = "";
  double max = 0;
  double min = 0;
  Future<void> readPackage(b) async {
    print("http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectpackage&id=" + b);
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectpackage&id=" + b),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    min = double.parse(servicelist[0]["package_rate"]);
    for(var m=0;m<servicelist.length;m++) {
      packagelist = servicelist[m]["package_name"] + " (RM " + servicelist[m]["package_rate"] + ") est: " + servicelist[m]["package_time"] + " Hrs.";
      _packagename(packagelist);
      if(double.parse(servicelist[m]["package_rate"])>max){
        max = double.parse(servicelist[m]["package_rate"]);
      }
      if(double.parse(servicelist[m]["package_rate"])<min){
        min = double.parse(servicelist[m]["package_rate"]);
      }
    }

    setState(() {
      print("result:" + min.toString()+" "+max.toString());
      min = min;
      max = max;
    });
  }

  String averagerate = "0.0";
  Future<void> readAverage() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectaveragerating&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      averagerate = response.body;
    });
  }

  String totalrating = "0";
  List ratinglist = [];
  Future<void> readTotal() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selecttotalrate&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      ratinglist = json.decode(response.body);
    });

    setState(() {
      totalrating = ratinglist.length.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    this.readService();
    this.readProfile();
    this.readAverage();
    this.readTotal();
  }

  // function ends //

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
  int _count = 0;
  List<Widget> _children = [];
  List<Widget> _package = [];
  List<Widget> _location = [];

  void _add(a) {
    _children =
    List.from(_children)
      ..add(Column(
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
                    a,
                    style: boldTextStyle(size: 15),
                    maxLines: 2,
                  ),
                  4.height,
                ],
              ).expand()
            ],
          ),
        ],
      )
      );
    setState(() => ++_count);
  }

  void _packagename(a){
    _package =
    List.from(_package)
      ..add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
            10.width,
            Text(
              a,
              style: boldTextStyle(size: 15),
              maxLines: 2,
            ),
            25.height,
          ],
        ),
      );
  }

  void _locatioanavailable(a){
    _location =
    List.from(_location)
      ..add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
            10.width,
            Text(
              a,
              style: boldTextStyle(size: 15),
              maxLines: 2,
            ),
            25.height,
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JTBookingFormScreen(
                id: widget.id,
                proid: proid,
              ),
        ));
//        showModalBottomSheet(
//          context: context,
//          isScrollControlled: true,
//          backgroundColor: appStore.scaffoldBackground,
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//          ),
//          builder: (builder) {
//            return SingleChildScrollView(
//              padding: EdgeInsets.all(16),
//              child: Container(
//                child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Text('Booking Form', style: boldTextStyle(size: 24)),
//                      30.height,
//                      TextFormField(
//                        controller: bookname,
//                        style: primaryTextStyle(),
//                        decoration: InputDecoration(
//                          labelText: 'Full Name',
//                          contentPadding: EdgeInsets.all(16),
//                          labelStyle: secondaryTextStyle(),
//                          border: OutlineInputBorder(),
//                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
//                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
//                        ),
//                        keyboardType: TextInputType.name,
//                        textInputAction: TextInputAction.next,
//                      ),
//                      16.height,
//                      TextFormField(
//                        controller: bookemail,
//                        style: primaryTextStyle(),
//                        decoration: InputDecoration(
//                          labelText: 'Email',
//                          contentPadding: EdgeInsets.all(16),
//                          labelStyle: secondaryTextStyle(),
//                          border: OutlineInputBorder(),
//                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
//                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
//                        ),
//                        keyboardType: TextInputType.name,
//                        textInputAction: TextInputAction.next,
//                      ),
//                      16.height,
//                      TextFormField(
//                        controller: bookphone,
//                        style: primaryTextStyle(),
//                        decoration: InputDecoration(
//                          labelText: 'Phone No.',
//                          contentPadding: EdgeInsets.all(16),
//                          labelStyle: secondaryTextStyle(),
//                          border: OutlineInputBorder(),
//                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
//                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
//                        ),
//                        keyboardType: TextInputType.name,
//                        textInputAction: TextInputAction.next,
//                      ),
//                      16.height,
//                      TextFormField(
//                        controller: bookaddress,
//                        maxLines: 2,
//                        style: primaryTextStyle(),
//                        decoration: InputDecoration(
//                          labelText: 'Full Address',
//                          contentPadding: EdgeInsets.all(16),
//                          labelStyle: secondaryTextStyle(),
//                          border: OutlineInputBorder(),
//                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
//                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
//                        ),
//                        keyboardType: TextInputType.name,
//                        textInputAction: TextInputAction.next,
//                      ),
//                      16.height,
//                      TextFormField(
//                        controller: bookdesc,
//                        style: primaryTextStyle(),
//                        decoration: InputDecoration(
//                          labelText: 'Description (optional)',
//                          contentPadding: EdgeInsets.all(16),
//                          labelStyle: secondaryTextStyle(),
//                          border: OutlineInputBorder(),
//                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
//                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
//                        ),
//                        keyboardType: TextInputType.name,
//                        //                          validator: (s) {
//                        //                            if (s!.trim().isEmpty) return errorThisFieldRequired;
//                        //                            if (!s.trim().validateEmail()) return 'Email is invalid';
//                        //                            return null;
//                        //                          },
//                        //                          onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
//                        textInputAction: TextInputAction.next,
//                      ),
//                      16.height,
//                      Card(
//                          elevation: 4,
//                          child: ListTile(
//                            onTap: () {
//                              _selectDate(context);
//                            },
//                            title: Text(
//                              'Select your Booking date',
//                              style: primaryTextStyle(),
//                            ),
//                            subtitle: Text(
//                              "${selectedDate.toLocal()}".split(' ')[0],
//                              style: secondaryTextStyle(),
//                            ),
//                            trailing: IconButton(
//                              icon: Icon(
//                                Icons.date_range,
//                                color: appStore.iconColor,
//                              ),
//                              onPressed: () {
//                                _selectDate(context);
//                              },
//                            ),
//                          )),
//                      16.height,
//                      Text(
//                        "   Select Starting time:-",
//                        style: primaryTextStyle(),
//                        maxLines: 2,
//                      ),
//                      10.height,
//                      Row(
//                        children: <Widget>[
//                          Expanded(
//                            child: DropdownButtonFormField<String>(
//                              decoration: InputDecoration(
//                                labelText: 'Hour',
//                                contentPadding: EdgeInsets.all(16),
//                                labelStyle: secondaryTextStyle(),
//                                border: OutlineInputBorder(),
//                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
//                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
//                              ),
//                              value: hourcontroller,
//                              items:
//                              <String>
//                              ['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23']
//                                  .map((label) => DropdownMenuItem(
//                                child: Text(label.toString()),
//                                value: label,
//                              ))
//                                  .toList(),
//                              onChanged: (value) {
//
//                              },
//                            ),
//                          ),
//                          SizedBox(width: 14),
//                          Expanded(
//                            child: DropdownButtonFormField<String>(
//                              decoration: InputDecoration(
//                                labelText: 'Min',
//                                contentPadding: EdgeInsets.all(16),
//                                labelStyle: secondaryTextStyle(),
//                                border: OutlineInputBorder(),
//                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
//                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
//                              ),
//                              value: mincontroller,
//                              items:
//                              <String>
//                              ['00','15','30','45']
//                                  .map((label) => DropdownMenuItem(
//                                child: Text(label.toString()),
//                                value: label,
//                              ))
//                                  .toList(),
//                              onChanged: (value) {
//                                setState(() {
//
//                                });
//                              },
//                            ),
//                          ),
//                        ],
//                      ),
//                      16.height,
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          (package == true)
//                              ? Expanded(
//                            child: DropdownButtonFormField<int>(
//                              decoration: InputDecoration(
//                                labelText: 'Hour',
//                                contentPadding: EdgeInsets.all(16),
//                                labelStyle: secondaryTextStyle(),
//                                border: OutlineInputBorder(),
//                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
//                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
//                              ),
//                              value: _hourController,
//                              items:
//                              [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
//                                  .map((label) => DropdownMenuItem(
//                                child: Text(label.toString()),
//                                value: label,
//                              ))
//                                  .toList(),
//                              onChanged: (value) {
//                                setState(() {
//
//                                });
//                              },
//                            ),
//                          )
//                              : Container(),
//
////                        Expanded(
////                                child: DropdownButtonFormField<dynamic>(
////                                  isExpanded: true,
////                                  decoration: InputDecoration(
////                                    labelText: "Choose package",
////                                    labelStyle: TextStyle(fontSize: 14,color: Colors.grey.shade400),
////                                    enabledBorder: OutlineInputBorder(
////                                      borderRadius: BorderRadius.circular(20),
////                                      borderSide: BorderSide(
////                                        color: Colors.grey.shade300,
////                                      ),
////                                    ),
////                                    focusedBorder: OutlineInputBorder(
////                                        borderRadius: BorderRadius.circular(20),
////                                        borderSide: BorderSide(
////                                          color: Colors.blue,
////                                        )
////                                    ),
////                                  ),
////                                  value: packagecontroller,
////                                  items:
////                                  choices.map((label) => DropdownMenuItem(
////                                    child: Text(label.toString()),
////                                    value: label,
////                                  ))
////                                      .toList(),
////                                  onChanged: (value) {
////                                    setState(() {
////
////                                    });
////                                  },
////                                ),
////                              ),
//                        ],
//                      ),
//                      16.height,
//                      Container(
//                        alignment: Alignment.center,
//                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
//                        child: Text('Pay Now', style: boldTextStyle(color: white, size: 18)),
//                      ).onTap(() {
////                          DTSignUpScreen().launch(context);
//                      }),
//                    ]
//                ),
//              ),
//            );
//          },
//        );
      });
    }

    Widget buttonWidget() {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          checkCalendar(),
          buyNowBtn(),

        ],
      );
    }
    print(proid);
    return Scaffold(
      appBar: JTappBar(context, 'Detail'),
      drawer: JTDrawerWidgetUser(),
      body: JTContainerX(
        mobile: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: context.height() * 0.45,
                    child: Image.network(
                      "http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + img,
                      width: context.width(),
                      height: context.height() * 0.45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  10.height,
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              servicename,
                              style: boldTextStyle(size: 18)
                          ),
                          10.height,
                          Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            (rate != "0.00")
                            ? JTpriceWidget(double.parse(rate), fontSize: 28, textColor: Color(0xFF0A79DF))
                            : (min != max)
                            ? Row(
                              children: [
                                JTpriceWidget(min, fontSize: 28, textColor: Color(0xFF0A79DF)),
                                Text(
                                  " to ",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                JTpriceWidget(max, fontSize: 28, textColor: Color(0xFF0A79DF)),
                              ],
                            )
                            : JTpriceWidget(min, fontSize: 28, textColor: Color(0xFF0A79DF)),
                          ],
                        ),
                        10.height,
                        Row(
                          children: [
                            (double.parse(averagerate).toStringAsFixed(1) != "0.0")
                            ? Container(
                              decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(16)),
                              padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.star_border, color: Colors.white, size: 14),
                                  8.width,
                                  Text(double.parse(averagerate).toStringAsFixed(1), style: primaryTextStyle(color: white)),
                                ],
                              ),
                            ).onTap(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JTReviewScreenUser(id: widget.id)),
                              );
                            })
                            : Container(
                              decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(16)),
                              padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.star_border, color: Colors.white, size: 14),
                                  8.width,
                                  Text(double.parse(averagerate).toStringAsFixed(1), style: primaryTextStyle(color: white)),
                                ],
                              ),
                            ),
                            8.width,
                            (totalrating != "0")
                            ? Text(totalrating + ' ratings', style: secondaryTextStyle(size: 16)).onTap(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => JTReviewScreenUser(id: widget.id)),
                              );
                            })
                            : Text('No ratings yet', style: secondaryTextStyle(size: 16)),
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
                                  Text(fullname, style: boldTextStyle()).expand(),
                                ],
                              ).expand(),
                            ],
                          ),
                          4.height,
                          Text(address, style: secondaryTextStyle()),
                          16.height,
                          Divider(height: 0),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 20, 10, 30),
                            child: Text(
                              desc,
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
                                      category,
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
                                      days,
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
                                      hours,
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
                        showModalBottomSheet(
                          context: context,
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
                                  children: _location,
                                ),
                              ),
                            );
                          },
                        );
                      }),
                      (by == "Package" || by == "Package ")
                      ? JTsettingItem(context, 'Packages', leading: Icon(FontAwesome.list, color: Color(0xFF0A79DF), size: 18), textSize: 15, padding: 0.0, onTap: () {
                        showModalBottomSheet(
                          context: context,
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
                                  children: _package,
                                ),
                              ),
                            );
                          },
                        );
                      })
                      : Container(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(bottom: 0, child: buttonWidget()),
          ],
        ),
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


class DisplayPackage extends StatefulWidget {
  const DisplayPackage({Key? key, required this.searchkey}) : super(key: key);
  final String searchkey;
  @override
  _DisplayPackageState createState() => _DisplayPackageState();
}

class _DisplayPackageState extends State<DisplayPackage> {

  // functions starts //

  List category = [];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectcategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });
  }

  // functions ends //

  @override
  Widget build(BuildContext aContext) {
    return Container();
  }
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