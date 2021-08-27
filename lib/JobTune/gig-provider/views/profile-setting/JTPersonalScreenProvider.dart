import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTProfileSettingWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';

import '../../../../main.dart';


class JTPersonalScreenProvider extends StatefulWidget {
  @override
  _JTPersonalScreenProviderState createState() => _JTPersonalScreenProviderState();
}

class _JTPersonalScreenProviderState extends State<JTPersonalScreenProvider> {
  var formKey = GlobalKey<FormState>();
  var names = TextEditingController();
  var desc = TextEditingController();
  String pickedcat = "";
  String? selectedIndexCategory = 'Industry Type..';

  // functions starts //

  List profile = [];
  String email = " ";
  String type = " ";
  String img = "no profile.png";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      names = TextEditingController(text: profile[0]["name"]);
      desc = TextEditingController(text: profile[0]["description"]);
      if(profile[0]["profile_pic"] != "") {
        img = profile[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
      if(profile[0]["industry_type"] == ""){
        selectedIndexCategory = 'Industry Type..';
      }
      else{
        selectedIndexCategory = profile[0]["industry_type"];
      }
    });
  }

  List category = [];
  List<String> listOfCategory = ['Industry Type..'];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectcategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      listOfCategory.add(category[m]["category"]);
    }
  }

  Future<void> updateProfile(name,category,desc) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.get(
        Uri.parse(
            server + "jtnew_provider_updateprofile&id=" + lgid
                + "&names=" + name
                + "&type=" + category
                + "&telno=" + profile[0]["phone_no"]
                + "&desc=" + desc
                + "&address=" + profile[0]["address"]
                + "&city=" + profile[0]["city"]
                + "&state=" + profile[0]["state"]
                + "&postcode=" + profile[0]["postcode"]
                + "&country=" + profile[0]["country"]
                + "&banktype=" + profile[0]["bank_type"]
                + "&bankno=" + profile[0]["bank_acc_no"]
                + "&lat=" + profile[0]["location_latitude"]
                + "&long=" + profile[0]["location_longitude"]
        ),
        headers: {"Accept": "application/json"}
    );

    //alert: update success
  }

  PickedFile? _image;
  File? _showimg;
//  final String uploadUrl = 'https://jobtune.ai/gig/JobTune/assets/img/mobile_uploadPhoto_user.php';
  final String uploadUrl = 'http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/jtnew_uploadPhoto_provider.php';
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async{
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
      _showimg = File(pickedFile!.path);
    });
    print(_image!.path);
    print(uploadUrl);
    await uploadImage(_image!.path, uploadUrl);
  }

  uploadImage(filepath, url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();
    final snackBar = SnackBar(content: Text('Profile Picture Changed!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['lgid'] = lgid;
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  @override
  void initState() {
    super.initState();
    this.readProfile();
    this.readCategory();
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
        title: jtprofile_appBarTitleWidget(context, 'Update Personal Info'),
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
                  Text('Personal Info', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.height,
                      (_image == null)
                          ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network("http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + img, height: 120, width: 120, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
                          Positioned(
                            top: 80,
                            right: 0,
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue, // Button color
                                child: InkWell(
                                  splashColor: Colors.green, // Splash color
                                  onTap: () {
                                    _pickImage();
//                                    Navigator.push(
//                                      context,
//                                      MaterialPageRoute(builder: (context) => UploadPhoto()),
//                                    );
                                  },
                                  child: SizedBox(width: 30, height: 30, child: Icon(Icons.photo_camera, color: Colors.white, size: 15)),
                                ),
                              ),
                            ),//CircularAvatar
                          ),
                        ],
                      )
                          : Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.file(_showimg!, height: 120, width: 120, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
                          Positioned(
                            top: 80,
                            right: 0,
                            child: ClipOval(
                              child: Material(
                                color: Colors.blue, // Button color
                                child: InkWell(
                                  splashColor: Colors.green, // Splash color
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: SizedBox(width: 30, height: 30, child: Icon(Icons.photo_camera, color: Colors.white, size: 15)),
                                ),
                              ),
                            ),//CircularAvatar
                          ),
                        ],
                      ),
                      30.height,
                      TextFormField(
                        controller: names,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Name',
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
                        controller: desc,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          contentPadding: EdgeInsets.all(16),
                          labelStyle: secondaryTextStyle(),
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
                        if(selectedIndexCategory.toString() != 'Industry Type..'){
                          pickedcat = selectedIndexCategory.toString();
                        }
                        updateProfile(names.text,pickedcat,desc.text);
                      }),
                      20.height,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
