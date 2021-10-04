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
class AcceptedCoDeBooking extends StatefulWidget {
  static String tag = '/CartListView';

  bool? mIsEditable;
  bool? isOrderSummary;

  AcceptedCoDeBooking({this.mIsEditable, this.isOrderSummary});

  @override
  AcceptedCoDeBookingState createState() => AcceptedCoDeBookingState();
}

class AcceptedCoDeBookingState extends State<AcceptedCoDeBooking> {
  List codebookinglist = [];

  Future<void> getCoDeAccepted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(server.server +
            "jtnew_product_selectcodebookingaccepted&j_providerid=" +
            jobtuneUser),
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
    getCoDeAccepted();
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
                  ),
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
                            backgroundColor:
                                (codebookinglist[index]["status"] == "verified")
                                    ? Colors.lightGreen
                                    : appColorPrimaryDark,
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
                              (codebookinglist[index]["status"] == "verified")
                                  ? Text('Verified',
                                      style: boldTextStyle(color: whiteColor))
                                  : (codebookinglist[index]["status"] ==
                                          "completed")
                                      ? Text('Completed',
                                          style:
                                              boldTextStyle(color: whiteColor))
                                      : Text('Pending',
                                          style:
                                              boldTextStyle(color: whiteColor)),
                              6.width,
                              (codebookinglist[index]["status"] == "accepted")
                                  ? Icon(Icons.edit_outlined, color: whiteColor)
                                  : Icon(Icons.check_rounded,
                                      color: whiteColor),
                            ],
                          ),
                        ).onTap((codebookinglist[index]["status"] == "verified")
                            ? () async {}
                            : (codebookinglist[index]["status"] == "completed")
                                ? () async {}
                                : () async {
                                    var bookingid = codebookinglist[index]
                                        ["co_de_booking_id"];
                                    showInDialog(context,
                                        child: UpdateStatusDialog(
                                            bookingid: bookingid),
                                        backgroundColor: Colors.transparent,
                                        contentPadding: EdgeInsets.all(0));
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
  var bookingid;

  UpdateStatusDialog({this.bookingid});

  @override
  _UpdateStatusDialogState createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
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
              "jtnew_product_updatecodebookingcompleted&j_codebookingid=" +
              widget.bookingid),
          headers: {"Accept": "application/json"});

      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => DTCartScreen1()));

      toast("Co-De verified successfully");
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
