import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';

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

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now);

    if(choice != null){
      http.get(
          Uri.parse(
              server + "jtnew_provider_insertservice&proid=" + lgid
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
                  + '&type=' + choice.toString()
                  + '&addtime=' + formattedDate.toString()
          ),
          headers: {"Accept": "application/json"}
      );
    }
    else{
      toast("Please choose your working style");
    }

    readlatestService(by);
  }

  String service = "";
  Future<void> readlatestService(by) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectmaxservice&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      service = response.body;
    });

    readAgain(by);
  }

  String again = "";
  Future<void> readAgain(by) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectmaxservice&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      again = response.body;
    });

    Navigator.pop(context);

    if(by == "Package") {
      insertPackage(again);
    }
    else {
      readFollows(again);
    }
  }

  List follows = [];
  Future<void> readFollows(ids) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectfollowing&id="+ lgid
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      follows = json.decode(response.body);
    });

    for(var k=0; k<follows.length; k++){
      var currentdate = DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now());

      http.get(
          Uri.parse(
              server + "jtnew_provider_insertnewnoti"
                  + "&subject=" + "New Service Available!"
                  + "&message=" + "Your favourite provider have posted a new service. Let's see if you interested with our new service. Just click attachment available below and you will be directed to our posting."
                  + "&attachment=" + ids
                  + "&from=" + lgid
                  + "&to=" + follows[k]["user"]
                  + "&date=" + currentdate
          ),
          headers: {"Accept": "application/json"}
      );
    }

    Navigator.push(context,
      MaterialPageRoute(builder: (context) => JTServiceDetailScreen(
          id: ids,
          page: "detail"
      )),
    );
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
        var name = packagearr[a].toString().split(" | ")[0];
        var price = packagearr[a].toString().split(" | ")[1].split(" ")[1];
        var time = packagearr[a].toString().split(" | ")[2].split(" ")[1];

        http.get(
            Uri.parse(
                server + "jtnew_provider_insertpackage&serviceid=" + serviceid
                    + "&name=" + name
                    + "&rate=" + price
                    + "&time=" + time
            ),
            headers: {"Accept": "application/json"}
        );
      }
    }

    readFollows(serviceid);
  }


  List info = [];
  Future<void> readService(serviceid) async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectservice&id=" + serviceid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      info = json.decode(response.body);
    });
  }

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

        if(selectedTimeOUT.hour < selectedTimeIN.hour){
          toast("Error: please check Start Shift.");
        }
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
  var choice;
  String style = "false";

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

    void _onHorizontalLoading1() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: appStore.scaffoldBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  16.width,
                  CircularProgressIndicator(
                    backgroundColor: Color(0xffD6D6D6),
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                  16.width,
                  Text(
                    "Please Wait....",
                    style: primaryTextStyle(color: appStore.textPrimaryColor),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

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
              16.height,
              Text(
                ' Working style',
                style: primaryTextStyle(),
              ),
              8.height,
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(unselectedWidgetColor: appStore.textPrimaryColor),
                        child: Radio(
                          value: 'Remote',
                          groupValue: choice,
                          onChanged: (dynamic value) {
                            setState(() {
                              choice = value;
                              toast("$choice Selected");
                              style = "false";
                            });
                          },
                        ),
                      ),
                      Text('Online/ Remote/ From home', style: primaryTextStyle()),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: appStore.textPrimaryColor,
                        ),
                        child: Radio(
                          value: 'Physical',
                          groupValue: choice,
                          onChanged: (dynamic value) {
                            setState(() {
                              choice = value;
                              toast("$choice Selected");
                              style = "true";
                            });
                          },
                        ),
                      ),
                      Text('Physical/ On-site', style: primaryTextStyle()),
                    ],
                  ),
                ],
              ),
              8.height,
              (style == "true")
                  ? TextFormField(
                controller: locationCont,
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  labelText: 'Preferred  Location (city names, state names..)',
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
              )
                  : Container(),
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
                          keyboardType: TextInputType.number,
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
                  // Row(
                  //   children: [
                  //     Flexible(
                  //       child: Text(
                  //         "We would like to inform you that a sum of RM "+insurancefee+" will be deducted from the total amount of payment you will receive each time as your insurance fee.",
                  //         maxLines: 4,
                  //         overflow: TextOverflow.clip,
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              )
              : Container(),
              16.height,
              GestureDetector(
                 onTap: () {
                   _onHorizontalLoading1();
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
                     if(choice != null){
                       if(choice == "Remote"){
                         if(titleCont.text == "" || descCont.text == "" || stringList == "") {
                           toast("Form not complete");
                         }
                         else {
                           if(selectedIndexCategory != 'Category') {
                             if(selectedRateBy == 'Hour') {
                               rateperhour = rateCont.text;
                               insertService(stringList,starts,ends,titleCont.text,selectedIndexCategory,selectedRateBy,double.parse(rateperhour).toStringAsFixed(2),descCont.text,"Online/ Remote/ From home",insurancefee);
                             }
                             else {
                               rateperhour = "0.00";
                               insertService(stringList,starts,ends,titleCont.text,selectedIndexCategory,selectedRateBy,rateperhour,descCont.text,"Online/ Remote/ From home",insurancefee);
                             }
                           }
                           else{
                             toast("Please choose service category first.");
                           }
                         }
                       }
                       else{
                         if(titleCont.text == "" || descCont.text == "" || locationCont.text == "" || stringList == "") {
                           toast("Form not complete");
                         }
                         else {
                           if(selectedIndexCategory != 'Category') {
                             if(selectedRateBy == 'Hour') {
                               rateperhour = rateCont.text;
                               insertService(stringList,starts,ends,titleCont.text,selectedIndexCategory,selectedRateBy,double.parse(rateperhour).toStringAsFixed(2),descCont.text,locationCont.text,insurancefee);
                             }
                             else {
                               rateperhour = "0.00";
                               insertService(stringList,starts,ends,titleCont.text,selectedIndexCategory,selectedRateBy,rateperhour,descCont.text,locationCont.text,insurancefee);
                             }
                           }
                           else{
                             toast("Please choose service category first.");
                           }
                         }
                       }
                     }
                     else{
                       toast("Form not completed");
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
