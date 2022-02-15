import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTApps.dart';
import 'package:prokit_flutter/JobTune/gig-guest/models/JTNewVacancies.dart';
import 'package:prokit_flutter/JobTune/gig-product/views/index/JTDashboardProductWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTCategoryDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSearchScreen.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/main/utils/rating_bar.dart';

import 'JTDashboardScreenGuest.dart';
import 'JTProductDetailScreenGuest.dart';
import 'JTServiceListCategory.dart';

class JTDashboardWidgetGuest extends StatefulWidget {
  static String tag = '/JTDashboardWidgetGuest';

  @override
  _JTDashboardWidgetGuestState createState() => _JTDashboardWidgetGuestState();
}

class _JTDashboardWidgetGuestState extends State<JTDashboardWidgetGuest> {
//  PageController pageController = PageController();

  List<Widget> pages = [];
  List<CategoryModel> categories = [];

  int selectedIndex = 0;

  late List<NewVacancies> mListings3;

  // functions starts //

  List profile = [];
  Future<void> checkProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    if(lgid != "null") {
      http.Response response = await http.get(
          Uri.parse(
              server + "jtnew_user_selectprofile&lgid=" + lgid),
          headers: {"Accept": "application/json"}
      );

      this.setState(() {
        profile = json.decode(response.body);
      });

      if(profile[0]["address"] != ""){
        readAddress();
      }
      else{
        readCategory();
      }
    }
    else {
      readCategory();
    }
  }

  List selectedaddress = [];
  String fullname = "";
  String address = "";
  String tag = "";
  String tagname = "";
  String city = "";
  String state = "";
  String addressread = "";
  String displayaddress = "";
  String displaystatus = "false";
  List displaylist = [];
  Future<void> readAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lgid = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectalladdress&id=" + lgid),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      selectedaddress = json.decode(response.body);
    });

    for(var m=0; m<selectedaddress.length; m++){
      if(selectedaddress[m]["added_status"] == "1"){
        displaystatus = "true";
        setState(() {
          fullname = selectedaddress[m]["added_name"];
          city = selectedaddress[m]["added_city"];
          state = selectedaddress[m]["added_state"];
          addressread = selectedaddress[m]["added_address"];
          tagname = selectedaddress[m]["added_tag"];
          if(selectedaddress[m]["added_tag"] != "Home" && selectedaddress[m]["added_tag"] != "Work" && selectedaddress[m]["added_tag"] != "School" && selectedaddress[m]["added_tag"] != "Family") {
            tag = "pin";
          }
          else{
            tag = selectedaddress[m]["added_tag"];
          }

          if(addressread.split(",").length > 3) {
            displayaddress = addressread.split(",")[0] + "," + addressread.split(",")[1] + "," + addressread.split(",")[2];
          }
          else{
            displayaddress = addressread;
          }
        });

        checkCategory(selectedaddress[m]["added_city"],selectedaddress[m]["added_state"],selectedaddress[m]["added_country"]);
      }
    }
  }

  List category = [];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectavailablecategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    for(var m=0;m<category.length;m++) {
      categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/'+category[m]["icon"]));
    }
  }

  Future<void> checkCategory(city,state,country) async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_selectavailablecategory&city="+city
              +"&state="+state
                +"&country="+country
        ),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });

    if(category.length > 4){
      for(var m=0;m<4;m++) {
        categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/'+category[m]["icon"]));
      }
    }
    else{
      for(var m=0;m<category.length;m++) {
        categories.add(CategoryModel(name: category[m]["category"], icon: 'images/defaultTheme/category/'+category[m]["icon"]));
      }
    }
  }

  // functions ends //

  @override
  void initState() {
    super.initState();
    mListings3 = getJobList();
    this.checkProfile();
    init();
    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 7) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  init() async {
    pages = [
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Home.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Home Tuition/ Tutor",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Religious.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Religious",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Baby Sitting.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Baby Sitting",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Photographer.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Photography",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            image: NetworkImage(image + 'category/Mobile Salon.jpg'),
            height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Mobile Salon",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            image: NetworkImage(image + 'category/Kitchen Assistant.jpg'),
            height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Kitchen Assistant",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
              colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
              image: NetworkImage(image + 'category/Lawn Mowing.jpg'),
              height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Lawn Mowing",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
      Container(child: Stack(
        alignment: Alignment.center,
        children: [
          Ink.image(
            colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
            image: NetworkImage(image + 'category/Data Entry.jpg'),
            height: isMobile ? 180 : 350,
              fit: BoxFit.cover
          ),
          Text(
            "Data Entry",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),),
    ];

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  int _currentPage = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 440.0,
              floating: true,
              pinned: false,
              snap: false,
              automaticallyImplyLeading : true,
              backgroundColor: appStore.appBarColor,
              flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: appColorPrimary,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                        ),
                      ).visible(false),
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (displaystatus == "true")
                              ? Card(
                                child: InkWell(
                                  onTap: (){
                                    mExpandedSheet(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
                                    child: ListTile(
                                      leading: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 0.0, left: 12.0, right: 0.0, bottom: 0.0),
                                            child: Container(
                                              height: 25,
                                              width: 25,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: Image.asset(
                                                      'images/widgets/materialWidgets/mwInputSelectionWidgets/Checkbox/'+tag+'.png',
                                                    ).image),
                                                shape: BoxShape.rectangle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        city + ", " + state,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Text(
                                        displayaddress,
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(' Services Categories', style: boldTextStyle()).paddingAll(8),
                                  Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)).onTap(() {
                                    appStore.setDrawerItemIndex(-1);

                                    if (isMobile) {
                                      JTDashboardSreenUser().launch(context, isNewTask: true);
                                    } else {
                                      //                                  DTDashboardScreen().launch(context, isNewTask: true);
                                    }
                                  }),
                                ],
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(right: 8, top: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: categories.map((e) {
                                    return Container(
                                      width: isMobile ? 100 : 120,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: appColorPrimary),
                                            child: Image.asset(e.icon!, height: 30, width: 30, color: white),
                                          ),
                                          4.height,
                                          Text(
                                              e.name!,
                                              style: primaryTextStyle(size: 12),
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis
                                          ),
                                        ],
                                      ),
                                    ).onTap(() {
                                      // JTServiceListCategory().launch(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => JTServiceListCategory(
                                          searchkey: e.name!,
                                        )),
                                      );
                                    });
                                  }).toList(),
                                ),
                              ),
                              20.height,
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(8),
                            height: 170,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                PageView(
                                  controller: pageController,
                                  scrollDirection: Axis.horizontal,
                                  children: pages,
                                  onPageChanged: (index) {
                                    selectedIndex = index;
                                    setState(() {});
                                  },
                                ).cornerRadiusWithClipRRect(8),
                                DotIndicator(
                                  pages: pages,
                                  indicatorColor: appColorPrimary,
                                  pageController: pageController,
                                ),
                              ],
                            ),
                          ),
                          10.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(' Product Listing', style: boldTextStyle()).paddingAll(8),
                              Text(' Service Listing', style: boldTextStyle()).paddingAll(8),
                              Text('View All    ', style: TextStyle(color: Colors.blueGrey ,fontSize: 15)).onTap(() {
                                appStore.setDrawerItemIndex(-1);

                                if (isMobile) {
                                  JTDashboardSreenUser().launch(context, isNewTask: true);
                                } else {
                                  //                                  DTDashboardScreen().launch(context, isNewTask: true);
                                }
                              }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
              ),
            ),
          ];
        },
        body: Container(height: 390, child: JTProductList()),
      )
    );
  }
}

mExpandedSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.2,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          color: appStore.scaffoldBackground,
          child: GestureDetector(
            onTap: () {
              finish(context);
            },
            child: AddressList(),
          ),
        );
      },
    ),
  );
}

class AddressList extends StatefulWidget {
  const AddressList({Key? key}) : super(key: key);

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {

  List addresslist = [];
  List ids = [];
  var gender1;

  Future<void> readAddress() async {
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
      Navigator.pop(context);
      Navigator.pop(context);
      JTDashboardScreenGuest().launch(context, isNewTask: true);
      // readAddress("last");
    }
  }

  @override
  void initState() {
    super.initState();
    this.readAddress();
  }

  @override
  Widget build(BuildContext context) {

    void _onHorizontalLoading1() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: appStore.scaffoldBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: [
                  16.width,
                  CircularProgressIndicator(
                    backgroundColor: Color(0xffD6D6D6),
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                  16.width,
                  Text(
                    "Please Wait....",
                    style: primaryTextStyle(color: appStore.textPrimaryColor),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
        itemCount: addresslist == null ? 0 : addresslist.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: appStore.textPrimaryColor,
              ),
              child: RadioListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  secondary: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: (addresslist[index]["added_tag"] != "Home" && addresslist[index]["added_tag"] != "Work" && addresslist[index]["added_tag"] != "School" && addresslist[index]["added_tag"] != "Family")
                              ? Image.asset(
                            'images/widgets/materialWidgets/mwInputSelectionWidgets/Checkbox/pin.png',
                          ).image
                              : Image.asset(
                            'images/widgets/materialWidgets/mwInputSelectionWidgets/Checkbox/'+addresslist[index]["added_tag"]+'.png',
                          ).image
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  title: Text(
                    addresslist[index]["added_city"] + ", " + addresslist[index]["added_state"],
                    style: boldTextStyle(),
                  ),
                  subtitle: Text(
                    addresslist[index]["added_address"],
                    style: secondaryTextStyle(),
                  ),
                  value: addresslist[index]["address_id"],
                  groupValue: gender1,
                  onChanged: (dynamic value) {
                    _onHorizontalLoading1();
                    allzero(addresslist[index]["address_id"]);
                  }),
            ),
          );
        }
    );
  }
}