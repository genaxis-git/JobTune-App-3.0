import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile/employee/JTProfileScreenEmployee.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTProfileSettingWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';

import '../../../../../main.dart';

class JTExperienceScreenEmployee extends StatefulWidget {
  const JTExperienceScreenEmployee({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _JTExperienceScreenEmployeeState createState() => _JTExperienceScreenEmployeeState();
}

class _JTExperienceScreenEmployeeState extends State<JTExperienceScreenEmployee> {
  List<String> listOfRace = ['Choose Race..','Malay', 'Chinese', 'Indian', 'Others', 'Foreign/ Non-Malaysian'];
  String? selectedIndexRace = 'Choose Race..';
  List<String> listOfGender = ['Choose Gender..','Male', 'Female'];
  String? selectedIndexGender = 'Choose Gender..';
  String? dropdownNames;
  String? dropdownScrollable = 'I';
  bool obscureText = true;
  bool autoValidate = false;
  String pickedgender = "";
  String pickedrace = "";
  String pickedtype = "";
  bool _isSelected_agree = false;
  var formKey = GlobalKey<FormState>();

  var title = TextEditingController();
  var company = TextEditingController();
  var desc = TextEditingController();


  // functions starts //

  List category = [];
  String? selectedIndexCategory = 'Job Category..';
  List<String> listOfCategory = ['Job Category..'];
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

  Future<void> addExp(title,company,type,desc,ins,outs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_user_insertexperience&id=" + lgid
                + "&name=" + title
                + "&desc=" + desc
                + "&from=" + ins
                + "&to=" + outs
                + "&category=" + type
                + "&comp=" + company
        ),
        headers: {"Accept": "application/json"}
    );

    toast("Added!");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JTProfileScreenEmployee()),
    );
  }

  Future<void> updateExp(title,company,type,desc,ins,outs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_user_updateexperience&id=" + lgid
                + "&name=" + title
                + "&desc=" + desc
                + "&from=" + ins
                + "&to=" + outs
                + "&category=" + type
                + "&comp=" + company
                + "&exp=" + widget.id
        ),
        headers: {"Accept": "application/json"}
    );

    toast("Updated!");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JTProfileScreenEmployee()),
    );
  }

  List explist = [];
  Future<void> readExp() async {
    if(widget.id != "non"){
      http.Response response = await http.get(
          Uri.parse(
              server + "jtnew_user_selectexperiencebyid&id=" + widget.id),
          headers: {"Accept": "application/json"}
      );

      this.setState(() {
        explist = json.decode(response.body);
      });

      setState(() {
        title = TextEditingController(text: explist[0]["exp_name"]);
        desc = TextEditingController(text: explist[0]["exp_desc"]);
        company = TextEditingController(text: explist[0]["exp_company"]);
        if(explist[0]["exp_category"] == ""){
          selectedIndexCategory = 'Job Category..';
        }
        else{
          selectedIndexCategory = explist[0]["exp_category"];
        }
        if(explist[0]["from"] != "") {
          selectedDateIN = DateTime.parse(explist[0]["from"]);
        }
        if(explist[0]["to"] == "current") {
          DateTime now = new DateTime.now();
          DateTime date = new DateTime(now.year, now.month, now.day);
          selectedDateOUT = date;
          _isSelected_agree = true;
        }
        if(explist[0]["to"] != "") {
          selectedDateOUT = DateTime.parse(explist[0]["to"]);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.readCategory();
    this.readExp();
  }

  // functions ends //
  DateTime selectedDateIN = DateTime.now();
  DateTime selectedDateOUT = DateTime.now();
  Future<void> _selectDateIN(BuildContext context) async {
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
        initialDate: selectedDateIN,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateIN)
      setState(() {
        selectedDateIN = picked;
      });
  }
  Future<void> _selectDateOUT(BuildContext context) async {
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
        initialDate: selectedDateOUT,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateOUT)
      setState(() {
        selectedDateOUT = picked;
      });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: (widget.id == "non") ? jtprofile_appBarTitleWidget(context, 'Add Experience') : jtprofile_appBarTitleWidget(context, 'Update Experience'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTProfileScreenEmployee()),
              );
            }
        ),
      ),
      body: Center(
        child: Container(
          width: jtsetting_dynamicWidth(context),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Working Experience', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      30.height,
                      TextFormField(
                        controller: title,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Job Title',
                          contentPadding: EdgeInsets.all(16),
                          labelStyle: secondaryTextStyle(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      16.height,
                      TextFormField(
                        controller: company,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Company/ Employer Name',
                          labelStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      16.height,
                      Container(
                        height: 60,
                        child: Card(
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
                              value: selectedIndexCategory,
                              style: boldTextStyle(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: appStore.iconColor,
                              ),
                              underline: 0.height,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  toast(newValue);
                                  selectedIndexCategory = newValue;
                                });
                              },
                              items: listOfCategory.map((category) {
                                return DropdownMenuItem(
                                  child: Text(category, style: primaryTextStyle()).paddingLeft(8),
                                  value: category,
                                );
                              }).toList(),
                            )),
                      ),
                      16.height,
                      TextFormField(
                        controller: desc,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Description (optional)',
                          labelStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      16.height,
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                                elevation: 4,
                                child: ListTile(
                                  onTap: () {
                                    _selectDateIN(context);
                                  },
                                  title: Text(
                                    'Start date',
                                    style: primaryTextStyle(),
                                  ),
                                  subtitle: Text(
                                    "${selectedDateIN.toLocal()}".split(' ')[0],
                                    style: secondaryTextStyle(),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.date_range,
                                      color: appStore.iconColor,
                                    ),
                                    onPressed: () {
                                      _selectDateIN(context);
                                    },
                                  ),
                                )),
                          ),
                          8.width,
                          Expanded(
                            child: Card(
                                elevation: 4,
                                child: ListTile(
                                  onTap: () {
                                    _selectDateOUT(context);
                                  },
                                  title: Text(
                                    'End date',
                                    style: primaryTextStyle(),
                                  ),
                                  subtitle: Text(
                                    "${selectedDateOUT.toLocal()}".split(' ')[0],
                                    style: secondaryTextStyle(),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.date_range,
                                      color: appStore.iconColor,
                                    ),
                                    onPressed: () {
                                      _selectDateOUT(context);
                                    },
                                  ),
                                )),
                          ),
                          8.width,
                        ],
                      ),
                      20.height,
                      Container(
                        alignment: Alignment.topLeft,
                        child: CheckboxListTile(
                          title: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "I am currently working here.",
                                    style: TextStyle(
                                        fontSize: 15
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          value: _isSelected_agree,
                          onChanged: (newValue) {
                            setState(() {
                              _isSelected_agree = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      40.height,
                      (widget.id == "non")
                      ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                        child: Text('Add', style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() async {
                        if(selectedIndexCategory.toString() != 'Job Category..'){
                          pickedtype = selectedIndexCategory.toString();
                        }
                        if(_isSelected_agree == true){
                          addExp(title.text,company.text,pickedtype.toString(),desc.text,selectedDateIN.toString().split(" ")[0],"current");
                        }
                        else{
                          addExp(title.text,company.text,pickedtype.toString(),desc.text,selectedDateIN.toString().split(" ")[0],selectedDateOUT.toString().split(" ")[0]);
                        }
                      })
                      : Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                        child: Text('Update', style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() async {
                        if(selectedIndexCategory.toString() != 'Job Category..'){
                          pickedtype = selectedIndexCategory.toString();
                        }
                        if(_isSelected_agree == true){
                          updateExp(title.text,company.text,pickedtype.toString(),desc.text,selectedDateIN.toString().split(" ")[0],"current");
                        }
                        else{
                          updateExp(title.text,company.text,pickedtype.toString(),desc.text,selectedDateIN.toString().split(" ")[0],selectedDateOUT.toString().split(" ")[0]);
                        }
                      }),
                      20.height,
                    ],
                  ),
                ],
              ),
            ),
          ).center(),
        ),
      ),
    );
  }
}
