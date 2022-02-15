import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTProfileSettingWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';

import '../../../../main.dart';


class JTBankScreenProvider extends StatefulWidget {
  @override
  _JTBankScreenProviderState createState() => _JTBankScreenProviderState();
}

class _JTBankScreenProviderState extends State<JTBankScreenProvider> {
  List<String> listOfBank = ['Bank Name..','Maybank', 'Public Bank Berhad', 'RHB Bank', 'Hong Leong Bank', 'Ambank', 'UOB Malaysia Bank', 'Bank Rakyat', 'OCBC Bank Malaysia', 'HSBC Bank Malaysia', 'Affin Bank', 'Bank Islam Malaysia', 'Standard Chartered Bank Malaysia', 'Citibank Malaysia', 'Bank Simpanan Malaysia', 'Bank Muamalat Malaysia Berhad', 'Alliance Bank', 'Agrobank', 'Al-Rajhi Malaysia', 'MBSB Bank Berhad', 'Co-op Bank Pertama'];
  String? selectedIndexBank = 'Bank Name..';
  String? dropdownNames;
  String? dropdownScrollable = 'I';
  bool obscureText = true;
  bool autoValidate = false;
  String pickedbank = "";
  var formKey = GlobalKey<FormState>();

  var bankno = TextEditingController();

  String bankstatus = "false";
  String accstatus = "false";

// functions starts //

  List profile = [];
  String email = " ";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      email = lgid;
      profile = json.decode(response.body);
    });

    setState(() {
      bankno = TextEditingController(text: profile[0]["bank_acc_no"]);
      if(profile[0]["bank_type"] == ""){
        selectedIndexBank = 'Bank Name..';
      }
      else{
        selectedIndexBank = profile[0]["bank_type"];
      }
    });
  }

  Future<void> updateProfile(bankno,bankname) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_provider_updateprofile&id=" + lgid
                + "&names=" + profile[0]["name"]
                + "&type=" + profile[0]["industry_type"]
                + "&telno=" + profile[0]["phone_no"]
                + "&desc=" + profile[0]["description"]
                + "&address=" + profile[0]["address"]
                + "&city=" + profile[0]["city"]
                + "&state=" + profile[0]["state"]
                + "&postcode=" + profile[0]["postcode"]
                + "&country=" + profile[0]["country"]
                + "&banktype=" + bankname
                + "&bankno=" + bankno
                + "&lat=" + profile[0]["location_latitude"]
                + "&long=" + profile[0]["location_longitude"]
        ),
        headers: {"Accept": "application/json"}
    );

    toast("Updated!");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => JTProfileScreenProvider()),
    );
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
        title: jtprofile_appBarTitleWidget(context, 'Update Banking Info'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTProfileScreenProvider()),
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
                  Text('Banking Info', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      20.height,
                      TextFormField(
                        controller: bankno,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Account No.',
                          contentPadding: EdgeInsets.all(16),
                          labelStyle: secondaryTextStyle(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (s) {
                          if (s!.trim().isEmpty) {
                            bankstatus = "false";
                            return errorThisFieldRequired;
                          }
                          else {
                            bankstatus = "true";
                          }
                        },
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
                              value: selectedIndexBank,
                              style: boldTextStyle(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: appStore.iconColor,
                              ),
                              underline: 0.height,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  toast(newValue);
                                  selectedIndexBank = newValue;
                                });
                              },
                              items: listOfBank.map((category) {
                                return DropdownMenuItem(
                                  child: Text(category, style: primaryTextStyle()).paddingLeft(8),
                                  value: category,
                                );
                              }).toList(),
                            )),
                      ),
                      40.height,
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                        child: Text('Update', style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() {
                        if(selectedIndexBank.toString() != 'Bank Name..'){
                          pickedbank = selectedIndexBank.toString();
                        }
                        if(bankstatus != "false" && selectedIndexBank.toString() != 'Bank Name..'){
                          updateProfile(bankno.text,pickedbank);
                        }
                        else{
                          toast("Please make sure all required details are completed.");
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
