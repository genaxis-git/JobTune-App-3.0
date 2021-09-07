import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
// import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
// import 'package:prokit_flutter/defaultTheme/screen/DTAboutScreen.dart';
// import 'package:prokit_flutter/defaultTheme/screen/DTPaymentScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
// import 'package:prokit_flutter/main/utils/AppConstant.dart';
// import 'package:prokit_flutter/main/utils/AppWidget.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;
import 'package:prokit_flutter/JobTune/constructor/server.dart' as server;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

import '../../../../main.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDrawerWidgetProduct.dart';
import '../ongoing_order/JTOrderScreen.dart';
import '../co_de_booking/JTCoDeBookingScreen.dart';

class PostProduct extends StatefulWidget {
  @override
  _PostProductState createState() => _PostProductState();
}

class _PostProductState extends State<PostProduct> {
  var formKey = GlobalKey<FormState>();
  String? selectedCategory = 'Category';
  String? selectedRateBy = 'Rate By';
  TimeOfDay selectedTime = TimeOfDay.now();
  List chosenDay = [];

  bool? isChecked1 = false;
  bool? isChecked2 = false;
  bool? isChecked3 = false;
  bool? isChecked4 = false;
  bool? isChecked5 = false;
  bool? isChecked6 = false;
  bool? isChecked7 = false;

  var titleField = TextEditingController();
  var categoryField = TextEditingController();
  var descField = TextEditingController();
  var locationField = TextEditingController();
  var expectedDayField = TextEditingController();
  var priceField = TextEditingController();
  var deliveryFeeField = TextEditingController();
  var availabilityField = TextEditingController();

  final String uploadUrlin = server.productImageUpload;
  final ImagePicker _pickerin = ImagePicker();
  File? _imagein;

  Future<void> getImage() async {
    try {
      final pickerImage = await _pickerin.getImage(source: ImageSource.gallery);
      setState(() {
        _imagein = File(pickerImage!.path);
      });
    } catch (e) {
      print("Image picker error");
    }
  }

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

  List<String> rateBy = [
    'Rate By',
    'Hour',
    'Package',
  ];

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

  Future<void> getInput() async {
    if (isChecked1 == true) {
      chosenDay.add("Monday");
    }
    if (isChecked2 == true) {
      chosenDay.add("Tuesday");
    }
    if (isChecked3 == true) {
      chosenDay.add("Wednesday");
    }
    if (isChecked4 == true) {
      chosenDay.add("Thursday");
    }
    if (isChecked5 == true) {
      chosenDay.add("Friday");
    }
    if (isChecked6 == true) {
      chosenDay.add("Saturday");
    }
    if (isChecked7 == true) {
      chosenDay.add("Sunday");
    }

    var availableDay = chosenDay.join(",");
    var titleData = titleField.text;
    var descData = descField.text;
    var locationData = locationField.text;
    var expectedDayData = expectedDayField.text;
    var priceData = priceField.text;
    var deliveryFeeData = deliveryFeeField.text;
    var totalPrice = priceData.toDouble() + deliveryFeeData.toDouble();

    addProduct(availableDay, titleData, descData, locationData, expectedDayData,
        priceData, deliveryFeeData, totalPrice);
  }

  Future<String?> uploadImage(filepath, url) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss d MMM y').format(now);
    // final snackBar = SnackBar(
    //     content: Text('Clock-in record sent at ' + formattedDate + ' !'));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['lgid'] = "5";
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<void> addProduct(availableDay, titleData, descData, locationData,
      expectedDayData, priceData, deliveryFeeData, totalPrice) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final jobtuneUser = prefs.getString('user');
    final jobtuneUser = "shahirah0397@gmail.com";

    http.get(
        Uri.parse(server.devserver +
            "jtnew_product_insertproduct&j_providerid=" +
            jobtuneUser.toString() +
            "&j_title=" +
            Uri.encodeComponent(titleData) +
            "&j_category=" +
            Uri.encodeComponent(selectedCategory.toString()) +
            "&j_desc=" +
            Uri.encodeComponent(descData) +
            "&j_location=" +
            Uri.encodeComponent(locationData) +
            "&j_expectday=" +
            expectedDayData +
            "&j_price=" +
            priceData +
            "&j_deliveryfee=" +
            deliveryFeeData +
            "&j_totalprice=" +
            totalPrice.toString() +
            "&j_availability=" +
            availableDay),
        headers: {"Accept": "application/json"});

    toast("Product added successfully");
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
                controller: titleField,
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
                value: selectedCategory,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: appStore.iconColor,
                ),
                onChanged: (dynamic newValue) {
                  setState(() {
                    toast(newValue);
                    selectedCategory = newValue;
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
                controller: descField,
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
                controller: locationField,
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
              TextFormField(
                controller: expectedDayField,
                // focusNode: mobileFocus,
                style: primaryTextStyle(),
                decoration: InputDecoration(
                  labelText: 'Expected Day(s) taken to deliver product',
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
                keyboardType: TextInputType.numberWithOptions(),
              ),
              8.height,
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priceField,
                      // focusNode: mobileFocus,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Price (RM)',
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
                  ),
                  8.width,
                  Expanded(
                    child: TextFormField(
                      controller: deliveryFeeField,
                      // focusNode: mobileFocus,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: 'Delivery Fee',
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
                ' Order Availability (Day)',
                style: primaryTextStyle(),
              ),
              8.height,
              availabilityLabel(),
              availabilityDay(),
              16.height,
              ButtonTheme(
                minWidth: 500,
                child: ElevatedButton(
                  // textColor: Colors.white,
                  // color: Colors.blueAccent,
                  onPressed: () async {
                    getImage();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Upload Photo',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 1),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.camera_alt_sharp,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              8.height,
              GestureDetector(
                onTap: () {
                  getInput();
                  uploadImage(_imagein!.path, uploadUrlin);
                  var filename = Path.basename(_imagein!.path);
                  DateTime now = DateTime.now();
                  String formattedDate =
                      DateFormat('y-MM-dd kk:mm:ss').format(now);
                  // sendClockin(formattedDate.toString(), filename.toString());
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
            ],
          ),
        ),
      ),
    );
  }
}
