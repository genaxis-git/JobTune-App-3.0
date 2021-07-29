import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import '../ongoing_order/JTOrderScreen.dart';
import '../co_de_booking/JTCoDeBookingScreen.dart';

class PostService extends StatefulWidget {
  @override
  _PostServiceState createState() => _PostServiceState();
}

class _PostServiceState extends State<PostService> {
  var formKey = GlobalKey<FormState>();

  var titleCont = TextEditingController();
  var descCont = TextEditingController();
  var locationCont = TextEditingController();
  var rateCont = TextEditingController();

  var packnameCont = TextEditingController();
  var priceCont = TextEditingController();
  var timeCont = TextEditingController();

  // functions starts //

  List category = [];
  List<String> listOfCategory = ['Category'];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectcategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      listOfCategory.add(category[m]["category"]);
    }
  }

  Future<void> insertService(days, starts, ends, title, category, by, rate, desc, location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();
    http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_insertservice&proid=" + lgid
                + '&name=' + title
                + '&category=' + category
                + '&by=' + by
                + '&rate=' + rate
                + '&desc=' + desc
                + '&days=' + days
                + '&starts=' + starts
                + '&ends=' + ends
                + '&location=' + location
        ),
        headers: {"Accept": "application/json"}
    );

    if(by == "Package") {
      readlatestService();
    }
    else {
      // navigate: product detail
    }

  }

  List service = [];
  Future<void> readlatestService() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectmaxservice&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      service = json.decode(response.body);
    });

    readAgain();
  }

  String again = "";
  Future<void> readAgain() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectmaxservice&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      again = response.body;
    });

    insertPackage(again);
  }

  Future<void> insertPackage(serviceid) async {

    for(var a=0;a<packagearr.length;a++) {
      var name = packagearr[a].toString().split(" | ")[0];
      var price = packagearr[a].toString().split(" | ")[1];
      var time = packagearr[a].toString().split(" | ")[2].split(" ")[1];

      http.get(
          Uri.parse(
              "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_insertpackage&serviceid=" + serviceid
                  + "&name=" + name
                  + "&rate=" + price
                  + "&time=" + time
          ),
          headers: {"Accept": "application/json"}
      );
    }

    readService(serviceid);
  }

  List info = [];
  Future<void> readService(serviceid) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectservice&id=" + serviceid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      info = json.decode(response.body);
    });


  }
// alert: post success
//    Navigator.push(context,
//      MaterialPageRoute(builder: (context) => JTProductDetail(
////        postid: a,
////        img: info[0]["profile_pic"],
////        name: info[0]["service_name"],
////        provider: info[0]["provider_name"],
////        ratehr: info[0]["rate_hour"],
////        ids: info[0]["provider_id"],
////        category: info[0]["category"],
////        start: info[0]["available_start"],
////        end: info[0]["available_end"],
////        desc: info[0]["description"],
////        loc: info[0]["location"],
////        days:info[0]["available_day"],
////        variation: smallest.toString(),
//      )),
//    );
  @override
  void initState() {
    super.initState();
    this.readCategory();
  }

  // functions ends //

  String? selectedIndexCategory = 'Category';

  List<String> rateBy = [
    'Rate By',
    'Hour',
    'Package',
  ];

  String? selectedRateBy = 'Rate By';

  TimeOfDay selectedTimeIN = TimeOfDay.now();
  TimeOfDay selectedTimeOUT = TimeOfDay.now();

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
  Future<Null> _selectTimeOUT(BuildContext context) async {
    final TimeOfDay? pickedOUT = await showTimePicker(
        context: context,
        initialTime: selectedTimeOUT,
        builder: (BuildContext context, Widget? child) {
          return CustomTheme(
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            ),
          );
        });

    if (pickedOUT != null)
      setState(() {
        selectedTimeOUT = pickedOUT;
      });
  }

  bool? isChecked1 = false;
  bool? isChecked2 = false;
  bool? isChecked3 = false;
  bool? isChecked4 = false;
  bool? isChecked5 = false;
  bool? isChecked6 = false;
  bool? isChecked7 = false;
  bool? isChecked8 = false;
  bool isChecked9 = false;
  bool? isChecked10 = false;
  bool? isChecked11 = false;
  bool? isChecked12 = false;

  List<Widget> _children = [];
  int _count = 0;
  List packagearr = [];
  String rateperhour = "0.00";
  List choosenday = [];
  String stringList = " ";

  void _add(a) {
    _children =
    List.from(_children)
      ..add(Column(
        children: [
          8.height,
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 1.27,
                  child:TextFormField(
                    readOnly: true,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      hintText: a,
                      contentPadding: EdgeInsets.all(16),
                      labelStyle: secondaryTextStyle(),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: appColorPrimary)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                          BorderSide(color: appStore.textSecondaryColor!)),
                    ),
                  )
              ),
              SizedBox(width: 10,),
              Container(
                width: MediaQuery.of(context).size.width / 10,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _children =
                      List.of(_children)
                        ..removeAt(packagearr.indexWhere((packagearr) => packagearr.startsWith(a)));
                    });
                    packagearr.remove(a);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Center(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      )
      );
    setState(() => ++_count);
  }

  Widget availabilityLabel() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'M',
          style: primaryTextStyle(),
        ),
        Text(
          'T',
          style: primaryTextStyle(),
        ),
        Text(
          'W',
          style: primaryTextStyle(),
        ),
        Text(
          'T',
          style: primaryTextStyle(),
        ),
        Text(
          'F',
          style: primaryTextStyle(),
        ),
        Text(
          'S',
          style: primaryTextStyle(),
        ),
        Text(
          'S',
          style: primaryTextStyle(),
        ),
      ],
    );
  }

  Widget availabilityDay() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked1,
            onChanged: (bool? value) {
              setState(() {
                isChecked1 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked2,
            onChanged: (bool? value) {
              setState(() {
                isChecked2 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked3,
            onChanged: (bool? value) {
              setState(() {
                isChecked3 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked4,
            onChanged: (bool? value) {
              setState(() {
                isChecked4 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked5,
            onChanged: (bool? value) {
              setState(() {
                isChecked5 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked6,
            onChanged: (bool? value) {
              setState(() {
                isChecked6 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked7,
            onChanged: (bool? value) {
              setState(() {
                isChecked7 = value;
              });
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              TextFormField(
                controller: titleCont,
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  labelText: 'Title',
                  contentPadding: EdgeInsets.all(16),
                  labelStyle: secondaryTextStyle(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: appColorPrimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: appStore.textSecondaryColor!)),
                ),
                textInputAction: TextInputAction.next,
              ),
              8.height,
              DropdownButtonFormField(
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  // labelText: 'Co-De',
                  contentPadding: EdgeInsets.fromLTRB(8, 16, 16, 16),
                  labelStyle: secondaryTextStyle(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: appColorPrimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: appStore.textSecondaryColor!)),
                ),
                isExpanded: true,
                dropdownColor: appStore.appBarColor,
                value: selectedIndexCategory,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: appStore.iconColor,
                ),
                onChanged: (dynamic newValue) {
                  setState(() {
                    toast(newValue);
                    selectedIndexCategory = newValue;
                  });
                },
                items: listOfCategory.map((category) {
                  return DropdownMenuItem(
                    child: Text(category, style: primaryTextStyle())
                        .paddingLeft(8),
                    value: category,
                  );
                }).toList(),
              ),
              8.height,
              TextFormField(
                controller: descCont,
                maxLines: 5,
                minLines: 3,
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  labelText: 'Description',
                  contentPadding: EdgeInsets.all(16),
                  labelStyle: secondaryTextStyle(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: appColorPrimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: appStore.textSecondaryColor!)),
                ),
                textInputAction: TextInputAction.next,
              ),
              8.height,
              TextFormField(
                controller: locationCont,
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  labelText: 'Preferred Location',
                  contentPadding: EdgeInsets.all(16),
                  labelStyle: secondaryTextStyle(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: appColorPrimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: appStore.textSecondaryColor!)),
                ),
                textInputAction: TextInputAction.next,
              ),
              16.height,
              Text(
                ' Availability (Day)',
                style: primaryTextStyle(),
              ),
              8.height,
              availabilityLabel(),
              availabilityDay(),
              8.height,
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
                  Expanded(
                    child: Card(
                        elevation: 4,
                        child: ListTile(
                          onTap: () {
                            _selectTimeOUT(context);
                          },
                          title: Text(
                            'End Shift',
                            style: primaryTextStyle(),
                          ),
                          subtitle: Text(
                            "${selectedTimeOUT.hour < 10 ? "0${selectedTimeOUT.hour}" : "${selectedTimeOUT.hour}"} : ${selectedTimeOUT.minute < 10 ? "0${selectedTimeOUT.minute}" : "${selectedTimeOUT.minute}"} ${selectedTimeOUT.period != DayPeriod.am ? 'PM' : 'AM'}   ",
                            style: secondaryTextStyle(),
                          ),
                        )),
                  ),
                ],
              ),
              8.height,
              (selectedRateBy == 'Rate By')
              ? DropdownButtonFormField(
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(8, 16, 16, 16),
                  labelStyle: secondaryTextStyle(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: appColorPrimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                          color: appStore.textSecondaryColor!)),
                ),
                isExpanded: true,
                dropdownColor: appStore.appBarColor,
                value: selectedRateBy,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: appStore.iconColor,
                ),
                onChanged: (dynamic newValue) {
                  setState(() {
                    toast(newValue);
                    selectedRateBy = newValue;
                  });
                },
                items: rateBy.map((rateby) {
                  return DropdownMenuItem(
                    child: Text(rateby, style: primaryTextStyle())
                        .paddingLeft(8),
                    value: rateby,
                  );
                }).toList(),
              )
              : (selectedRateBy == 'Hour')
              ? Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        // labelText: 'Co-De',
                        contentPadding: EdgeInsets.fromLTRB(8, 16, 16, 16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: appColorPrimary)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: appStore.textSecondaryColor!)),
                      ),
                      isExpanded: true,
                      dropdownColor: appStore.appBarColor,
                      value: selectedRateBy,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: appStore.iconColor,
                      ),
                      onChanged: (dynamic newValue) {
                        setState(() {
                          toast(newValue);
                          selectedRateBy = newValue;
                        });
                      },
                      items: rateBy.map((rateby) {
                        return DropdownMenuItem(
                          child: Text(rateby, style: primaryTextStyle())
                              .paddingLeft(8),
                          value: rateby,
                        );
                      }).toList(),
                    ),
                  ),
                  8.width,
                  Expanded(
                    child: TextFormField(
                      // controller: mobileCont,
                      // focusNode: mobileFocus,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Rate Per Hour/ Pkg',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: appColorPrimary)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                      textInputAction: TextInputAction.next,
                    ),
                  )
                ],
              )
              : Column(
                children: [
                  DropdownButtonFormField(
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(8, 16, 16, 16),
                      labelStyle: secondaryTextStyle(),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: appColorPrimary)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: appStore.textSecondaryColor!)),
                    ),
                    isExpanded: true,
                    dropdownColor: appStore.appBarColor,
                    value: selectedRateBy,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: appStore.iconColor,
                    ),
                    onChanged: (dynamic newValue) {
                      setState(() {
                        toast(newValue);
                        selectedRateBy = newValue;
                      });
                    },
                    items: rateBy.map((rateby) {
                      return DropdownMenuItem(
                        child: Text(rateby, style: primaryTextStyle())
                            .paddingLeft(8),
                        value: rateby,
                      );
                    }).toList(),
                  ),
                  8.height,
                  TextFormField(
                    controller: packnameCont,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Package Name',
                      contentPadding: EdgeInsets.all(16),
                      labelStyle: secondaryTextStyle(),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: appColorPrimary)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                          BorderSide(color: appStore.textSecondaryColor!)),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  8.height,
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: TextFormField(
                          controller: priceCont,
                          style: primaryTextStyle(),
                          decoration: InputDecoration(
                            labelText: 'Price',
                            contentPadding: EdgeInsets.all(16),
                            labelStyle: secondaryTextStyle(),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: appColorPrimary)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                BorderSide(color: appStore.textSecondaryColor!)),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      9.width,
                      Container(
                        width: MediaQuery.of(context).size.width / 2.17,
                        child: TextFormField(
                          controller: timeCont,
                          style: primaryTextStyle(),
                          decoration: InputDecoration(
                            labelText: 'Expected time needed (Hr)',
                            contentPadding: EdgeInsets.all(16),
                            labelStyle: secondaryTextStyle(),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: appColorPrimary)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                BorderSide(color: appStore.textSecondaryColor!)),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      8.width,
                      Container(
                        width: MediaQuery.of(context).size.width / 10,
                        height: 40,
                        child: GestureDetector(
                          onTap: () {
                            var newname = packnameCont.text + " | RM " + double.parse(priceCont.text).toStringAsFixed(2) + " | est: " + timeCont.text + " Hr";
                            packagearr.add(newname);
                            _add(newname);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: appColorPrimary,
                                borderRadius: BorderRadius.all(Radius.circular(50))),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              16.height,
              Column(children:_children),
              16.height,
              GestureDetector(
                 onTap: () {
                   if(isChecked1 == true){
                     choosenday.add("Monday");
                   }
                   else{
                     choosenday.remove("Monday");
                   }

                   if(isChecked2 == true){
                     choosenday.add("Tuesday");
                   }
                   else{
                     choosenday.remove("Tuesday");
                   }

                   if(isChecked3 == true){
                     choosenday.add("Wednesday");
                   }
                   else{
                     choosenday.remove("Wednesday");
                   }

                   if(isChecked4 == true){
                     choosenday.add("Thursday");
                   }
                   else{
                     choosenday.remove("Thursday");
                   }

                   if(isChecked5 == true){
                     choosenday.add("Friday");
                   }
                   else{
                     choosenday.remove("Friday");
                   }

                   if(isChecked6 == true){
                     choosenday.add("Saturday");
                   }
                   else{
                     choosenday.remove("Saturday");
                   }

                   if(isChecked7 == true){
                     choosenday.add("Sunday");
                   }
                   else{
                     choosenday.remove("Sunday");
                   }

                   stringList = choosenday.join(",");

                   print(selectedTimeIN.hour.toString()+":"+selectedTimeIN.minute.toString()+":00");
                   print(selectedTimeOUT.hour.toString()+":"+selectedTimeOUT.minute.toString()+":00");
                   var starts = selectedTimeIN.hour.toString()+":"+selectedTimeIN.minute.toString()+":00";
                   var ends = selectedTimeOUT.hour.toString()+":"+selectedTimeOUT.minute.toString()+":00";

                   if(selectedTimeOUT.hour > selectedTimeIN.hour) {
                     if(titleCont.text == "" || descCont.text == "" || locationCont.text == "" || stringList == "") {
                       // alert: tak lengkap
                     }
                     else {
                       if(selectedIndexCategory != 'Category') {
                         if(selectedRateBy == 'Hour') {
                           rateperhour = rateCont.text;
                           insertService(stringList,starts,ends,titleCont.text,selectedIndexCategory,selectedRateBy,rateperhour,descCont.text,locationCont.text);
                         }
                         else {
                           rateperhour = "0.00";
                           insertService(stringList,starts,ends,titleCont.text,selectedIndexCategory,selectedRateBy,rateperhour,descCont.text,locationCont.text);
                         }
                       }
                       else{
                         // alert: choose category
                       }
                     }
                   }
                   else {
                     // alert: error masa
                   }
                 },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: appColorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Center(
                    child: Text("Submit", style: boldTextStyle(color: white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
