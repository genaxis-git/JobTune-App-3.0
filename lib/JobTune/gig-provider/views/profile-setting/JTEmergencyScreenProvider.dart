import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile/employee/JTProfileScreenEmployee.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTProfileSettingWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';

import '../../../../main.dart';


class JTAccountServiceProvider extends StatefulWidget {
  const JTAccountServiceProvider({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _JTAccountServiceProviderState createState() => _JTAccountServiceProviderState();
}

class _JTAccountServiceProviderState extends State<JTAccountServiceProvider> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var names = TextEditingController();
  var telnos = TextEditingController();

  String namestatus = "false";
  String nostatus = "false";

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
      names = TextEditingController(text: profile[0]["emergency_name"]);
      telnos = TextEditingController(text: profile[0]["emergency_no"]);
    });
  }

  Future<void> updateProfile(names,telnos) async {
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
                + "&banktype=" + profile[0]["bank_type"]
                + "&bankno=" + profile[0]["bank_acc_no"]
                + "&lat=" + profile[0]["location_latitude"]
                + "&long=" + profile[0]["location_longitude"]
                + "&ecname=" + names
                + "&ecno=" + telnos
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
                  Text('Emergency Contact', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      20.height,
                      TextFormField(
                        controller: names,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Guardian Name',
                          contentPadding: EdgeInsets.all(16),
                          labelStyle: secondaryTextStyle(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (s) {
                          if (s!.trim().isEmpty) {
                            namestatus = "false";
                            return errorThisFieldRequired;
                          }
                          else {
                            namestatus = "true";
                          }
                        },
                      ),
                      16.height,
                      TextFormField(
                        controller: telnos,
//                    focusNode: emailFocus,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Guardian Phone No.',
                          labelStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (s) {
                          if (s!.trim().isEmpty) {
                            nostatus = "false";
                            return errorThisFieldRequired;
                          }
                          else {
                            nostatus = "true";
                          }
                        },
                      ),
                      40.height,
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                        child: Text('Update', style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() {
                        if(namestatus != "false" && nostatus != "false"){
                          updateProfile(names.text,telnos.text);
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
