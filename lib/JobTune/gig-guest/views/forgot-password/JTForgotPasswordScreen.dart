import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sms_maintained/contact.dart';
import 'package:sms_maintained/generated/i18n.dart';
import 'package:sms_maintained/globals.dart';
import 'package:sms_maintained/sms.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'DTDrawerWidget.dart';

class JTForgotPasswordScreen extends StatefulWidget {
  static String tag = '/JTForgotPasswordScreen';

  @override
  _JTForgotPasswordScreenState createState() => _JTForgotPasswordScreenState();
}

class _JTForgotPasswordScreenState extends State<JTForgotPasswordScreen> {
  var emailCont = TextEditingController();
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  void generatenum() {

  }

  List profile = [];
  Future<void> sendingSMS(email,telno,digit) async {
    http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_changepassword&jUname=" + email + "&jNew=" + digit),
        headers: {"Accept": "application/json"}
    );

    SmsSender sender = SmsSender();
    String address = "0163929098";

    SmsMessage message = SmsMessage(address, "Here are 6 digits "+digit+" you may use to Log in to JobTune.");
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);

    toast("We sent you 6 digits to login. Please check your inbox.");
  }

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
                    Text('Password Reset', style: boldTextStyle(size: 24)),
                    Text('To reset your password, enter your email to get reset link.', style: secondaryTextStyle()),
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
                        if (s!.trim().isEmpty) return errorThisFieldRequired;
                        if (!s.trim().validateEmail()) return 'Email is invalid';
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    20.height,
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                      child: Text('Send', style: boldTextStyle(color: white, size: 18)),
                    ).onTap(() async {
                      http.Response response = await http.get(
                          Uri.parse(
                              "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selectprofile&lgid=" + emailCont.text),
                          headers: {"Accept": "application/json"}
                      );

                      this.setState(() {
                        profile = json.decode(response.body);
                      });

                      var rnd = new Random();
                      var next = rnd.nextDouble() * 1000000;
                      while (next < 100000) {
                        next *= 10;
                      }
                      sendingSMS(emailCont.text,profile[0]["phone_no"],next.toInt().toString());
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
