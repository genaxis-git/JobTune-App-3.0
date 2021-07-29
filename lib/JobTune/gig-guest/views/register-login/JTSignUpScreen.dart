import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTReviewWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import 'JTSignInScreen.dart';



class JTSignUpScreen extends StatefulWidget {
  static String tag = '/JTSignUpScreen';

  @override
  _JTSignUpScreenState createState() => _JTSignUpScreenState();
}

class _JTSignUpScreenState extends State<JTSignUpScreen> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var emailCont = TextEditingController();
  var passCont = TextEditingController();
  var confirmCont = TextEditingController();

  var emailFocus = FocusNode();
  var passFocus = FocusNode();

  // functions starts //

  List user = [];

  Future<void> checkregister(email, pass) async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_selectlogins&lgid=" + email),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      user = json.decode(response.body);
    });

    print(user.length);

    if(user.length == 0){
      smtp(email, pass);
    }
    else if(user.length > 0){
      // alert: have register
    }
  }

  Future<void> smtp(email, pass) async{
    http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jt_mail&jemail=" + email + "&host=jobtune-dev.my1.cloudapp.myiacloud.com"),
        headers: {"Accept": "application/json"}
    );

    register(email, pass);
  }

  Future<void> register(email, pass) async {
    http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_signups&jemail=" + email + '&jpassword=' + pass),
        headers: {"Accept": "application/json"}
    );

    http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_insertprofile&jemail=" + email),
        headers: {"Accept": "application/json"}
    );

    http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_insertprofile&jemail=" + email),
        headers: {"Accept": "application/json"}
    );

    // alert: register success
    JTSignInScreen().launch(context, isNewTask: true);
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
                  Text('Sign Up', style: boldTextStyle(size: 24)),
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
                  16.height,
                  TextFormField(
                    obscureText: obscureText,
                    focusNode: passFocus,
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
                    validator: (s) {
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      return null;
                    },
                  ),
                  20.height,
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                    child: Text('Sign Up', style: boldTextStyle(color: white, size: 18)),
                  ).onTap(() {
                    checkregister(emailCont.text,confirmCont.text);
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
