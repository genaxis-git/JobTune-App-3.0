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

// ignore: must_be_immutable
class BrowseCoDeBooking extends StatefulWidget {
  static String tag = '/CartListView';

  bool? mIsEditable;
  bool? isOrderSummary;

  BrowseCoDeBooking({this.mIsEditable, this.isOrderSummary});

  @override
  BrowseCoDeBookingState createState() => BrowseCoDeBookingState();
}

class BrowseCoDeBookingState extends State<BrowseCoDeBooking> {
  List codebookinglist = [];

  Future<void> getCoDeRequest() async {
    http.Response response = await http.get(
        Uri.parse(server.server + "jtnew_product_selectcodebooking"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      codebookinglist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getCoDeRequest();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: codebookinglist == null ? 0 : codebookinglist.length,
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
                          server.image + codebookinglist[index]["profile_pic"]),
                      // radius: 35,
                    )
                    // child: Image.network(
                    //   server.image + codebookinglist[index]["profile_pic"],
                    //   fit: BoxFit.cover,
                    //   height: 100,
                    //   width: 100,
                    // ).cornerRadiusWithClipRRect(8),
                    ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(codebookinglist[index]["role"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    4.height,
                    Row(
                      children: [
                        Text(
                          '\RM ' + codebookinglist[index]["payment"],
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
                    Text('Provider : ' + codebookinglist[index]["name"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    8.height,
                    Text('Date : ' + codebookinglist[index]["start_date"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    8.height,
                    Text(
                        'Description : ' +
                            codebookinglist[index]["job_description"],
                        style: primaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    8.height,
                    Row(
                      children: [
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
                              codebookinglist[index]["co_de_booking_id"];
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
        Uri.parse(server.server +
            "jtnew_product_updateacceptcodebooking&j_codebookingid=" +
            widget.bookingid +
            "&j_codeid=" +
            jobtuneUser.toString()),
        headers: {"Accept": "application/json"});

    Navigator.pop(context);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => DTCartScreen1()));

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
