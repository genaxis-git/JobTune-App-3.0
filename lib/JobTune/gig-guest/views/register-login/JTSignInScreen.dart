import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTReviewWidget.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/forgot-password/JTForgotPasswordScreen.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/onboarding/JTWalkThroughScreenGuest.dart';
import '../../../../main.dart';
import 'JTSignUpScreen.dart';


class JTSignInScreen extends StatefulWidget {
  static String tag = '/JTSignInScreen';

  @override
  _JTSignInScreenState createState() => _JTSignInScreenState();
}

class _JTSignInScreenState extends State<JTSignInScreen> {
  var formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool autoValidate = false;

  var emailCont = TextEditingController();
  var passCont = TextEditingController();

  var passFocus = FocusNode();

  // functions starts //

  List user = [];
  double newcount = 0.0;
  double newprovider = 0.0;
  Future<void> readLogin(email, pass) async{
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_selectlogins&lgid=" + email),
        headers: {"Accept": "application/json"});

    this.setState(() {
      user = json.decode(response.body);
    });

    if(user.length > 0) {
      if(user[0]["password"] == pass) {
        if(user[0]["status"] == "confirmed") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          final String lgcount = prefs.getString('logincount').toString();
          final String lgprovider = prefs.getString('loginprovider').toString();
          if(lgcount == "null") {
            newcount = 1.0;
          }
          else {
            newcount = double.parse(lgcount) + 1;
          }

          if(lgprovider == "null") {
            newprovider = 1.0;
          }
          else {
            newprovider = double.parse(lgcount) + 1;
          }

          prefs.setString('logincount', newcount.toString());
          prefs.setString('loginprovider', newprovider.toString());
          prefs.setString('email', email);

          if(newcount > 1) {
            JTDashboardScreenGuest().launch(context, isNewTask: true);
          }
          else {
            JTWalkThroughScreenGuest().launch(context, isNewTask: true);
          }
        }
        else {
          // alert: not confirmed yet
        }
      }
      else {
        // alert: wrong password
      }
    }
    else {
      // alert: not available
      JTSignUpScreen().launch(context, isNewTask: true);
    }
  }

  // functions ends //

  @override
  void initState() {
    super.initState();
    init();
  }

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: JTappBarTitleWidget(context, 'Sign In'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JTDashboardScreenGuest()),
              );
            }),
      ),
      body: Center(
        child: Container(
          width: JTdynamicWidth(context),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Sign In', style: boldTextStyle(size: 24)),
                  30.height,
                  TextFormField(
                    controller: emailCont,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets.all(16),
                      labelStyle: secondaryTextStyle(),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (s) {
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      if (!s.trim().validateEmail()) return 'Email is invalid';
                      return null;
                    },
                    onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
                    textInputAction: TextInputAction.next,
                  ),
                  16.height,
                  TextFormField(
                    obscureText: obscureText,
                    focusNode: passFocus,
                    controller: passCont,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      return null;
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      JTForgotPasswordScreen().launch(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      alignment: Alignment.topRight,
                      child: Text("Forgot Password?", style: boldTextStyle(color: Color(0xFF0A79DF))),
                    ),
                  ),
                  16.height,
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                    child: Text('Sign In', style: boldTextStyle(color: white, size: 18)),
                  ).onTap(() {
                    readLogin(emailCont.text, passCont.text);
                  }),
                  10.height,
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                    child: Text('Sign Up', style: boldTextStyle(color: white, size: 18)),
                  ).onTap(() {
                    JTSignUpScreen().launch(context);
                  }),
                ],
              ),
            ),
          ).center(),
        ),
      ),
    );
  }
}
