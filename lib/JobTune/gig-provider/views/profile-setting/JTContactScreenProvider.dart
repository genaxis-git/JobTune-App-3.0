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


class JTContactScreenProvider extends StatefulWidget {
  @override
  _JTContactScreenProviderState createState() => _JTContactScreenProviderState();
}

class _JTContactScreenProviderState extends State<JTContactScreenProvider> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var phoneno = TextEditingController();
  var emails = TextEditingController();

  // functions starts //

  List profile = [];
  String lgemail = " ";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      lgemail = lgid;
      profile = json.decode(response.body);
    });

    setState(() {
      phoneno = TextEditingController(text: profile[0]["phone_no"]);
      emails = TextEditingController(text: profile[0]["email"]);
    });
  }

  Future<void> updateProfile(telno) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_provider_updateprofile&id=" + lgid
                + "&names=" + profile[0]["name"]
                + "&type=" + profile[0]["industry_type"]
                + "&telno=" + telno
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

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, 'Update Contacts Info'),
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
                  Text('Contacts Info', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      20.height,
                      TextFormField(
                        controller: phoneno,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Phone No.',
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
                        readOnly: true,
                        controller: emails,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      40.height,
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                        child: Text('Update', style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() {
                        updateProfile(phoneno.text);
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
