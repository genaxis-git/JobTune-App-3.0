import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile/employee/JTProfileScreenEmployee.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTProfileSettingWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTFilterScreen.dart';

import '../../../../../main.dart';


class JTBankingScreen extends StatefulWidget {
  @override
  _JTBankingScreenState createState() => _JTBankingScreenState();
}

class _JTBankingScreenState extends State<JTBankingScreen> {
  List<String> listOfCategory = ['Choose bank..','Maybank', 'CIMB Bank', 'Public Bank Berhad', 'RHB Bank', 'Hong Leong Bank', 'Ambank', 'UOB Malaysia Bank', 'Bank Rakyat', 'OCBC Bank Malaysia', 'HSBC Bank Malaysia', 'Affin Bank', 'Bank Islam Malaysia', 'Standard Chartered Bank Malaysia', 'CitiBank Malaysia', 'Bank Simpanan Nasional', 'Bank Muamalat Malaysia Berhad', 'Alliance Bank', 'Agrobank', 'Al-Rajhi Malaysia', 'MBSB Bank Berhad', 'Co-op Bank Pertama'];
  String? selectedIndexCategory = 'Choose bank..';
  String? dropdownNames;
  String? dropdownScrollable = 'I';
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();
  String pickedbank = "";
  var accno = TextEditingController();

// functions starts //

  List profile = [];
  String email = " ";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      email = lgid;
      profile = json.decode(response.body);
    });

    setState(() {
      accno = TextEditingController(text: profile[0]["bank_account_no"]);
      if(profile[0]["bank_type"] == ""){
        selectedIndexCategory = "Choose bank..";
      }
      else{
        selectedIndexCategory = profile[0]["bank_type"];
      }
    });
  }

  Future<void> updateProfile(btype,bno) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_user_updateprofile&id=" + lgid
                + "&fname=" + profile[0]["first_name"]
                + "&lname=" + profile[0]["last_name"]
                + "&telno=" + profile[0]["phone_no"]
                + "&nric=" + profile[0]["nric"]
                + "&gender=" + profile[0]["gender"]
                + "&race=" + profile[0]["race"]
                + "&desc=" + profile[0]["description"]
                + "&dob=" + profile[0]["dob"]
                + "&address=" + profile[0]["address"]
                + "&city=" + profile[0]["city"]
                + "&state=" + profile[0]["state"]
                + "&postcode=" + profile[0]["postcode"]
                + "&country=" + profile[0]["country"]
                + "&ecname=" + profile[0]["ec_name"]
                + "&ecno=" + profile[0]["ec_phone_no"]
                + "&banktype=" + btype
                + "&bankno=" + bno
                + "&lat=" + profile[0]["location_latitude"]
                + "&long=" + profile[0]["location_longitude"]
                + "&category=" + profile[0]["category"]
        ),
        headers: {"Accept": "application/json"}
    );

    toast("Updated!");
  }

  @override
  void initState() {
    super.initState();
    this.readProfile();
  }

  // functions ends //

  init() async {
    //
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
        title: jtprofile_appBarTitleWidget(context, 'Update Emergency Contact'),
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
                  Text('Emergency Contact', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      20.height,
                      Container(
                        height: 60,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
                        controller: accno,
//                    focusNode: emailFocus,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Account No.',
                          labelStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                      40.height,
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                        child: Text('Update', style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() {
                        if(selectedIndexCategory.toString() == "Choose bank.."){
                          pickedbank = "";
                        }
                        else{
                          pickedbank = selectedIndexCategory.toString();
                        }
                        updateProfile(pickedbank,accno.text);
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
