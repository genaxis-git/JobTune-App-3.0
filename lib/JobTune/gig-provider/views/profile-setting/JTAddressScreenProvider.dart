import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTProfileSettingWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';

import '../../../../main.dart';


class JTAddressScreenProvider extends StatefulWidget {
  @override
  _JTAddressScreenProviderState createState() => _JTAddressScreenProviderState();
}

class _JTAddressScreenProviderState extends State<JTAddressScreenProvider> {
  List<String> listOfState = ['Choose State..','Johor', 'Kedah', 'Kelantan', 'Pahang', 'Melaka', 'Negeri Sembilan', 'Perak', 'Perlis', 'Penang', 'Sabah', 'Sarawak', 'Selangor', 'Terengganu', 'Wilayah Persekutuan Kuala Lumpur', 'Wilayah Persekutuan Labuan', 'Wilayah Persekutuan Putrajaya'];
  String? selectedIndexState = 'Choose State..';
  String? dropdownNames;
  String? dropdownScrollable = 'I';
  bool obscureText = true;
  bool autoValidate = false;
  String pickedstate = "";
  var formKey = GlobalKey<FormState>();

  var full = TextEditingController();
  var postcode = TextEditingController();
  var city = TextEditingController();
  var country = TextEditingController();

// functions starts //

  List profile = [];
  String email = " ";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      email = lgid;
      profile = json.decode(response.body);
    });

    setState(() {
      full = TextEditingController(text: profile[0]["address"]);
      postcode = TextEditingController(text: profile[0]["postcode"]);
      city = TextEditingController(text: profile[0]["city"]);
      country = TextEditingController(text: profile[0]["country"]);
    });
  }

  Future<void> updateProfile(full,postcode,city,country,state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    List<Location> locations = await locationFromAddress(full);
    var latitude = locations[0].toString().split(",")[0].split(": ")[1];
    var longitude = locations[0].toString().split(",")[1].split(": ")[1];

    http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_updateprofile&id=" + lgid
                + "&names=" + profile[0]["name"]
                + "&type=" + profile[0]["industry_type"]
                + "&telno=" + profile[0]["phone_no"]
                + "&desc=" + profile[0]["description"]
                + "&address=" + full
                + "&city=" + city
                + "&state=" + state
                + "&postcode=" + postcode
                + "&country=" + country
                + "&banktype=" + profile[0]["bank_type"]
                + "&bankno=" + profile[0]["bank_acc_no"]
                + "&lat=" + latitude.toString()
                + "&long=" + longitude.toString()
        ),
        headers: {"Accept": "application/json"}
    );

    //alert: update success
  }

  @override
  void initState() {
    super.initState();
    this.readProfile();
  }

  // functions ends //


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, 'Update Address Info'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTProfileScreenProvider()),
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
                  Text('Address Info', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      20.height,
                      TextFormField(
                        controller: full,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Full Address',
                          contentPadding: EdgeInsets.all(16),
                          labelStyle: secondaryTextStyle(),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      16.height,
                      TextFormField(
                        controller: postcode,
//                    focusNode: emailFocus,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Postcode',
                          labelStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                      16.height,
                      TextFormField(
                        controller: city,
//                    focusNode: emailFocus,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'City',
                          labelStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      16.height,
                      Container(
                        height: 60,
                        child: Card(
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
                              value: selectedIndexState,
                              style: boldTextStyle(),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: appStore.iconColor,
                              ),
                              underline: 0.height,
                              onChanged: (dynamic newValue) {
                                setState(() {
                                  toast(newValue);
                                  selectedIndexState = newValue;
                                });
                              },
                              items: listOfState.map((category) {
                                return DropdownMenuItem(
                                  child: Text(category, style: primaryTextStyle()).paddingLeft(8),
                                  value: category,
                                );
                              }).toList(),
                            )),
                      ),
                      16.height,
                      TextFormField(
                        controller: country,
//                    focusNode: emailFocus,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Country',
                          labelStyle: secondaryTextStyle(),
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      40.height,
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(color: Color(0xFF0A79DF), borderRadius: BorderRadius.circular(8), boxShadow: defaultBoxShadow()),
                        child: Text('Update', style: boldTextStyle(color: white, size: 18)),
                      ).onTap(() {
                        if(selectedIndexState.toString() != 'Choose State'){
                          pickedstate = selectedIndexState.toString();
                        }
                        updateProfile(full.text,postcode.text,city.text,country.text,pickedstate);
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
