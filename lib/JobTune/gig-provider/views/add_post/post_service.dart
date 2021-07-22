import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import '../ongoing_order/JTOrderScreen.dart';
import '../co_de_booking/JTCoDeBookingScreen.dart';

class PostService extends StatefulWidget {
  @override
  _PostServiceState createState() => _PostServiceState();
}

class _PostServiceState extends State<PostService> {
  var formKey = GlobalKey<FormState>();

  List<String> listOfCategory = [
    'Category',
    'It',
    'Computer Science',
    'Business',
    'Data Science',
    'Infromation Technologies',
    'Health',
    'Physics'
  ];

  String? selectedIndexCategory = 'Category';

  List<String> rateBy = [
    'Rate By',
    'Hour',
    'Package',
  ];

  String? selectedRateBy = 'Rate By';

  TimeOfDay selectedTime = TimeOfDay.now();

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

  bool? isChecked1 = false;
  bool? isChecked2 = false;
  bool? isChecked3 = false;
  bool? isChecked4 = false;
  bool? isChecked5 = false;
  bool? isChecked6 = false;
  bool? isChecked7 = false;
  bool? isChecked8 = false;
  bool isChecked9 = false;
  bool? isChecked10 = false;
  bool? isChecked11 = false;
  bool? isChecked12 = false;

  Widget availabilityLabel() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'M',
          style: primaryTextStyle(),
        ),
        Text(
          'T',
          style: primaryTextStyle(),
        ),
        Text(
          'W',
          style: primaryTextStyle(),
        ),
        Text(
          'T',
          style: primaryTextStyle(),
        ),
        Text(
          'F',
          style: primaryTextStyle(),
        ),
        Text(
          'S',
          style: primaryTextStyle(),
        ),
        Text(
          'S',
          style: primaryTextStyle(),
        ),
      ],
    );
  }

  Widget availabilityDay() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked1,
            onChanged: (bool? value) {
              setState(() {
                isChecked1 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked2,
            onChanged: (bool? value) {
              setState(() {
                isChecked2 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked3,
            onChanged: (bool? value) {
              setState(() {
                isChecked3 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked4,
            onChanged: (bool? value) {
              setState(() {
                isChecked4 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked5,
            onChanged: (bool? value) {
              setState(() {
                isChecked5 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked6,
            onChanged: (bool? value) {
              setState(() {
                isChecked6 = value;
              });
            },
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: appStore.textPrimaryColor,
          ),
          child: Checkbox(
            activeColor: appColorPrimary,
            value: isChecked7,
            onChanged: (bool? value) {
              setState(() {
                isChecked7 = value;
              });
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              TextFormField(
                // controller: mobileCont,
                // focusNode: mobileFocus,
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  labelText: 'Title',
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
                textInputAction: TextInputAction.next,
              ),
              8.height,
              DropdownButtonFormField(
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  // labelText: 'Co-De',
                  contentPadding: EdgeInsets.fromLTRB(8, 16, 16, 16),
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
              8.height,
              TextFormField(
                // controller: mobileCont,
                // focusNode: mobileFocus,
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
                textInputAction: TextInputAction.next,
              ),
              8.height,
              TextFormField(
                // controller: mobileCont,
                // focusNode: mobileFocus,
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  labelText: 'Preferred Location',
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
                // keyboardType: TextInputType.text(),
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
                    child: DropdownButtonFormField(
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        // labelText: 'Co-De',
                        contentPadding: EdgeInsets.fromLTRB(8, 16, 16, 16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: appColorPrimary)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: appStore.textSecondaryColor!)),
                      ),
                      isExpanded: true,
                      dropdownColor: appStore.appBarColor,
                      value: selectedRateBy,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: appStore.iconColor,
                      ),
                      onChanged: (dynamic newValue) {
                        setState(() {
                          toast(newValue);
                          selectedRateBy = newValue;
                        });
                      },
                      items: rateBy.map((rateby) {
                        return DropdownMenuItem(
                          child: Text(rateby, style: primaryTextStyle())
                              .paddingLeft(8),
                          value: rateby,
                        );
                      }).toList(),
                    ),
                  ),
                  8.width,
                  Expanded(
                    child: TextFormField(
                      // controller: mobileCont,
                      // focusNode: mobileFocus,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Rate Per Hour/ Pkg',
                        contentPadding: EdgeInsets.all(16),
                        labelStyle: secondaryTextStyle(),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: appColorPrimary)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: appStore.textSecondaryColor!)),
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
                  )
                ],
              ),
              16.height,
              Text(
                ' Availability (Day)',
                style: primaryTextStyle(),
              ),
              8.height,
              availabilityLabel(),
              availabilityDay(),
              8.height,
              Row(
                children: [
                  Expanded(
                    child: Card(
                        elevation: 4,
                        child: ListTile(
                          onTap: () {
                            _selectTime(context);
                          },
                          title: Text(
                            'Start Shift',
                            style: primaryTextStyle(),
                          ),
                          subtitle: Text(
                            "${selectedTime.hour < 10 ? "0${selectedTime.hour}" : "${selectedTime.hour}"} : ${selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}"} ${selectedTime.period != DayPeriod.am ? 'PM' : 'AM'}   ",
                            style: secondaryTextStyle(),
                          ),
                          // trailing: IconButton(
                          //   icon: Icon(
                          //     Icons.access_time,
                          //     color: appStore.iconColor,
                          //   ),
                          //   onPressed: () {
                          //     // _selectDate(context);
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
                            'End Shift',
                            style: primaryTextStyle(),
                          ),
                          subtitle: Text(
                            "${selectedTime.hour < 10 ? "0${selectedTime.hour}" : "${selectedTime.hour}"} : ${selectedTime.minute < 10 ? "0${selectedTime.minute}" : "${selectedTime.minute}"} ${selectedTime.period != DayPeriod.am ? 'PM' : 'AM'}   ",
                            style: secondaryTextStyle(),
                          ),
                          // trailing: IconButton(
                          //   icon: Icon(
                          //     Icons.access_time,
                          //     color: appStore.iconColor,
                          //   ),
                          //   onPressed: () {
                          //     // _selectDate(context);
                          //   },
                          // ),
                        )),
                  ),
                ],
              ),
              16.height,
              GestureDetector(
                // onTap: () {
                //   validate();
                // },
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
            ],
          ),
        ),
      ),
    );
  }
}
