import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile/employer/JTProfileScreenEmployer.dart';
import 'package:prokit_flutter/JobTune/gig-provider/views/profile/JTProfileScreenProvider.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTProfileSettingWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';

import '../../../../../main.dart';


class JTPersonalScreenEmployer extends StatefulWidget {
  @override
  _JTPersonalScreenEmployerState createState() => _JTPersonalScreenEmployerState();
}

class _JTPersonalScreenEmployerState extends State<JTPersonalScreenEmployer> {
  var formKey = GlobalKey<FormState>();
  var names = TextEditingController();
  var desc = TextEditingController();
  var regno = TextEditingController();
  var website = TextEditingController();
  var fb = TextEditingController();
  String pickedcat = "";
  String? selectedIndexCategory = 'Industry Type..';

  // functions starts //

  List profile = [];
  String email = " ";
  String type = " ";
  String img = "no profile.png";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('employerID').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_employer_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      names = TextEditingController(text: profile[0]["company_name"]);
      desc = TextEditingController(text: profile[0]["description"]);
      website = TextEditingController(text: profile[0]["social_website"]);
      fb = TextEditingController(text: profile[0]["social_fb"]);
      regno = TextEditingController(text: profile[0]["company_reg_no"]);
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
  List<String> listOfCategory = [
    'Industry Type..',
    'Audit & Taxation',
    'Banking/Financial',
    'Corporate Finance/Investment',
    'General/Cost Accounting',
    'Admin/Human Resources',
    'Clerical/Administrative',
    'Human Resources',
    'Secretarial',
    'Top Management',
    'Arts/Media/Communications',
    'Arts/Creative Design',
    'Entertainment',
    'Public Relations',
    'Building/Construction',
    'Architect/Interior Design',
    'Civil Engineering/Construction',
    'Property/Real Estate',
    'Quantity Surveying',
    'Computer/Information Technology',
    'IT - Hardware',
    'IT - Network/Sys/DB Admin',
    'IT - Software',
    'Education/Training',
    'Training & Dev.',
    'Chemical Engineering',
    'Electrical Engineering',
    'Electronics Engineering',
    'Environmental Engineering',
    'Industrial Engineering',
    'Mechanical/Automotive Engineering',
    'Oil/Gas Engineering',
    'Other Engineering',
    'Doctor/Diagnosis',
    'Pharmacy',
    'Nurse/Medical Support',
    'Food/Beverage/Restaurant',
    'Hotel/Tourism',
    'Maintenance',
    'Manufacturing',
    'Process Design & Control',
    'Purchasing/Material Mgmt',
    'Quality Assurance',
    'Digital Marketing',
    'Sales - Corporate',
    'E-commerce',
    'Marketing/Business Dev',
    'Merchandising',
    'Retail Sales',
    'Sales - Eng/Tech/IT',
    'Sales - Financial Services',
    'Telesales/Telemarketing',
    'Actuarial/Statistics',
    'Agriculture',
    'Aviation',
    'Biomedical',
    'Biotechnology',
    'Chemistry',
    'Food Tech/Nutritionist',
    'Geology/Geophysics',
    'Science & Technology',
    'Security/Armed Forces',
    'Customer Service',
    'Logistics/Supply Chain',
    'Law/Legal Services',
    'Personal Care',
    'Social Services',
    'Tech & Helpdesk Support',
    'General Work',
    'Journalist/Editors',
    'Publishing',
    'Others',
  ];

  Future<void> updateProfile(name,regno,category,fb,web,desc) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('employerID').toString();

    http.get(
        Uri.parse(
            server + "jtnew_employer_updateprofile&id=" + lgid
                + "&compname=" + name
                + "&type=" + category
                + "&telno=" + profile[0]["phone_no"]
                + "&desc=" + desc
                + "&regno=" + regno
                + "&address=" + profile[0]["address"]
                + "&city=" + profile[0]["city"]
                + "&state=" + profile[0]["state"]
                + "&postcode=" + profile[0]["postcode"]
                + "&country=" + profile[0]["country"]
                + "&fb=" + fb
                + "&web=" + web
                + "&lat=" + profile[0]["location_latitude"]
                + "&long=" + profile[0]["location_longitude"]
        ),
        headers: {"Accept": "application/json"}
    );

    toast("Updated!");
  }

  PickedFile? _image;
  File? _showimg;
  final String uploadUrl = image + 'jtnew_uploadPhoto_employer.php';
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
    final String lgid = prefs.getString('employerID').toString();
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
        title: jtprofile_appBarTitleWidget(context, 'Update Company Info'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JTProfileScreenEmployer()),
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
                  Text('Company Info', style: boldTextStyle(size: 24)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.height,
                      (_image == null)
                          ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.network(image + img, height: 120, width: 120, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
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
                          labelText: 'Company Name',
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
                        controller: regno,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Registration No.',
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
                        controller: fb,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Social Media',
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
                        controller: website,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Website',
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
                        controller: desc,
                        style: primaryTextStyle(),
                        decoration: InputDecoration(
                          labelText: 'Description (optional)',
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
                        updateProfile(names.text,regno.text,pickedcat,fb.text,website.text,desc.text);
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
