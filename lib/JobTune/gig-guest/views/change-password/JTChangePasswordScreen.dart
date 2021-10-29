import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/account/JTAccountScreenUsers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../main.dart';
import 'JTChangePasswordWidget.dart';

class JTChangePasswordScreen extends StatefulWidget {
  static String tag = '/JTChangePasswordScreen';

  @override
  _JTChangePasswordScreenState createState() => _JTChangePasswordScreenState();
}

class _JTChangePasswordScreenState extends State<JTChangePasswordScreen> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var newpass = TextEditingController();
  var retype = TextEditingController();
  var oldpass = TextEditingController();

  String oldstatus = "false";
  String newstatus = "false";
  String cfmstatus = "false";

  // functions starts //

  List user = [];
  String acc = "";
  Future<void> checkpass(old, newpass, cfm) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(old == ""){
      toast("Changing password is not allowed until you verify your previous password with us.");
    }
    else{
      if(newpass != cfm){
        toast("Your New Password and Confirm New Password are not matched. Please re-try to verify.");
      }
      else{
        http.Response response = await http.get(
            Uri.parse(
                server + "jtnew_selectlogins&lgid=" + lgid),
            headers: {"Accept": "application/json"}
        );

        this.setState(() {
          user = json.decode(response.body);
        });

        if(newpass == user[0]["password"]){
          toast("This action is not necessary if you still want to stay with your old password.");
        }
        else{
          if(old != user[0]["password"]){
            toast("Keyed-in password is not matched as your old password. Please re-try.");
          }
          else{
            updatePass(old, newpass, cfm);
          }
        }
      }
    }
  }

  Future<void> updatePass(old, newpass, cfm) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_changepassword&jUname="+lgid+"&jNew="+cfm),
        headers: {"Accept": "application/json"}
    );

    toast("Password Changed!");
    toast("You may log in to your account with the new set up password after this.");
    Navigator.pop(
      context,
    );
  }

  Future<void> checkacc() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    setState(() {
      acc = lgid;
    });
  }

  // functions ends //

  @override
  void initState() {
    super.initState();
    checkacc();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtchangepsw_appBarTitleWidget(context, 'Change Password'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(
                context,
              );
            }
        ),
      ),
      body: Center(
        child: Container(
          width: jtchangepsw_dynamicWidth(context),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Change Password', style: boldTextStyle(size: 24)),
                  Text('Changing password for account ('+acc+')', style: secondaryTextStyle()),
                  30.height,
                  TextFormField(
                    controller: oldpass,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      contentPadding: EdgeInsets.all(16),
                      labelStyle: secondaryTextStyle(),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (s) {
                      if (s!.trim().isEmpty) {
                        oldstatus = "false";
                        return errorThisFieldRequired;
                      }
                      else{
                        oldstatus = "true";
                        return null;
                      }
                    },
//                    onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(emailFocus),
//                    textInputAction: TextInputAction.next,
                  ),
                  16.height,
                  TextFormField(
                    controller: newpass,
//                    focusNode: emailFocus,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: secondaryTextStyle(),
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (s) {
                      if (s!.isEmpty) {
                        newstatus = "false";
                        return 'Password cannot be empty';
                      }
                      else if (s.length < 8) {
                        newstatus = "false";
                        return 'Must be at least 8 characters long';
                      }
                      else if (s.contains(new RegExp(r'[A-Z]')) == false) {
                        newstatus = "false";
                        return 'Must be at least contain 1 Uppercase Alphabets';
                      }
                      else if (s.contains(new RegExp(r'[a-z]')) == false) {
                        newstatus = "false";
                        return 'Must be at least contain 1 Lowercase Alphabets';
                      }
                      else if (s.contains(new RegExp(r'[0-9]')) == false) {
                        newstatus = "false";
                        return 'Must be at least contain 1 Numbers';
                      }
                      else{
                        newstatus = "true";
                        return null;
                      }
                    },
//                    onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
//                    textInputAction: TextInputAction.next,
                  ),
                  16.height,
                  TextFormField(
                    obscureText: obscureText,
//                    focusNode: passFocus,
                    controller: retype,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Retype Password',
                      contentPadding: EdgeInsets.all(16),
                      labelStyle: secondaryTextStyle(),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      suffix: Icon(!obscureText ? Icons.visibility : Icons.visibility_off).onTap(() {
                        obscureText = !obscureText;
                        setState(() {});
                      }),
                    ),
                    validator: (s) {
                      if (s!.isEmpty) {
                        cfmstatus = "false";
                        return 'Password cannot be empty';
                      }
                      else if(s != newpass.text.toString()) {
                        cfmstatus = "false";
                        return 'Password not matched.';
                      }
                      else{
                        cfmstatus = "true";
                        return null;
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
                    if(oldstatus == "true" && newstatus == "true" && cfmstatus == "true") {
                      checkpass(oldpass.text,newpass.text,retype.text);
                    }
                    else{
                      toast("Your inputs are not meeting our requirements.");
                    }
                  }),
                  20.height,
                ],
              ),
            ),
          ).center(),
        ),
      ),
    );
  }
}
