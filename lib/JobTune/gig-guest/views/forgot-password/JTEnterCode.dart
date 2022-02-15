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

import 'JTResetPasswordScreen.dart';

class JTEnterCode extends StatefulWidget {
  static String tag = '/JTEnterCode';

  @override
  _JTEnterCodeState createState() => _JTEnterCodeState();
}

class _JTEnterCodeState extends State<JTEnterCode> {
  var emailCont = TextEditingController();
  var codes = TextEditingController();
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();
  String emailstatus = "false";
  String codestatus = "false";

  List user = [];

  Future<void> checkCode(email,pass) async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_selectlogins&lgid=" + email),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      user = json.decode(response.body);
    });
    
    if(user.length > 0){
      if(user[0]["password"].split("").length == 6){
        if(user[0]["password"] == pass){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => JTResetPasswordScreen(id: email)
            ),
          );
        }
        else{
          toast("Wrong code. Please try again.");
        }
      }
      else{
        showInDialog(context,
            child: AlertNoRequest(),
            backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
      }
    }
    else{
      showInDialog(context,
          child: AlertNotRegistered(),
          backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
    }
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
      appBar: appBar(context, 'Confirmation Code'),
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
                    Text('Confirmation Code', style: boldTextStyle(size: 24)),
                    Text('Key-in your email and the 6 digits that you received.', style: secondaryTextStyle()),
                    30.height,
                    TextFormField(
                      controller: emailCont,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (s) {
                        if (s!.trim().isEmpty) {
                          emailstatus = "false";
                          return errorThisFieldRequired;
                        }
                        else {
                          emailstatus = "true";
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    12.height,
                    TextFormField(
                      controller: codes,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: '6-digit code',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (s) {
                        if (s!.trim().isEmpty) {
                          codestatus = "false";
                          return errorThisFieldRequired;
                        }
                        else {
                          codestatus = "true";
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
                      child: Text('Go', style: boldTextStyle(color: white, size: 18)),
                    ).onTap(() async {
                      if(emailstatus == "true" && codestatus == "true"){
                        checkCode(emailCont.text,codes.text);
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

class AlertNoRequest extends StatefulWidget {
  @override
  _AlertNoRequestState createState() => _AlertNoRequestState();
}

class _AlertNoRequestState extends State<AlertNoRequest> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: dynamicBoxConstraints(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: appStore.iconColor),
                    onPressed: () {
                      finish(context);
                    },
                  )
                ],
              ),
              10.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Opss..",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Your password reset request is not on our records. This field is only for users who have already made a password reset request.",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  20.height,
                  GestureDetector(
                    onTap: () {
                      finish(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JTSignInScreen()),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Center(
                        child: Text("Okay", style: boldTextStyle(color: white)),
                      ),
                    ),
                  ),
                ],
              ),
              7.height,
            ],
          ),
        ),
      ),
    );
  }
}
