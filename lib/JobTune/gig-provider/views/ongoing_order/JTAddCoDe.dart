import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart' as server;

import '../../../../main.dart';

class AddCoDeDialog extends StatefulWidget {
  final String productbookingid;

  const AddCoDeDialog({
    Key? key,
    required this.productbookingid,
  });

  @override
  _AddCoDeDialogState createState() => _AddCoDeDialogState();
}

class _AddCoDeDialogState extends State<AddCoDeDialog> {
  List<String> listCoDeCategory = [
    'Co-De',
    'Rider',
    'Helper',
    'Runner',
  ];

  String? selectedIndexCategory = 'Co-De';
  String? dropdownNames;
  String? dropdownScrollable = 'I';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  var paymentField = TextEditingController();
  var descField = TextEditingController();
  var autoValidate = false;
  var formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        helpText: 'Date',
        cancelText: 'Not Now',
        confirmText: "Book",
        fieldLabelText: 'Booking Date',
        fieldHintText: 'Month/Date/Year',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter date in valid range',
        context: context,
        builder: (BuildContext context, Widget? child) {
          return CustomTheme(
            child: child,
          );
        },
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        print(picked);
        selectedDate = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget? child) {
          return CustomTheme(
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            ),
          );
        });

    if (picked != null)
      setState(() {
        selectedTime = picked;
      });
  }

  Future<void> getInput() async {
    var paymentData = paymentField.text;
    var descData = descField.text;
    var dateData = "${selectedDate.toLocal()}".split(' ')[0];
    var timeData =
        "${selectedTime.hour < 10 ? "0${selectedTime.hour}" : "${selectedTime.hour}"}:${selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}"}:00";
    var dateTimeData = dateData + " " + timeData;
    var bookingid = widget.productbookingid;

    addCoDe(bookingid, paymentData, dateTimeData, descData);
  }

  Future<void> addCoDe(bookingid, paymentData, dateTimeData, descData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jobtuneUser = prefs.getString('email');

    http.get(
        Uri.parse(server.server +
            "jtnew_product_insertcodebooking&j_productbookingid=" +
            bookingid +
            "&j_providerid=" +
            jobtuneUser.toString() +
            "&j_role=" +
            selectedIndexCategory.toString() +
            "&j_startdate=" +
            dateTimeData +
            "&j_desc=" +
            Uri.encodeComponent(descData) +
            "&j_payment=" +
            paymentData),
        headers: {"Accept": "application/json"});

    Navigator.pop(context);
    toast("Co-De added successfully");
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
                    Text('Add Co-De', style: boldTextStyle(size: 18)),
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
                  items: listCoDeCategory.map((category) {
                    return DropdownMenuItem(
                      child: Text(category, style: primaryTextStyle())
                          .paddingLeft(8),
                      value: category,
                    );
                  }).toList(),
                ),
                8.height,
                TextFormField(
                  controller: paymentField,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Payment',
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
                  keyboardType: TextInputType.numberWithOptions(),
                  // validator: (s) {
                  //   if (s!.trim().isEmpty) return errorThisFieldRequired;
                  //   if (!s.trim().validatePhone()) return 'Mobile is invalid';
                  //   return null;
                  // },
                  // onFieldSubmitted: (s) =>
                  //     FocusScope.of(context).requestFocus(addressLine1Focus),
                  textInputAction: TextInputAction.next,
                ),
                8.height,
                Row(
                  children: [
                    Expanded(
                      child: Card(
                          elevation: 4,
                          child: ListTile(
                            onTap: () {
                              _selectDate(context);
                            },
                            title: Text(
                              'Date',
                              style: primaryTextStyle(),
                            ),
                            subtitle: Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: secondaryTextStyle(),
                            ),
                            // trailing: IconButton(
                            //   icon: Icon(
                            //     Icons.date_range,
                            //     color: appStore.iconColor,
                            //   ),
                            //   onPressed: () {
                            //     _selectDate(context);
                            //   },
                            // ),
                          )),
                    ),
                    Expanded(
                      child: Card(
                          elevation: 4,
                          child: ListTile(
                            onTap: () {
                              _selectTime(context);
                            },
                            title: Text(
                              'Time',
                              style: primaryTextStyle(),
                            ),
                            subtitle: Text(
                              "${selectedTime.hour < 10 ? "0${selectedTime.hour}" : "${selectedTime.hour}"} : ${selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}"} ${selectedTime.period != DayPeriod.am ? 'PM' : 'AM'}   ",
                              style: secondaryTextStyle(),
                            ),
                            // trailing: IconButton(
                            //   icon: Icon(
                            //     Icons.date_range,
                            //     color: appStore.iconColor,
                            //   ),
                            //   onPressed: () {
                            //     _selectTime(context);
                            //   },
                            // ),
                          )),
                    ),
                  ],
                ),
                8.height,
                TextFormField(
                  controller: descField,
                  maxLines: 5,
                  minLines: 3,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Description',
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
                  // keyboardType: TextInputType.numberWithOptions(),
                  // validator: (s) {
                  //   if (s!.trim().isEmpty) return errorThisFieldRequired;
                  //   if (!s.trim().validatePhone()) return 'Mobile is invalid';
                  //   return null;
                  // },
                  // onFieldSubmitted: (s) =>
                  //     FocusScope.of(context).requestFocus(addressLine1Focus),
                  textInputAction: TextInputAction.done,
                ),
                16.height,
                GestureDetector(
                  onTap: () {
                    getInput();
                    // validate();
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
