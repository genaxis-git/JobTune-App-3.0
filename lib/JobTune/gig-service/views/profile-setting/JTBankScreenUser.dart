import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';

import '../../../../main.dart';
import 'JTProfileSettingWidgetUser.dart';


class JTBankScreenUser extends StatefulWidget {
  @override
  _JTBankScreenUserState createState() => _JTBankScreenUserState();
}

class _JTBankScreenUserState extends State<JTBankScreenUser> {
  List<String> listOfCategory = ['Maybank', 'RHB Bank', 'Bank Islam', 'Ambank', 'Hong Leong', 'CIMB Bank', 'Bank Rakyat'];
  String? selectedIndexCategory = 'CIMB Bank';
  String? dropdownNames;
  String? dropdownScrollable = 'I';
  bool obscureText = true;
  bool autoValidate = false;
  var formKey = GlobalKey<FormState>();

  var accno = TextEditingController();

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
        title: jtprofile_appBarTitleWidget(context, 'Update Banking Info'),
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
                  Text('Banking Info', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      20.height,
                      Container(
                        height: 60,
                        child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), // if you need this
                              side: BorderSide(
                                color: Colors.black.withOpacity(0.6),
                                width: 1,
                              ),
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              dropdownColor: appStore.appBarColor,
                              value: selectedIndexCategory,
                              style: boldTextStyle(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: appStore.iconColor,
                              ),
                              underline: 0.height,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  toast(newValue);
                                  selectedIndexCategory = newValue;
                                });
                              },
                              items: listOfCategory.map((category) {
                                return DropdownMenuItem(
                                  child: Text(category, style: primaryTextStyle()).paddingLeft(8),
                                  value: category,
                                );
                              }).toList(),
                            )),
                      ),
                      16.height,
                      TextFormField(
                        controller: accno,
//                    focusNode: emailFocus,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Account No.',
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
