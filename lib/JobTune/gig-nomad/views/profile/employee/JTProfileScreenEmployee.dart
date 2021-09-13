import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/account/employee/JTAccountScreenEmployee.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile-settings/employee/JTBankingScreen.dart';
import 'package:prokit_flutter/JobTune/gig-nomad/views/profile-settings/employee/JTExperienceScreen.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTAddressScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTContactScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTEmergencyScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile-setting/JTPersonalScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../main.dart';


class JTProfileScreenEmployee extends StatefulWidget {
  static var tag = "/JTProfileScreenEmployee";

  @override
  _JTProfileScreenEmployeeState createState() => _JTProfileScreenEmployeeState();
}

class _JTProfileScreenEmployeeState extends State<JTProfileScreenEmployee> {

  // functions starts //
  String? selectedIndexCategory = 'Job Category..';
  List<String> listOfCategory = [
    'Job Category..',
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

  List profile = [];
  String email = " ";
  String fullname = " ";
  String desc = " ";
  String nric = " ";
  String dob = " ";
  String race = " ";
  String gender = " ";
  String telno = " ";
  String address = " ";
  String ecname = " ";
  String ecno = " ";
  String category = "";
  String banktype = "";
  String bankno = "";
  String img = "no profile.png";
  Future<void> readProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_user_selectprofile&lgid=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      profile = json.decode(response.body);
    });

    setState(() {
      email = lgid;
      fullname = profile[0]["first_name"] + " " + profile[0]["last_name"] ;
      desc = profile[0]["description"] ;
      nric = profile[0]["nric"] ;
      dob = profile[0]["dob"] ;
      race = profile[0]["race"] ;
      gender = profile[0]["gender"] ;
      telno = profile[0]["phone_no"] ;
      address = profile[0]["address"] ;
      ecname = profile[0]["ec_name"] ;
      ecno = profile[0]["ec_phone_no"] ;
      category = profile[0]["category"] ;
      banktype = profile[0]["bank_type"] ;
      bankno = profile[0]["bank_account_no"] ;

      if(profile[0]["profile_pic"] != "") {
        img = profile[0]["profile_pic"];
      }
      else {
        img = "no profile.png";
      }
    });
  }

  List booking = [];
  String booktotal = "0";
  Future<void> readBooking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_user_countbooking&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      booking = json.decode(response.body);
    });

    setState(() {
      booktotal = booking.length.toString();
    });
  }

  String spending = "0";
  Future<void> readSpending() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_user_countspending&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      spending = double.parse(response.body).toStringAsFixed(2);
    });
  }

  List explist = [];
  Future<void> readExp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_user_selectexperience&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      explist = json.decode(response.body);
    });

    for(var m=0; m<explist.length;m++){
      steps.add(
        Step(
          title: Text(explist[m]["exp_name"], style: boldTextStyle(color: appStore.textPrimaryColor)),
          subtitle: Text("Butik Pengantin Mak Yah", style: primaryTextStyle(color: appStore.textPrimaryColor, size: 14)),
          isActive: currStep == (1+m),
          content: Text("Membantu tukang jahit menjahit sulaman dan manik ke baju pengantin yang sudah siap. Lorem Ipsum is simply dummy text of the printing and typesetting industry.", style: secondaryTextStyle(color: appStore.textSecondaryColor)),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    this.readProfile();
    this.readSpending();
    this.readBooking();
    this.readExp();
  }

  // functions ends //

  int currStep = 1;
  List<Step> steps = [];

  @override
  Widget build(BuildContext context) {
    jtchangeStatusColor(appStore.appBarColor!);
    steps = [
      Step(
        title: Text("Pembantu Tukang Jahit", style: boldTextStyle(color: appStore.textPrimaryColor)),
        subtitle: Text("Butik Pengantin Mak Yah", style: primaryTextStyle(color: appStore.textPrimaryColor, size: 14)),
        isActive: currStep == 0,
        content: Text("Membantu tukang jahit menjahit sulaman dan manik ke baju pengantin yang sudah siap. Lorem Ipsum is simply dummy text of the printing and typesetting industry.", style: secondaryTextStyle(color: appStore.textSecondaryColor)),
      ),
      Step(
        title: Text('Add More +', style: primaryTextStyle()),
        isActive: currStep == 1,
        state: StepState.indexed,
        content: Column(
          children: [
          ],
        ),
      ),
    ];
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appStore.appBarColor,
          title: jtprofile_appBarTitleWidget(context, 'My Profile'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JTAccountScreenEmployee()),
                );
              }
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(top: 70, left: 2, right: 2),
          physics: ScrollPhysics(),
          children: [
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 55.0),
                          decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 50),
                                jtprofile_text(
                                    (fullname == "")
                                        ? " "
                                        : fullname,
                                    textColor: appStore.textPrimaryColor,
                                    fontSize: 20.0, fontFamily: 'Medium'
                                ),
                                jtprofile_text(email, textColor: Colors.blueAccent, fontSize: 16.0, fontFamily: 'Medium'),
                                jtprofile_text(category, textColor: Colors.blueAccent, fontSize: 16.0, fontFamily: 'Medium'),
                                SizedBox(height: 20),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    (desc == "")
                                        ? "Write something.."
                                        : desc,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Divider(color: Color(0XFFDADADA), height: 0.5),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            booktotal,
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            "Worked",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                letterSpacing: 1,
                                                fontFamily: 'Medium'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                                      child: Column(
                                        children: [
                                          Text(
                                            spending,
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            "Received\n(RM)",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 16,
                                                letterSpacing: 1,
                                                fontFamily: 'Medium'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          alignment: FractionalOffset.center,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(imagedev + img),
                            radius: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              jtprofile_rowHeading("PERSONAL"),
                              IconButton(
                                icon: Icon(AntDesign.edit, color: Colors.black,),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => JTPersonalScreenUser(id:"Employee")),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          jtprofile_profileText(
                              (fullname == " ")
                                  ? "Full name.."
                                  : fullname
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: jtprofile_view(),
                          ),
                          SizedBox(height: 8),
                          jtprofile_profileText(
                              (nric == "")
                                  ? "NRIC No.."
                                  : nric
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: jtprofile_view(),
                          ),
                          SizedBox(height: 8),
                          jtprofile_profileText(
                              (dob == "")
                                  ? "Date of birth.."
                                  : dob
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: jtprofile_view(),
                          ),
                          SizedBox(height: 8),
                          jtprofile_profileText(
                              (race == "")
                                  ? "Race.."
                                  : race
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: jtprofile_view(),
                          ),
                          SizedBox(height: 8),
                          jtprofile_profileText(
                              (gender == "")
                                  ? "Gender.."
                                  : gender
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              jtprofile_rowHeading("CONTACTS"),
                              IconButton(
                                icon: Icon(AntDesign.edit, color: Colors.black,),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => JTContactScreenUser(id:"Employee")),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          jtprofile_profileText(
                              (telno == "")
                                  ? "Phone No.."
                                  : telno
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: jtprofile_view(),
                          ),
                          SizedBox(height: 8),
                          jtprofile_profileText(email),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              jtprofile_rowHeading("ADDRESS"),
                              IconButton(
                                icon: Icon(AntDesign.edit, color: Colors.black,),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => JTAddressScreenUser(id:"Employee")),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          jtprofile_profileText(
                              (address == "")
                                  ? "Full Address.."
                                  : address.replaceAll(",", ",\n")
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              jtprofile_rowHeading("BANKING INFORMATION"),
                              IconButton(
                                icon: Icon(AntDesign.edit, color: Colors.black,),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => JTBankingScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          jtprofile_profileText(
                              (banktype == "")
                                  ? "Bank Name.."
                                  : banktype
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: jtprofile_view(),
                          ),
                          SizedBox(height: 8),
                          jtprofile_profileText(
                              (bankno == "")
                                  ? "Account No.."
                                  : bankno
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              jtprofile_rowHeading("EMERGENCY CONTACT"),
                              IconButton(
                                icon: Icon(AntDesign.edit, color: Colors.black,),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => JTEmergencyScreenUser(id:"Employee")),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          jtprofile_profileText(
                              (ecname == "")
                                  ? "Guardian Name.."
                                  : ecname
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            child: jtprofile_view(),
                          ),
                          SizedBox(height: 8),
                          jtprofile_profileText(
                              (ecno == "")
                                  ? "Guardian Phone No.."
                                  : ecno
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: jtprofile_boxDecoration(bgColor: appStore.scaffoldBackground, radius: 10, showShadow: true),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              jtprofile_rowHeading("WORKING EXPERIENCE"),
                              IconButton(
                                icon: Icon(AntDesign.pluscircleo, color: Colors.black,),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => JTExperienceScreenEmployee(id:"non")),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          // Container(
                          //   child: Theme(
                          //     data: ThemeData(backgroundColor: appStore.scaffoldBackground),
                          //     child: Stepper(
                          //       steps: steps,
                          //       physics: BouncingScrollPhysics(),
                          //       type: StepperType.vertical,
                          //       currentStep: this.currStep,
                          //       controlsBuilder: (BuildContext context, {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
                          //         if(currStep == 1){
                          //           return Row(
                          //             mainAxisSize: MainAxisSize.max,
                          //             mainAxisAlignment: MainAxisAlignment.start,
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: <Widget>[
                          //               TextButton(
                          //                 onPressed: (){
                          //                   Navigator.push(
                          //                     context,
                          //                     MaterialPageRoute(builder: (context) => JTExperienceScreenEmployee(id:"non")),
                          //                   );
                          //                 },
                          //                 child: Text('ADD EXPERIENCE', style: secondaryTextStyle()),
                          //               ),
                          //             ],
                          //           );
                          //         }
                          //         else{
                          //           return Row(
                          //             mainAxisSize: MainAxisSize.max,
                          //             mainAxisAlignment: MainAxisAlignment.start,
                          //             crossAxisAlignment: CrossAxisAlignment.start,
                          //             children: <Widget>[
                          //               TextButton(
                          //                 onPressed: onStepContinue,
                          //                 child: Text('EDIT', style: secondaryTextStyle()),
                          //               ),
                          //               10.width,
                          //               TextButton(
                          //                 onPressed: onStepCancel,
                          //                 child: Text('DELETE', style: secondaryTextStyle()),
                          //               ),
                          //             ],
                          //           );
                          //         }
                          //
                          //       },
                          //       onStepContinue: () {
                          //         setState(() {
                          //           if (currStep < steps.length - 1) {
                          //             currStep = currStep + 1;
                          //           } else {
                          //             //currStep = 0;
                          //             finish(context);
                          //           }
                          //         });
                          //       },
                          //       onStepCancel: () {
                          //         finish(context);
                          //         setState(() {
                          //           if (currStep > 0) {
                          //             currStep = currStep - 1;
                          //           } else {
                          //             currStep = 0;
                          //           }
                          //         });
                          //       },
                          //       onStepTapped: (step) {
                          //         setState(() {
                          //           currStep = step;
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // ),
                          Container(
                            height: 380,
                            child: JTExpList(),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        )
    );
  }
}

class JTExpList extends StatefulWidget {
  const JTExpList({Key? key}) : super(key: key);

  @override
  _JTExpListState createState() => _JTExpListState();
}

class _JTExpListState extends State<JTExpList> {

  List explist = [];
  Future<void> readExp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            dev + "jtnew_user_selectexperience&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      explist = json.decode(response.body);
    });

    for(var m=0; m<explist.length;m++){

    }
  }

  @override
  void initState() {
    super.initState();
    this.readExp();
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: explist == null ? 0 : explist.length,
      itemBuilder: (BuildContext context, int index) {
        final DateFormat formatter = DateFormat('d MMM yyyy');
        final String formattedIN = formatter.format(DateTime.parse(explist[index]["from"]));
        final String formattedOUT = formatter.format(DateTime.parse(explist[index]["to"]));
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                formattedIN + " - " + formattedOUT,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                  fontSize: 12.0,
                  letterSpacing: 0.5,

                ),
              ),
              Text(
                explist[index]["exp_name"],
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                explist[index]["exp_company"],
                textAlign: TextAlign.left,
                style: TextStyle(
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                explist[index]["exp_desc"],
                textAlign: TextAlign.left,
                style: TextStyle(
                  letterSpacing: 0.5,
                  color: Colors.grey,
                ),
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JTExperienceScreenEmployee(id:explist[index]["exp_id"])),
                      );
                    },
                    child: Text('EDIT', style: secondaryTextStyle()),
                  ),
                  10.width,
                  TextButton(
                    onPressed: (){
                      showInDialog(context,
                          child: AlertConfirmDelete(id:explist[index]["exp_id"]),
                          backgroundColor: Colors.transparent, contentPadding: EdgeInsets.all(0));
                    },
                    child: Text('DELETE', style: secondaryTextStyle()),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: jtprofile_view(),
              ),
              6.height,
            ],
          );
      }
    );
  }
}


class AlertConfirmDelete extends StatefulWidget {

  const AlertConfirmDelete({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _AlertConfirmDeleteState createState() => _AlertConfirmDeleteState();
}

class _AlertConfirmDeleteState extends State<AlertConfirmDelete> {

  Future<void> deleteExp() async {
    http.get(
        Uri.parse(
            dev + "jtnew_user_deleteexperience&exp=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    toast("Reloading..");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => JTProfileScreenEmployee()),
    );
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
                      "https://jobtune.ai/gig/JobTune/assets/mobile/database.jpg",
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
                      Text(
                        "Confirm Delete?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "This action will permanently delete the data from the record.",
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
                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child: Text("Cancel", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                      5.width,
                      GestureDetector(
                        onTap: () {
                          deleteExp();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(color: appColorPrimary, borderRadius: BorderRadius.all(Radius.circular(5))),
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