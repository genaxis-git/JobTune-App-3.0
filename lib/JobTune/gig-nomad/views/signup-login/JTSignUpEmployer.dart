import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTReviewWidget.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import 'JTSignInEmployer.dart';



class JTSignUpScreenEmployer extends StatefulWidget {
  static String tag = '/JTSignUpScreenEmployer';

  @override
  _JTSignUpScreenEmployerState createState() => _JTSignUpScreenEmployerState();
}

class _JTSignUpScreenEmployerState extends State<JTSignUpScreenEmployer> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var emailCont = TextEditingController();
  var passCont = TextEditingController();
  var confirmCont = TextEditingController();

  bool _isSelected_agree = false;
  String emailstatus = "false";
  String passwordstatus = "false";
  String matchedstatus = "false";

  var emailFocus = FocusNode();
  var passFocus = FocusNode();

  // functions starts //

  List user = [];

  Future<void> checkregister(email, pass) async {
    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_selectlogins&lgid=" + email),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      user = json.decode(response.body);
    });

    if(user.length == 0){
      smtp(email, pass);
    }
    else if(user.length > 0){
      showInDialog(context,
          child: AlertRegisteredBefore(date: user[0]["login_date"]),
          backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
    }
  }

  Future<void> smtp(email, pass) async{
    http.get(
        Uri.parse(
            dev + "jt_mail&jemail=" + email + "&host=jobtune-dev.my1.cloudapp.myiacloud.com"),
        headers: {"Accept": "application/json"}
    );

    register(email, pass);
  }

  Future<void> register(email, pass) async {
    toast("Sign Up succeed!");

    http.get(
        Uri.parse(
            dev + "jtnew_signups&jemail=" + email + '&jpassword=' + pass),
        headers: {"Accept": "application/json"}
    );

    http.get(
        Uri.parse(
            dev + "jtnew_employer_insertprofile&jemail=" + email),
        headers: {"Accept": "application/json"}
    );

    JTSignInScreenEmployer().launch(context, isNewTask: true);
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
      appBar: JTappBar(context, 'Sign Up'),
//      drawer: DTDrawerWidget(),
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
                  Text('Sign Up As Hirer Now!', style: boldTextStyle(size: 24)),
                  30.height,
                  TextFormField(
                    controller: emailCont,
                    focusNode: emailFocus,
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
                    validator: (s) {
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      if (!s.trim().validateEmail()) {
                        emailstatus = "false";
                        return 'Email is invalid';
                      }
                      else{
                        emailstatus = "true";
                        return null;
                      }
                    },
                    onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
                    textInputAction: TextInputAction.next,
                  ),
                  16.height,
                  TextFormField(
                    obscureText: obscureText,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        passwordstatus = "false";
                        return 'Password cannot be empty';
                      }
                      else if (value.length < 8) {
                        passwordstatus = "false";
                        return 'Must be at least 8 characters long';
                      }
                      else if (value.contains(new RegExp(r'[A-Z]')) == false) {
                        passwordstatus = "false";
                        return 'Must be at least contain 1 Uppercase Alphabets';
                      }
                      else if (value.contains(new RegExp(r'[a-z]')) == false) {
                        passwordstatus = "false";
                        return 'Must be at least contain 1 Lowercase Alphabets';
                      }
                      else if (value.contains(new RegExp(r'[0-9]')) == false) {
                        passwordstatus = "false";
                        return 'Must be at least contain 1 Numbers';
                      }
                      else{
                        passwordstatus = "true";
                        return null;
                      }
                    },
                  ),
                  16.height,
                  TextFormField(
                    obscureText: obscureText,
                    controller: confirmCont,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
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
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        matchedstatus = "false";
                        return 'Password cannot be empty';
                      }
                      else if(value != passCont.text.toString()) {
                        matchedstatus = "false";
                        return 'Password not matched.';
                      }
                      else{
                        matchedstatus = "true";
                        return null;
                      }
                    },
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
                                "I have read and agree to the ",
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                    "Terms & Conditions",
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue
                                    )),
                                // onTap: () => Navigator.of(context).push(
                                //   new MaterialPageRoute(
                                //     builder: (context) => TermScreen(),
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "and the ",
                                style: TextStyle(
                                    fontSize: 15
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                    "Privacy Policy.",
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue
                                    )),
                                // onTap: () => Navigator.of(context).push(
                                //   new MaterialPageRoute(
                                //     builder: (context) => PrivacyPolicy(),
                                //   ),
                                // ),
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
                  20.height,
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                    child: Text('Sign Up', style: boldTextStyle(color: white, size: 18)),
                  ).onTap(() {
                    if(_isSelected_agree == true){
                      if(emailstatus == "true" && passwordstatus == "true" && matchedstatus == "true") {
                        checkregister(emailCont.text,confirmCont.text);
                      }
                      else{
                        toast("Your inputs are not meeting our requirements.");
                      }
                    }
                    else{
                      showInDialog(context,
                          child: AlertAgree(),
                          backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
                    }
                  }),
                  20.height,
                  Text('Already Registered?', style: boldTextStyle(color: Color(0xFF0A79DF))).center().onTap(() {
                    finish(context);
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

class AlertAgree extends StatefulWidget {
  @override
  _AlertAgreeState createState() => _AlertAgreeState();
}

class _AlertAgreeState extends State<AlertAgree> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.network(
                      "https://jobtune.ai/gig/JobTune/assets/mobile/termscond.jpg",
                      width: context.width() * 0.70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              10.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "You need to check in the box to indicate you have read and agree to the Terms & Conditions and Privacy Policy attached on this Sign Up form.",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  20.height,
                  GestureDetector(
                    onTap: () {
                      finish(context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Center(
                        child: Text("Okay", style: boldTextStyle(color: white)),
                      ),
                    ),
                  ),
                ],
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}

class AlertRegisteredBefore extends StatefulWidget {
  const AlertRegisteredBefore({Key? key, required this.date}) : super(key: key);
  final String date;
  @override
  _AlertRegisteredBeforeState createState() => _AlertRegisteredBeforeState();
}

class _AlertRegisteredBeforeState extends State<AlertRegisteredBefore> {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.network(
                      "https://jobtune.ai/gig/JobTune/assets/mobile/database.jpg",
                      width: context.width() * 0.70,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                          "It seems that you have registered with the same email before. \n\n(Registered at: "+widget.date+")",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          finish(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Change", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                      5.width,
                      GestureDetector(
                        onTap: () {
                          finish(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JTSignInScreenEmployer()),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Log In", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    ],
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