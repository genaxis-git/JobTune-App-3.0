import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';

import '../../../../main.dart';
import 'JTProfileSettingWidgetUser.dart';

class JTPersonalScreenUser extends StatefulWidget {
  @override
  _JTPersonalScreenUserState createState() => _JTPersonalScreenUserState();
}

class _JTPersonalScreenUserState extends State<JTPersonalScreenUser> {
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
  var formKey = GlobalKey<FormState>();

  var fname = TextEditingController();
  var lname = TextEditingController();
  var nric = TextEditingController();
  var dob = TextEditingController();
  var description = TextEditingController();


  // functions starts //

  List profile = [];
  String email = " ";
  String dbgender = " ";
  String dbrace = " ";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      email = lgid;
      profile = json.decode(response.body);
    });

    setState(() {
      fname = TextEditingController(text: profile[0]["first_name"]);
      lname = TextEditingController(text: profile[0]["last_name"]);
      nric = TextEditingController(text: profile[0]["nric"]);
      dob = TextEditingController(text: profile[0]["dob"]);
      description = TextEditingController(text: profile[0]["description"]);
      if(profile[0]["gender"] == ""){
        selectedIndexGender = 'Choose Gender..';
      }
      else{
        selectedIndexGender = profile[0]["gender"];
      }

      if(profile[0]["race"] == ""){
        selectedIndexRace = 'Choose Race..';
      }
      else{
        selectedIndexRace = profile[0]["race"];
      }
    });
  }

  Future<void> updateProfile(fname,lname,nric,gender,race,desc,dob) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_updateprofile&id=" + lgid
                + "&fname=" + fname
                + "&lname=" + lname
                + "&telno=" + profile[0]["phone_no"]
                + "&nric=" + nric
                + "&gender=" + gender
                + "&race=" + race
                + "&desc=" + desc
                + "&dob=" + dob
                + "&address=" + profile[0]["address"]
                + "&city=" + profile[0]["city"]
                + "&state=" + profile[0]["state"]
                + "&postcode=" + profile[0]["postcode"]
                + "&country=" + profile[0]["country"]
                + "&ecname=" + profile[0]["ec_name"]
                + "&ecno=" + profile[0]["ec_phone_no"]
                + "&banktype=" + profile[0]["bank_type"]
                + "&bankno=" + profile[0]["bank_account_no"]
                + "&lat=" + profile[0]["location_latitude"]
                + "&long=" + profile[0]["location_longitude"]
        ),
        headers: {"Accept": "application/json"}
    );

    //alert: update success
  }

  @override
  void initState() {
    super.initState();
    this.readProfile();
  }

  // functions ends //


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, 'Update Personal Info'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTProfileScreenUser()),
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
                  Text('Personal Info', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.height,
                      Image.asset("images/dashboard/db_profile.jpeg", height: 120, width: 120, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
                      30.height,
                      TextFormField(
                        controller: fname,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'First Name',
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
                        controller: lname,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Last Name',
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
                      TextFormField(
                        controller: nric,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'NRIC No. /Passport No.',
                          contentPadding: EdgeInsets.all(16),
                          labelStyle: secondaryTextStyle(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                      16.height,
                      TextFormField(
                        controller: dob,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Date of birth',
                          labelStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.datetime,
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
                              value: selectedIndexRace,
                              style: boldTextStyle(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: appStore.iconColor,
                              ),
                              underline: 0.height,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  toast(newValue);
                                  selectedIndexRace = newValue;
                                });
                              },
                              items: listOfRace.map((category) {
                                return DropdownMenuItem(
                                  child: Text(category, style: primaryTextStyle()).paddingLeft(8),
                                  value: category,
                                );
                              }).toList(),
                            )),
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
                              value: selectedIndexGender,
                              style: boldTextStyle(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: appStore.iconColor,
                              ),
                              underline: 0.height,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  toast(newValue);
                                  selectedIndexGender = newValue;
                                });
                              },
                              items: listOfGender.map((category) {
                                return DropdownMenuItem(
                                  child: Text(category, style: primaryTextStyle()).paddingLeft(8),
                                  value: category,
                                );
                              }).toList(),
                            )),
                      ),
                      16.height,
                      TextFormField(
                        controller: description,
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
                      40.height,
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                        child: Text('Update', style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() {
                        if(selectedIndexGender.toString() != 'Choose Gender..'){
                          pickedgender = selectedIndexGender.toString();
                        }
                        if(selectedIndexRace.toString() != 'Choose Race'){
                          pickedrace = selectedIndexRace.toString();
                        }
                        updateProfile(fname.text,lname.text,nric.text,pickedgender,pickedrace,description.text,dob.text);
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
