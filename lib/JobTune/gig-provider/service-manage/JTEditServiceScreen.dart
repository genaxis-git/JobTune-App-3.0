import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';

import 'JTManageServiceScreen.dart';

class EditService extends StatefulWidget {
  const EditService({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  var formKey = GlobalKey<FormState>();

  var titleCont = TextEditingController();
  var descCont = TextEditingController();
  var locationCont = TextEditingController();
  var rateCont = TextEditingController();
  bool _isSelected_agree = false;
  var packnameCont = TextEditingController();
  var priceCont = TextEditingController();
  var timeCont = TextEditingController();

  // functions starts //

  List category = [];
  List<String> listOfCategory = ['Category'];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectcategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      listOfCategory.add(category[m]["category"]);
    }
  }

  List fee = [];
  String insurancefee = "";
  Future<void> readFee(a) async {
    print(a);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectcategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      fee = json.decode(response.body);
    });

    for(var m=0;m<fee.length;m++){
      if(fee[m]["category"] == a){
        setState(() {
          insurancefee = (double.parse(fee[m]["insurance_pl_fee"]) + 0.50).toStringAsFixed(2);
        });
      }
    }
  }

  Future<void> insertService(days, starts, ends, title, category, by, rate, desc, location, fee) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_provider_deletepackage&id=" + widget.id
        ),
        headers: {"Accept": "application/json"}
    );

    http.get(
        Uri.parse(
            server + "jtnew_provider_updateservice&id=" + widget.id
                + '&name=' + title
                + '&category=' + category
                + '&by=' + by
                + '&rate=' + rate
                + '&desc=' + desc
                + '&days=' + days
                + '&starts=' + starts
                + '&ends=' + ends
                + '&location=' + location
                + '&fee=' + fee
        ),
        headers: {"Accept": "application/json"}
    );

    readlatestService(by);

  }

  String service = "";
  Future<void> readlatestService(by) async {
    readAgain(by);
  }

  String again = "";
  Future<void> readAgain(by) async {
    if(by == "Package") {
      insertPackage(widget.id);
    }
    else {
      // navigate: product detail
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => JTServiceDetailScreen(
          id: widget.id,
          page: "detail"
        )),
      );
    }
  }

  Future<void> insertPackage(serviceid) async {
    if(packagearr.length == 0) {
      http.get(
          Uri.parse(
              server + "jtnew_provider_insertpackage&serviceid=" + serviceid
                  + "&name=" + packnameCont.text
                  + "&rate=" + double.parse(priceCont.text).toStringAsFixed(2)
                  + "&time=" + timeCont.text
          ),
          headers: {"Accept": "application/json"}
      );
    }
    else {
      for(var a=0;a<packagearr.length;a++) {
        sendPackage(packagearr[a], serviceid);
      }
    }

    checkAllPackage();
  }

  List checking = [];
  List checkedarr = [];
  Future<void> checkAllPackage() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectpackage&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      checking = json.decode(response.body);
    });

    print("ni dari db satu kali: ");
    print(checking);
    checkAllPackage2();
  }

  Future<void> checkAllPackage2() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectpackage&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      checking = json.decode(response.body);
    });

    print("ni dari db dua kali: ");
    print(checking);

    for(var k=0;k<checking.length;k++){
      var packname = checking[k]["package_name"] + " | RM " + double.parse(checking[k]["package_rate"]).toStringAsFixed(2) + " | est: " + checking[k]["package_time"] + " Hr";
      checkedarr.add(packname);
    }

    for(var p=0;p<packagearr.length;p++) {
      if(checkedarr.contains(packagearr[p]) == false) {
        print(packagearr[p]);
        print(checkedarr);
        sendPackage(packagearr[p], widget.id);
      }
    }
    // checkAllPackage();
    // alert: post success
    toast("Post Updated!");
    checkedarr = [];
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => JTServiceDetailScreen(
        id: widget.id,
        page: "detail"
      )),
    );
  }

  Future<void> sendPackage(arr,serviceid) async {
    var name = arr.toString().split(" | ")[0];
    var price = arr.toString().split(" | ")[1].split(" ")[1];
    var time = arr.toString().split(" | ")[2].split(" ")[1];

    http.get(
        Uri.parse(
            server + "jtnew_provider_insertpackage&serviceid=" + serviceid
                + "&name=" + Uri.encodeComponent(name)
                + "&rate=" + price
                + "&time=" + time
        ),
        headers: {"Accept": "application/json"}
    );
  }

  List info = [];
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
      titleCont = TextEditingController(text: info[0]["name"]);
      descCont = TextEditingController(text: info[0]["description"].toString().replaceAll("<br>", "\n"));
      locationCont = TextEditingController(text: info[0]["location"]);

      if(info[0]["available_start"] != ""){
        selectedTimeIN = TimeOfDay.fromDateTime(DateTime.parse("2020-10-10 " + info[0]["available_start"]));
      }

      if(info[0]["available_end"] != ""){
        selectedTimeOUT = TimeOfDay.fromDateTime(DateTime.parse("2020-10-10 " + info[0]["available_end"]));
      }

      if(info[0]["category"] == ""){
        selectedIndexCategory = 'Category';
      }
      else{
        selectedIndexCategory = info[0]["category"];
      }

      if(info[0]["rate_by"] == ""){
        selectedRateBy = 'Rate By';
      }
      else{
        selectedRateBy = info[0]["rate_by"];
        if(info[0]["rate_by"] == "Hour"){
          rateCont = TextEditingController(text: info[0]["rate"]);
        }
        else{
          readPackage();
        }
      }

      if(info[0]["available_day"] != ""){
        var res = info[0]["available_day"].split(",");
        for(var m=0; m<res.length; m++){
          if(res[m] == "Monday"){
            isChecked1 = true;
          }
          if(res[m] == "Tuesday"){
            isChecked2 = true;
          }
          if(res[m] == "Wednesday"){
            isChecked3 = true;
          }
          if(res[m] == "Thursday"){
            isChecked4 = true;
          }
          if(res[m] == "Friday"){
            isChecked5 = true;
          }
          if(res[m] == "Saturday"){
            isChecked6 = true;
          }
          if(res[m] == "Sunday"){
            isChecked7 = true;
          }
        }
      }
    });
  }

  List filledcat = [];
  Future<void> readPackage() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectpackage&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      filledcat = json.decode(response.body);
    });

    for(var m=0; m<filledcat.length; m++){
      var newname = filledcat[m]["package_name"] + " | RM " + double.parse(filledcat[m]["package_rate"]).toStringAsFixed(2) + " | est: " + filledcat[m]["package_time"] + " Hr";
      packagearr.add(newname);
      print("db: " + packagearr.length.toString());
      _add(newname);
    }
    print(packagearr);
  }


  @override
  void initState() {
    super.initState();
    this.readService();
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
      ..add(
          Column(
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, 'Edit Post'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ServiceScreen()),
              );
            }),
      ),
      body: ContainerX(
        mobile: SingleChildScrollView(
            padding: EdgeInsets.only(top: 16),
            child: Container(
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
                            readFee(selectedIndexCategory.toString());
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
                              controller: rateCont,
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
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              9.width,
                              Container(
                                width: MediaQuery.of(context).size.width / 2.17,
                                child: TextFormField(
                                  controller: timeCont,
                                  style: primaryTextStyle(),
                                  decoration: InputDecoration(
                                    labelText: 'Time per package (Hr)',
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
                                  keyboardType: TextInputType.number
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
                                    print("adding: " + packagearr.length.toString());
                                    _add(newname);
                                    packnameCont.clear();
                                    priceCont.clear();
                                    timeCont.clear();
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
                      (insurancefee != "")
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          20.height,
                          // Container(
                          //   alignment: Alignment.topLeft,
                          //   child: CheckboxListTile(
                          //     title: Column(
                          //       children: [
                          //         Row(
                          //           children: [
                          //             Flexible(
                          //               child: Text(
                          //                 "I agree that a sum of RM "+insurancefee+" will be deducted from the total amount of payment I will receive each time as my insurance fee.",
                          //                 maxLines: 4,
                          //                 overflow: TextOverflow.clip,
                          //                 style: TextStyle(
                          //                   fontSize: 15,
                          //                 ),
                          //               ),
                          //             )
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //     value: _isSelected_agree,
                          //     onChanged: (newValue) {
                          //       setState(() {
                          //         _isSelected_agree = newValue!;
                          //       });
                          //     },
                          //     controlAffinity: ListTileControlAffinity.leading,
                          //   ),
                          // ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  "We would like to inform you that a sum of RM "+insurancefee+" will be deducted from the total amount of payment you will receive each time as your insurance fee.",
                                  maxLines: 4,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                          : Container(),
                      16.height,
                      GestureDetector(
                        onTap: () {
                          choosenday = [];
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

                          String hrin = "";
                          String hrout = "";
                          String minin = "";
                          String minout = "";
                          if(selectedTimeIN.hour<10){
                            hrin = "0" + selectedTimeIN.hour.toString();
                          }
                          else {
                            hrin = selectedTimeIN.hour.toString();
                          }
                          if(selectedTimeOUT.hour<10){
                            hrout = "0" + selectedTimeOUT.hour.toString();
                          }
                          else {
                            hrout = selectedTimeOUT.hour.toString();
                          }
                          if(selectedTimeIN.minute<10){
                            minin = "0" + selectedTimeIN.minute.toString();
                          }
                          else {
                            minin = selectedTimeIN.minute.toString();
                          }
                          if(selectedTimeOUT.minute<10){
                            minout = "0" + selectedTimeOUT.minute.toString();
                          }
                          else {
                            minout = selectedTimeOUT.minute.toString();
                          }
                          var starts = hrin +":"+minin+":00";
                          var ends = hrout+":"+minout+":00";

                          if(selectedTimeOUT.hour > selectedTimeIN.hour) {
                            if(titleCont.text == "" || descCont.text == "" || locationCont.text == "" || stringList == "") {
                              toast("Form not complete");
                            }
                            else {
                              if(selectedIndexCategory != 'Category') {
                                if(selectedRateBy == 'Hour') {
                                  rateperhour = rateCont.text;
                                  toast("Loading..");
                                  insertService(stringList,starts,ends,titleCont.text,selectedIndexCategory,selectedRateBy,double.parse(rateperhour).toStringAsFixed(2),descCont.text,locationCont.text,insurancefee);
                                }
                                else {
                                  rateperhour = "0.00";
                                  toast("Loading..");
                                  insertService(stringList,starts,ends,titleCont.text,selectedIndexCategory,selectedRateBy,rateperhour,descCont.text,locationCont.text,insurancefee);
                                }
                              }
                              else{
                                toast("Please choose service category first.");
                              }
                            }
                          }
                          else {
                            toast("Error: something wrong with the Shift time selection. Please check again");
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: appColorPrimary,
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Edit", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }
}
