import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/register-login/JTSignInScreen.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JTResetPasswordScreen extends StatefulWidget {
  static String tag = '/JTResetPasswordScreen';

  const JTResetPasswordScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _JTResetPasswordScreenState createState() => _JTResetPasswordScreenState();
}

class _JTResetPasswordScreenState extends State<JTResetPasswordScreen> {
  var newpassCont = TextEditingController();
  var cfmpassCont = TextEditingController();
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();
  String newstatus = "false";
  String cfmstatus = "false";

  List user = [];

  Future<void> updatePassword(newpass,cfmpass) async {
    http.get(
        Uri.parse(
            server + "jtnew_changepassword&jUname=" + widget.id + "&jNew=" + cfmpass),
        headers: {"Accept": "application/json"}
    );
    toast("Reset Success! You now may login with this new password.");

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => JTSignInScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Reset New Password'),
//      drawer: DTDrawerWidget(),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          width: dynamicWidth(context),
          alignment: Alignment.center,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Reset New Password', style: boldTextStyle(size: 24)),
                    30.height,
                    TextFormField(
                      controller: newpassCont,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          newstatus = "false";
                          return 'Password cannot be empty';
                        }
                        else if (value.length < 8) {
                          newstatus = "false";
                          return 'Must be at least 8 characters long';
                        }
                        else if (value.contains(new RegExp(r'[A-Z]')) == false) {
                          newstatus = "false";
                          return 'Must be at least contain 1 Uppercase Alphabets';
                        }
                        else if (value.contains(new RegExp(r'[a-z]')) == false) {
                          newstatus = "false";
                          return 'Must be at least contain 1 Lowercase Alphabets';
                        }
                        else if (value.contains(new RegExp(r'[0-9]')) == false) {
                          newstatus = "false";
                          return 'Must be at least contain 1 Numbers';
                        }
                        else{
                          newstatus = "true";
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    12.height,
                    TextFormField(
                      controller: cfmpassCont,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Re-type Password',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          cfmstatus = "false";
                          return 'Password cannot be empty';
                        }
                        else if(value != newpassCont.text.toString()) {
                          cfmstatus = "false";
                          return 'Password not matched.';
                        }
                        else{
                          cfmstatus = "true";
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    20.height,
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                      child: Text('Reset', style: boldTextStyle(color: white, size: 18)),
                    ).onTap(() async {
                      if(newstatus == "true" && cfmstatus == "true"){
                        updatePassword(newpassCont.text,cfmpassCont.text);
                      }
                    }),
                  ],
                ),
              ),
            ),
          ).center(),
        ),
      ),
    );
  }
}
