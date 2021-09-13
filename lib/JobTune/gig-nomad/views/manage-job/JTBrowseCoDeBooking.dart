import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/resume/JTResumeScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:prokit_flutter/JobTune/constructor/server.dart';

import '../../../../main.dart';


class JTJobAlertScreen extends StatefulWidget {
  static String tag = '/CartListView';

  bool? mIsEditable;
  bool? isOrderSummary;

  JTJobAlertScreen({this.mIsEditable, this.isOrderSummary});

  @override
  JTJobAlertScreenState createState() => JTJobAlertScreenState();
}

class JTJobAlertScreenState extends State<JTJobAlertScreen> {

  List alertlist = [];
  Future<void> readAlert() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('employerID').toString();
    http.Response response = await http.get(
        Uri.parse(dev + "jtnew_employer_selectjobalert&id="+lgid),
        headers: {"Accept": "application/json"});

    this.setState(() {
      alertlist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    this.readAlert();
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: alertlist == null ? 0 : alertlist.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: boxDecorationRoundedWithShadow(8,
                backgroundColor: appStore.appBarColor!),
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 80,
                    width: 80,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          imagedev + alertlist[index]["profile_pic"]),
                      // radius: 35,
                    )
                    ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(alertlist[index]["job_type"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    4.height,
                    Row(
                      children: [
                        Text(
                          alertlist[index]["job_name"],
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: appStore.textPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    Text('Applicant : ' + alertlist[index]["first_name"] + " " + alertlist[index]["last_name"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    8.height,
                    Text('Specialize : ' + alertlist[index]["category"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    8.height,
                    Row(
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.circular(4),
                            backgroundColor: appDark_parrot_green,
                          ),
                          padding: EdgeInsets.all(6.5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              6.width,
                              Text('View',
                                  style: boldTextStyle(color: whiteColor)),
                              6.width,
                            ],
                          ),
                        ).onTap(() async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => JTResumeScreen(
                              id: alertlist[index]["employee_id"],
                            )),
                          );
                        }),
                        10.width,
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.circular(4),
                            backgroundColor: appColorPrimaryDark,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon(Icons.remove, color: whiteColor).onTap(() {
                              //   var qty = data.qty!;
                              //   if (qty <= 1) return;
                              //   var q = qty - 1;
                              //   data.qty = q;

                              //   calculate();
                              // }),
                              6.width,
                              Text('Accept',
                                  style: boldTextStyle(color: whiteColor)),
                              6.width,
                              Icon(Icons.check_rounded, color: whiteColor)
                                  .onTap(() {}),
                            ],
                          ),
                        ).onTap(() async {
                          var bookingid =
                              alertlist[index]["co_de_booking_id"];
                          showInDialog(context,
                              child: AcceptRequestDialog(bookingid: bookingid),
                              backgroundColor: Colors.transparent,
                              contentPadding: EdgeInsets.all(0));

                          // if (model != null) {
                          //   list.add(model);

                          //   setState(() {});
                          // }
                        }),
                      ],
                    ),
                  ],
                ).expand(),
              ],
            ),
          );
        });
  }
}

class UpdateStatusDialog extends StatefulWidget {
  @override
  _UpdateStatusDialogState createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  List<String> listOfCategory = [
    'Pending',
    'Shipped',
  ];
  String? selectedIndexCategory = 'Pending';
  String? dropdownNames;
  String? dropdownScrollable = 'I';

  var nameCont = TextEditingController();
  var addressLine1Cont = TextEditingController();
  var addressLine2Cont = TextEditingController();
  var typeCont = TextEditingController();
  var mobileCont = TextEditingController();

  var addressLine1Focus = FocusNode();
  var addressLine2Focus = FocusNode();
  var typeFocus = FocusNode();
  var mobileFocus = FocusNode();
  var autoValidate = false;
  var formKey = GlobalKey<FormState>();

  validate() {
    if (formKey.currentState!.validate()) {
      hideKeyboard(context);
      toast('Adding Successfully');
      formKey.currentState!.save();

      var addressData = DTAddressListModel();
      addressData.name = nameCont.text.validate();
      addressData.addressLine1 = addressLine1Cont.text.validate();
      addressData.addressLine2 = addressLine2Cont.text.validate();
      addressData.phoneNo = mobileCont.text.validate();
      addressData.type = 'Office';

      finish(context, addressData);
    } else {
      autoValidate = true;
    }
    setState(() {});
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
                    Text('Update Status', style: boldTextStyle(size: 18)),
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
                    validate();
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

class AcceptRequestDialog extends StatefulWidget {
  var bookingid;

  AcceptRequestDialog({this.bookingid});

  @override
  _AcceptRequestDialogState createState() => _AcceptRequestDialogState();
}

class _AcceptRequestDialogState extends State<AcceptRequestDialog> {
  var autoValidate = false;
  var formKey = GlobalKey<FormState>();

  Future<void> acceptRequest() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email');
    // final jobtuneUser = "shahirah0397@gmail.com";

    http.get(
        Uri.parse(server +
            "jtnew_product_updateacceptcodebooking&j_codebookingid=" +
            widget.bookingid +
            "&j_codeid=" +
            jobtuneUser.toString()),
        headers: {"Accept": "application/json"});

    Navigator.pop(context);

    toast("Request accepted successfully");
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
                    Text('Accept Request', style: boldTextStyle(size: 18)),
                    IconButton(
                      icon: Icon(Icons.close, color: appStore.iconColor),
                      onPressed: () {
                        finish(context);
                      },
                    )
                  ],
                ),
                Text('Are you sure you want to accept this Co-De request?'),
                16.height,
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            acceptRequest();
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: appColorPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Center(
                              child: Text("Yes",
                                  style: boldTextStyle(color: white)),
                            ),
                          ),
                        )),
                    8.width,
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: redColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child:
                                Text("No", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    )
                  ],
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