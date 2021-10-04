import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:prokit_flutter/JobTune/constructor/server.dart' as server;

import '../../../../main.dart';
import 'JTCoDeBookingScreen.dart';
// import 'DTProductDetailScreen.dart';

class JTCoDeVerify extends StatefulWidget {
  var codebookingid;

  JTCoDeVerify({this.codebookingid});

  @override
  _JTCoDeVerifyState createState() => _JTCoDeVerifyState();
}

class _JTCoDeVerifyState extends State<JTCoDeVerify> {
  List<String> listOfCategory = [
    'Pending',
    'Completed',
  ];
  String? selectedIndexCategory = 'Pending';
  String? dropdownNames;
  String? dropdownScrollable = 'I';

  var autoValidate = false;
  var formKey = GlobalKey<FormState>();

  Future<void> completeRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email');
    // final jobtuneUser = "shahirah0397@gmail.com";

    if (selectedIndexCategory == "Pending") {
      Navigator.pop(context);
    } else {
      http.get(
          Uri.parse(server.server +
              "jtnew_product_updatecodebookingverified&j_codebookingid=" +
              widget.codebookingid),
          headers: {"Accept": "application/json"});

      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => JTCoDeProduct()));

      toast("Your work will be verified soon");
    }
  }

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
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Verify Status', style: boldTextStyle(size: 18)),
                    IconButton(
                      icon: Icon(Icons.close, color: appStore.iconColor),
                      onPressed: () {
                        finish(context);
                      },
                    )
                  ],
                ),
                8.height,
                DropdownButtonFormField(
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    // labelText: 'Co-De',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  isExpanded: true,
                  dropdownColor: appStore.appBarColor,
                  value: selectedIndexCategory,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: appStore.iconColor,
                  ),
                  onChanged: (dynamic newValue) {
                    setState(() {
                      toast(newValue);
                      selectedIndexCategory = newValue;
                    });
                  },
                  items: listOfCategory.map((category) {
                    return DropdownMenuItem(
                      child: Text(category, style: primaryTextStyle())
                          .paddingLeft(8),
                      value: category,
                    );
                  }).toList(),
                ),
                16.height,
                GestureDetector(
                  onTap: () {
                    completeRequest();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: appColorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Center(
                      child: Text("Submit", style: boldTextStyle(color: white)),
                    ),
                  ),
                ),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
