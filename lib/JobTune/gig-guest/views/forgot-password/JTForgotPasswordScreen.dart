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

import 'JTEnterCode.dart';

class JTForgotPasswordScreen extends StatefulWidget {
  static String tag = '/JTForgotPasswordScreen';

  @override
  _JTForgotPasswordScreenState createState() => _JTForgotPasswordScreenState();
}

class _JTForgotPasswordScreenState extends State<JTForgotPasswordScreen> {
  var emailCont = TextEditingController();
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();
  String emailstatus = "false";

  List profile = [];
  Future<void> sendingCode(email,digit) async {
    http.get(
        Uri.parse(
            server + "jt_mail_forgotpassword&jemail=" + email + "&host=jobtune.ai&nums=" + digit),
        headers: {"Accept": "application/json"}
    );

    showInDialog(context,
        child: AlertForgotPassword(),
        backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
  }

  Future sendEmail({
    required String email,
    required String code,
  } ) async {
    final serviceId = 'service_fdp7v11';
    final templateId = 'template_wntkn36';
    final userId = 'user_h1Lfo3VnB06ve6A2TnW3Q';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id' : templateId,
          'user_id': userId,
          'template_params': {
            'to_name': email.split("@")[0],
            'to_email': email,
            'digits': code,
            'hostname': 'bobdomo.com/jobtuneai/JobTune',
          }
        })
    );

    print('sent');
    print(response.body);

    showInDialog(context,
        child: AlertForgotPassword(),
        backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
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
      appBar: appBar(context, 'Forgot Password'),
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
                    Text('Forgot Password', style: boldTextStyle(size: 24)),
                    Text('To reset your password, enter your email so that we will be able to send you 6 digit code to you.', style: secondaryTextStyle()),
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
                        if (!s.trim().validateEmail()) {
                          emailstatus = "false";
                          return 'Email is invalid';
                        }
                        else {
                          emailstatus = "true";
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    GestureDetector(
                      onTap: () {
                        JTEnterCode().launch(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        alignment: Alignment.topRight,
                        child: Text("I have Confirmation Code", style: boldTextStyle(color: Color(0xFF0A79DF))),
                      ),
                    ),
                    20.height,
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                      child: Text('Send Code', style: boldTextStyle(color: white, size: 18)),
                    ).onTap(() async {
                      var rnd = new Random();
                      var next = rnd.nextDouble() * 1000000;
                      while (next < 100000) {
                        next *= 10;
                      }

                      if(emailstatus == "true"){
                        // sendingCode(emailCont.text,next.toInt().toString());
                        sendEmail(
                          email: emailCont.text,
                          code: next.toInt().toString(),
                        );
                      }
                      else{
                        toast("Key-in your email first.");
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

class AlertForgotPassword extends StatefulWidget {
  @override
  _AlertForgotPasswordState createState() => _AlertForgotPasswordState();
}

class _AlertForgotPasswordState extends State<AlertForgotPassword> {
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
                        "Reset Password Begin..",
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
                          "We sent you an email. Please check your inbox and follow the instruction as has been advised.",
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
                            builder: (context) => JTEnterCode()),
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