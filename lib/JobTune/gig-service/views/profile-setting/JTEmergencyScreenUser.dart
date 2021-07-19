import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';

import '../../../../main.dart';
import 'JTProfileSettingWidgetUser.dart';


class JTEmergencyScreenUser extends StatefulWidget {
  @override
  _JTEmergencyScreenUserState createState() => _JTEmergencyScreenUserState();
}

class _JTEmergencyScreenUserState extends State<JTEmergencyScreenUser> {
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var names = TextEditingController();
  var telnos = TextEditingController();

//  var emailFocus = FocusNode();
//  var passFocus = FocusNode();

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
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, 'Update Emergency Contact'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTProfileScreenUser()),
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
                        validator: (s) {
                          if (s!.trim().isEmpty) return errorThisFieldRequired;
                          return null;
                        },
//                    onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(emailFocus),
//                    textInputAction: TextInputAction.next,
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
                        keyboardType: TextInputType.emailAddress,
                        validator: (s) {
                          if (s!.trim().isEmpty) return errorThisFieldRequired;
                          return null;
                        },
//                    onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(passFocus),
//                    textInputAction: TextInputAction.next,
                      ),
                      40.height,
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                        child: Text('Update', style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() {
                        finish(context);

                        /// Remove comment if you want enable validation
                        /* if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        finish(context);
                      } else {
                        autoValidate = true;
                      }
                      setState(() {});*/
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
