import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';
import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/theme2/utils/T2Colors.dart';
import 'package:prokit_flutter/theme7/utils/T7Colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'JTServiceDetailScreen.dart';


class JTChangeAddressScreen extends StatefulWidget {
  static String tag = '/JTChangeAddressScreen';

  const JTChangeAddressScreen({
    Key? key,
    required this.id,
    required this.page,
  }) : super(key: key);
  final String id;
  final String page;

  @override
  JTChangeAddressScreenState createState() => JTChangeAddressScreenState();
}

class JTChangeAddressScreenState extends State<JTChangeAddressScreen> {
  List<DTAddressListModel> list = getAddressList();

  // function starts //

  List addresslist = [];
  List ids = [];
  Future<void> readAddress(a) async {
    print(a);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectalladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      addresslist = json.decode(response.body);

      for(var m=0; m<addresslist.length; m++){
        if(addresslist[m]["added_status"] == "1"){
          ids.add(addresslist[m]["address_id"]);
        }
      }
    });

    if(a == "repeat"){
      readAddress("last");
    }
    else if(a == "last"){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => JTServiceDetailScreen(
              id: widget.id,
              page: widget.page,
            )),
      );
    }
  }

  Future<void> goto() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JTChangeAddressScreen(id: widget.id,page:widget.page),
        ));
  }

  Future<void> allzero(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_user_updatealladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    selectedone(id);
  }

  Future<void> selectedone(id) async {
    http.get(
        Uri.parse(
            server + "jtnew_user_updateoneaddress&id=" + id),
        headers: {"Accept": "application/json"}
    );

    checkSelected(id);
  }

  List checkinglist = [];
  List arrlist = [];
  Future<void> checkSelected(a) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectalladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      checkinglist = json.decode(response.body);
    });

    for(var m=0;m<checkinglist.length;m++){
      arrlist.add(checkinglist[m]["added_status"]);
    }

    if(arrlist.contains("1") == false){
      print(arrlist);
      print("belum");
      print(a);
      selectedone(a);
    }
    else{
      print(arrlist);
      print("dah");
      arrlist = [];
      readAddress("last");
    }
  }


  @override
  void initState() {
    super.initState();
    this.readAddress("start");
  }

  // function ends //

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, 'Address Manager'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if(widget.page == "detail"){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JTServiceDetailScreen(
                        id: widget.id,
                        page: widget.page,
                      )),
                );
              }
              else if (widget.page == "gig-index"){
                JTDashboardSreenUser().launch(context, isNewTask: true);
              }
              else if (widget.page == "home-index"){
                JTDashboardScreenGuest().launch(context, isNewTask: true);
              }
            }
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.23,
              child: ListView(
                children: [
                  8.height,
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(8)),
                    child: Text('Add New Address', style: boldTextStyle(color: appColorPrimary)),
                  ).onTap(() async {
                    showInDialog(context, child: AddAddressDialog(id: widget.id,page:widget.page), backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
                  }),
                  // JTAddressList(id:widget.id,page:widget.page),
                  ListView.builder(
                    itemCount: addresslist == null ? 0 : addresslist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.all(8),
                        decoration: (ids.contains(addresslist[index]["address_id"]))
                            ? boxDecorationRoundedWithShadow(8, backgroundColor: Color(0xfffcefc7))
                            : boxDecorationRoundedWithShadow(8, backgroundColor: appStore.appBarColor!),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(addresslist[index]["added_name"], style: boldTextStyle(size: 18)),
                                    10.width,
                                    (addresslist[index]["added_tag"] != "null" && addresslist[index]["added_tag"] != null)
                                        ? Container(
                                            child: Text(addresslist[index]["added_tag"], overflow: TextOverflow.ellipsis, style: secondaryTextStyle(size: 10, color: appColorPrimary)),
                                            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                            decoration: BoxDecoration(color: appColorPrimary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                                          )
                                        : Container(),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.edit, color: appColorPrimary).onTap(() {
                                      showInDialog(context, child: UpdateAddressDialog(
                                        id: addresslist[index]["address_id"],
                                        ids: widget.id,
                                        page: widget.page,
                                      ), backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
                                    }),
                                    10.width,
                                    Icon(Icons.delete, color: Colors.redAccent).onTap(() {
                                      showInDialog(context,
                                          child: AlertDelete(),
                                          backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
                                    }),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                              child: Text(addresslist[index]["added_address"], style: primaryTextStyle()),
                            ),
                            Text(addresslist[index]["email"], style: primaryTextStyle()),
                            Text(addresslist[index]["added_telno"], style: primaryTextStyle()),
                            6.height,
                          ],
                        ),
                      ).onTap(() {
                        ids.clear();
                        setState(() {
                          ids.add(addresslist[index]["address_id"]);
                        });
                      });
                    },
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  8.height,
                  GestureDetector(
                    onTap: () async {
                      allzero(ids[0]);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Center(
                        child: Text("Confirm location", style: boldTextStyle(color: white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JTAddressList extends StatefulWidget {
  const JTAddressList({
    Key? key,
    required this.id,
    required this.page,
  }) : super(key: key);
  final String id;
  final String page;

  @override
  _JTAddressListState createState() => _JTAddressListState();
}

class _JTAddressListState extends State<JTAddressList> {

  // function starts //

  List addresslist = [];
  List ids = [];
  Future<void> readAddress(a) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectalladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      addresslist = json.decode(response.body);

      for(var m=0; m<addresslist.length; m++){
        if(addresslist[m]["added_status"] == "1"){
          ids.add(addresslist[m]["address_id"]);
        }
      }
    });

    if(a == "repeat"){
      readAddress("start");
    }
  }

  Future<void> goto() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JTChangeAddressScreen(id: widget.id,page:widget.page),
        ));
  }

  Future<void> allzero(id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_user_updatealladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    for(var m=0; m<20; m++){
      print("sleep=" + m.toString());
    }

    selectedone(id);
  }

  Future<void> selectedone(id) async {
    http.get(
        Uri.parse(
            server + "jtnew_user_updateoneaddress&id=" + id),
        headers: {"Accept": "application/json"}
    );

    for(var m=0; m<20; m++){
      print("sleep=" + m.toString());
    }

    readAddress("repeat");
  }


  @override
  void initState() {
    super.initState();
    this.readAddress("start");
  }

  // function ends //
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: addresslist == null ? 0 : addresslist.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(8),
          decoration: (ids.contains(addresslist[index]["address_id"]))
              ? boxDecorationRoundedWithShadow(8, backgroundColor: Color(0xfffcefc7))
              : boxDecorationRoundedWithShadow(8, backgroundColor: appStore.appBarColor!),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(addresslist[index]["added_city"] + " - " + addresslist[index]["added_postcode"], style: boldTextStyle(size: 18)),
                      10.width,
                      (addresslist[index]["added_tag"] != null)
                      ? Container(
                        child: Text(addresslist[index]["added_tag"], overflow: TextOverflow.ellipsis, style: secondaryTextStyle(size: 10, color: appColorPrimary)),
                        padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                        decoration: BoxDecoration(color: appColorPrimary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      )
                      : Container(),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.edit, color: appColorPrimary).onTap(() {
                        showInDialog(context, child: UpdateAddressDialog(
                            id: addresslist[index]["address_id"],
                            ids: widget.id,
                            page: widget.page,
                        ), backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
                      }),
                      10.width,
                      Icon(Icons.delete, color: Colors.redAccent).onTap(() {
                        showInDialog(context,
                            child: AlertDelete(),
                            backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
                      }),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
                child: Text(addresslist[index]["added_address"], style: primaryTextStyle()),
              ),
              Text(addresslist[index]["added_country"], style: primaryTextStyle()),
              6.height,
            ],
          ),
        ).onTap(() {
          toast("Loading..");
          ids.clear();
          setState(() {
            ids.add(addresslist[index]["address_id"]);
          });

          allzero(addresslist[index]["address_id"]);
        });
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}

class AlertDelete extends StatefulWidget {
  @override
  _AlertDeleteState createState() => _AlertDeleteState();
}

class _AlertDeleteState extends State<AlertDelete> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: appStore.iconColor),
                    onPressed: () {
                      finish(context);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.network(
                      "https://jobtune.ai/gig/JobTune/assets/mobile/resized/rsz_database.jpg",
                      width: context.width() * 0.70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              10.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Are you confirm to delete? You can't revert this action.",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          finish(context);
  },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Confirm", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                      5.width,
                      GestureDetector(
                        onTap: () {
                          finish(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Delete", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}



class AddAddressDialog extends StatefulWidget {

  const AddAddressDialog({
    Key? key,
    required this.id,
    required this.page,
  }) : super(key: key);
  final String id;
  final String page;

  @override
  _AddAddressDialogState createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  var fulladdress = TextEditingController();
  var postcode = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var country = TextEditingController();
  var label = TextEditingController();
  var name = TextEditingController();
  var email = TextEditingController();
  var telno = TextEditingController();

  var formKey = GlobalKey<FormState>();
  List<String> listOfState = ['Choose State..','Johor', 'Kedah', 'Kelantan', 'Pahang', 'Melaka', 'Negeri Sembilan', 'Perak', 'Perlis', 'Penang', 'Sabah', 'Sarawak', 'Selangor', 'Terengganu', 'Wilayah Persekutuan Kuala Lumpur', 'Wilayah Persekutuan Labuan', 'Wilayah Persekutuan Putrajaya'];
  String? selectedIndexState = 'Choose State..';

  // List<String> listOfCountry = ['Choose Country..','Malaysia', 'Indonesia', 'Singapore', 'Brunei','Philippines','Thailand','Myanmar','Vietnam','Cambodia','Laos','Timor-Leste'];
  List<String> listOfCountry = ['Choose Country..','Malaysia'];
  String? selectedIndexCountry = 'Choose Country..';

  String home_selected = "false";
  String work_selected = "false";
  String school_selected = "false";
  String family_selected = "false";
  String add_selected = "false";

  // function starts //

  Future<void> goto() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JTChangeAddressScreen(id: widget.id,page:widget.page),
        ));
  }

  // function ends //

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
                    Text('Add New Address', style: boldTextStyle(size: 18)),
                    IconButton(
                      icon: Icon(Icons.close, color: appStore.iconColor),
                      onPressed: () {
                        finish(context);
                      },
                    )
                  ],
                ),
                8.height,
                TextFormField(
                  controller: name,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Receiver Name',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (s) {
                    if (s!.trim().isEmpty) return errorThisFieldRequired;
                    return null;
                  },
                  // onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(mobileFocus),
                  textInputAction: TextInputAction.newline, // when user presses enter it will adapt to it
                ),
                8.height,
                TextFormField(
                  controller: email,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Receiver Email',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (s) {
                    if (s!.trim().isEmpty) return errorThisFieldRequired;
                    return null;
                  },
                  // onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(mobileFocus),
                  textInputAction: TextInputAction.newline, // when user presses enter it will adapt to it
                ),
                8.height,
                TextFormField(
                  controller: telno,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Receiver Phone No.',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (s) {
                    if (s!.trim().isEmpty) return errorThisFieldRequired;
                    return null;
                  },
                  // onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(mobileFocus),
                  textInputAction: TextInputAction.newline, // when user presses enter it will adapt to it
                ),
                8.height,
                TextFormField(
                  controller: fulladdress,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Full Address',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (s) {
                    if (s!.trim().isEmpty) return errorThisFieldRequired;
                    return null;
                  },
                  // onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(mobileFocus),
                  textInputAction: TextInputAction.newline, // when user presses enter it will adapt to it
                ),
                8.height,
                TextFormField(
                  controller: postcode,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Postcode',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (s) {
                    if (s!.trim().isEmpty) return errorThisFieldRequired;
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                8.height,
                TextFormField(
                  controller: city,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'City',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  validator: (s) {
                    if (s!.trim().isEmpty) return errorThisFieldRequired;
                    return null;
                  },
                  textInputAction: TextInputAction.next, // when user presses enter it will adapt to it
                ),
                8.height,
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
                8.height,
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
                        value: selectedIndexCountry,
                        style: boldTextStyle(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: appStore.iconColor,
                        ),
                        underline: 0.height,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            toast(newValue);
                            selectedIndexCountry = newValue;
                          });
                        },
                        items: listOfCountry.map((cat) {
                          return DropdownMenuItem(
                            child: Text(cat, style: primaryTextStyle()).paddingLeft(8),
                            value: cat,
                          );
                        }).toList(),
                      )),
                ),
                8.height,
                Text('  Label as: ', style: boldTextStyle(size: 20)),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        (home_selected == "false")
                        ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "true";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.home_outlined, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                        : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.home_outlined, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' Home ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        (work_selected == "false")
                        ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "true";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.work_outline, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                        : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.work_outline, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' Work ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        (school_selected == "false")
                        ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "true";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.school_outlined, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                        : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.school_outlined, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' School ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        (family_selected == 'false')
                        ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "true";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.family_restroom_outlined, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                        : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.family_restroom_outlined, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' Family ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        (add_selected == "false")
                        ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "true";
                              });
                            },
                            child: Icon(Icons.add, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                        : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.add, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' Add.. ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                  ],
                ),
                20.height,
                (add_selected == "true")
                ? TextFormField(
                  controller: label,
                  keyboardType: TextInputType.text,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    hintText: "Label..",
                    hintStyle: primaryTextStyle(),
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 4, 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: t7view_color, width: 0.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: t7view_color, width: 0.0),
                    ),
                  ),
                )
                : Container(),
                20.height,
                GestureDetector(
                  onTap: () async {
                    if(fulladdress.text != "" || postcode.text != "" || city.text != "" || selectedIndexState.toString() != 'Choose State..' || selectedIndexCountry.toString() != 'Choose Country..' || name.text != "" || telno.text != ""){
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      final String lgid = prefs.getString('email').toString();

                      var selected_tag;
                      if(home_selected == "true"){
                        selected_tag = "Home";
                      }
                      if(work_selected == "true"){
                        selected_tag = "Work";
                      }
                      if(school_selected == "true"){
                        selected_tag = "School";
                      }
                      if(family_selected == "true"){
                        selected_tag = "Family";
                      }
                      if(add_selected == "true"){
                        if(label.text == ""){
                          selected_tag = "";
                        }
                        else{
                          selected_tag = label.text;
                        }
                      }

                      http.get(
                          Uri.parse(
                              server + "jtnew_user_insertaddress&id=" + lgid
                          + "&address=" + fulladdress.text
                          + "&postcode=" + postcode.text
                          + "&city=" + city.text
                          + "&state=" + selectedIndexState.toString()
                          + "&country=" + selectedIndexCountry.toString()
                          + "&tag=" + selected_tag.toString()
                          + "&name=" + name.text
                          + "&email=" + email.text
                          + "&telno=" + telno.text
                          ),
                          headers: {"Accept": "application/json"}
                      );

                      goto();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Center(
                      child: Text("Add", style: boldTextStyle(color: white)),
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


class UpdateAddressDialog extends StatefulWidget {

  const UpdateAddressDialog({
    Key? key,
    required this.id,
    required this.ids,
    required this.page,
  }) : super(key: key);
  final String id;
  final String ids;
  final String page;

  @override
  _UpdateAddressDialogState createState() => _UpdateAddressDialogState();
}

class _UpdateAddressDialogState extends State<UpdateAddressDialog> {
  var fulladdress = TextEditingController();
  var postcode = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var country = TextEditingController();
  var label = TextEditingController();

  var formKey = GlobalKey<FormState>();
  List<String> listOfState = ['Choose State..','Johor', 'Kedah', 'Kelantan', 'Pahang', 'Melaka', 'Negeri Sembilan', 'Perak', 'Perlis', 'Penang', 'Sabah', 'Sarawak', 'Selangor', 'Terengganu', 'Wilayah Persekutuan Kuala Lumpur', 'Wilayah Persekutuan Labuan', 'Wilayah Persekutuan Putrajaya'];
  String? selectedIndexState = 'Choose State..';

  List<String> listOfCountry = ['Choose Country..','Malaysia', 'Indonesia', 'Singapore', 'Brunei','Philippines','Thailand','Myanmar','Vietnam','Cambodia','Laos','Timor-Leste'];
  String? selectedIndexCountry = 'Choose Country..';

  String home_selected = "false";
  String work_selected = "false";
  String school_selected = "false";
  String family_selected = "false";
  String add_selected = "false";

  // function starts //

  List addresslist = [];
  Future<void> readAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectoneaddress&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      addresslist = json.decode(response.body);

      if(addresslist[0]["added_address"] != ""){
        fulladdress = TextEditingController(text: addresslist[0]["added_address"]);
      }
      if(addresslist[0]["added_city"] != ""){
        city = TextEditingController(text: addresslist[0]["added_city"]);
      }
      if(addresslist[0]["added_postcode"] != ""){
        postcode = TextEditingController(text: addresslist[0]["added_postcode"]);
      }
      if(addresslist[0]["added_state"] != ""){
        selectedIndexState = addresslist[0]["added_state"];
      }
      if(addresslist[0]["added_country"] != ""){
        selectedIndexCountry = addresslist[0]["added_country"];
      }
      if(addresslist[0]["added_tag"] != null){
        if(addresslist[0]["added_tag"] == "Home"){
          home_selected = "true";
        }
        else if(addresslist[0]["added_tag"] == "Work"){
          work_selected = "true";
        }
        else if(addresslist[0]["added_tag"] == "School"){
          school_selected = "true";
        }
        else if(addresslist[0]["added_tag"] == "Family"){
          family_selected = "true";
        }
        else{
          add_selected = "true";
          label = TextEditingController(text: addresslist[0]["added_tag"]);
        }
      }
    });
  }

  Future<void> goto() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => JTChangeAddressScreen(id: widget.ids,page:widget.page),
        ));
  }

  @override
  void initState() {
    super.initState();
    this.readAddress();
  }

  // function ends //

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
                    Text('Edit Address', style: boldTextStyle(size: 18)),
                    IconButton(
                      icon: Icon(Icons.close, color: appStore.iconColor),
                      onPressed: () {
                        finish(context);
                      },
                    )
                  ],
                ),
                8.height,
                TextFormField(
                  controller: fulladdress,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Full Address',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (s) {
                    if (s!.trim().isEmpty) return errorThisFieldRequired;
                    return null;
                  },
                  // onFieldSubmitted: (s) => FocusScope.of(context).requestFocus(mobileFocus),
                  textInputAction: TextInputAction.newline, // when user presses enter it will adapt to it
                ),
                8.height,
                TextFormField(
                  controller: postcode,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'Postcode',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (s) {
                    if (s!.trim().isEmpty) return errorThisFieldRequired;
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                8.height,
                TextFormField(
                  controller: city,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    labelText: 'City',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  validator: (s) {
                    if (s!.trim().isEmpty) return errorThisFieldRequired;
                    return null;
                  },
                  textInputAction: TextInputAction.next, // when user presses enter it will adapt to it
                ),
                8.height,
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
                8.height,
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
                        value: selectedIndexCountry,
                        style: boldTextStyle(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: appStore.iconColor,
                        ),
                        underline: 0.height,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            toast(newValue);
                            selectedIndexCountry = newValue;
                          });
                        },
                        items: listOfCountry.map((cat) {
                          return DropdownMenuItem(
                            child: Text(cat, style: primaryTextStyle()).paddingLeft(8),
                            value: cat,
                          );
                        }).toList(),
                      )),
                ),
                8.height,
                Text('  Label as: ', style: boldTextStyle(size: 20)),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        (home_selected == "false")
                            ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "true";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.home_outlined, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                            : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.home_outlined, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' Home ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        (work_selected == "false")
                            ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "true";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.work_outline, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                            : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.work_outline, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' Work ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        (school_selected == "false")
                            ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "true";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.school_outlined, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                            : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.school_outlined, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' School ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        (family_selected == 'false')
                            ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "true";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.family_restroom_outlined, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                            : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.family_restroom_outlined, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' Family ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        (add_selected == "false")
                            ? Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "true";
                              });
                            },
                            child: Icon(Icons.add, color: appColorPrimary),
                            backgroundColor: Colors.white,
                          ),
                        )
                            : Container(
                          width: 50,
                          height: 50,
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                home_selected = "false";
                                work_selected = "false";
                                school_selected = "false";
                                family_selected = "false";
                                add_selected = "false";
                              });
                            },
                            child: Icon(Icons.add, color: Colors.white),
                            backgroundColor: appColorPrimary,
                          ),
                        ),
                        10.height,
                        Text(' Add.. ', style: boldTextStyle(size: 12)),
                      ],
                    ),
                  ],
                ),
                20.height,
                (add_selected == "true")
                    ? TextFormField(
                  controller: label,
                  keyboardType: TextInputType.text,
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    hintText: "Label..",
                    hintStyle: primaryTextStyle(),
                    contentPadding: EdgeInsets.fromLTRB(10, 20, 4, 10),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: t7view_color, width: 0.0),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: t7view_color, width: 0.0),
                    ),
                  ),
                )
                    : Container(),
                20.height,
                GestureDetector(
                  onTap: () async {
                    if(fulladdress.text != "" || postcode.text != "" || city.text != "" || selectedIndexState.toString() != 'Choose State..' || selectedIndexCountry.toString() != 'Choose Country..'){
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      final String lgid = prefs.getString('email').toString();

                      var selected_tag;
                      if(home_selected == "true"){
                        selected_tag = "Home";
                      }
                      if(work_selected == "true"){
                        selected_tag = "Work";
                      }
                      if(school_selected == "true"){
                        selected_tag = "School";
                      }
                      if(family_selected == "true"){
                        selected_tag = "Family";
                      }
                      if(add_selected == "true"){
                        if(label.text == ""){
                          selected_tag = "";
                        }
                        else{
                          selected_tag = label.text;
                        }
                      }

                      http.get(
                          Uri.parse(
                              server + "jtnew_user_updateaddress&id=" + widget.id
                                  + "&address=" + fulladdress.text
                                  + "&postcode=" + postcode.text
                                  + "&city=" + city.text
                                  + "&state=" + selectedIndexState.toString()
                                  + "&country=" + selectedIndexCountry.toString()
                                  + "&tag=" + selected_tag.toString()
                          ),
                          headers: {"Accept": "application/json"}
                      );

                      goto();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Center(
                      child: Text("Save", style: boldTextStyle(color: white)),
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
