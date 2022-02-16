import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'dart:math';
import'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTDashboardWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/model/CategoryModel.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTCartScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTCategoryDetailScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSearchScreen.dart';
import 'package:prokit_flutter/defaultTheme/screen/DTSignInScreen.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/main/utils/rating_bar.dart';


class JTSearchingResultUser extends StatefulWidget {
  const JTSearchingResultUser({Key? key, required this.searchkey}) : super(key: key);
  final String searchkey;
  @override
  _JTSearchingResultUserState createState() => _JTSearchingResultUserState();
}

class _JTSearchingResultUserState extends State<JTSearchingResultUser> {

  var formKey = GlobalKey<FormState>();
  var searchCont = TextEditingController();

  // functions starts //

  List category = [];
  Future<void> readCategory() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectcategory"),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      category = json.decode(response.body);
    });
  }

  List servicelist = [];
  Future<void> checkFeatured() async {
    
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_filterservice&keyword="+widget.searchkey
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkFeatured();
  }

  // functions ends //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: appBarTitleWidget(context, widget.searchkey),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(
                context,
              );
            }),
      ),
      body: ContainerX(
        mobile: Stack(
          children: [
            SingleChildScrollView(
              child: Observer(
                builder: (_) => Container(
                  color: appStore.scaffoldBackground,
                  child: (servicelist.length>0)
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      10.height,
                      Padding(
                        padding: EdgeInsets.all(17),
                        child: Column(
                          children: [
                            Text('We have '+servicelist.length.toString()+' results from searching  "' + widget.searchkey + '"...', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87, fontFamily: "Bold"), maxLines: 3),
                            Text("\nSelect a service to view details", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.black54), maxLines: 3),
                          ],
                        ),
                      ),
                      Container(
                          height: (Platform.isIOS == true) ? 540 : 610,
                          child: JTServiceListUser(keyword: widget.searchkey)
                      ),
                      Container(
                          height: 250,
                          color: Colors.white,
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      80.height,
                      Image.network(
                          "https://bobdomo.com/jobtuneai/JobTune/gig/JobTune/assets/mobile/resized/rsz_database.jpg",
                          width: 250
                      ),
                      Padding(
                        padding: EdgeInsets.all(17),
                        child: Column(
                          children: [
                            Text("WE COULDN'T FIND ANY SERVICES MATCHING YOUR SEARCH", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87, fontFamily: "Bold"), maxLines: 3),
                            Text("\nCheck the spelling of the keyword you used, or try search with another keyword.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.black54), maxLines: 3),
                          ],
                        ),
                      ),
                      Stack(
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
                              10.height,
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Form(
                                  key: formKey,
                                  child: TextFormField(
                                    controller: searchCont,
                                    style: primaryTextStyle(),
                                    decoration: InputDecoration(
                                      labelText: 'Search',
                                      suffixIcon: IconButton(
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => JTSearchingResultUser(
                                              searchkey: searchCont.text,
                                            )),
                                          );
                                        },
                                        icon: Icon(Icons.search),
                                      ),
                                      contentPadding: EdgeInsets.all(16),
                                      labelStyle: secondaryTextStyle(),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Color(0xFF0A79DF))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: appStore.textSecondaryColor!)),
                                    ),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      190.height,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(bottom: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                        height: 50,
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        alignment: Alignment.center,
                        width: context.width(),
                        decoration: BoxDecoration(gradient: LinearGradient(colors: <Color>[Colors.white12, Colors.white]), boxShadow: defaultBoxShadow()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Back to Home ",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            7.width,
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.blueAccent,
                            ),
                          ],
                        )
                    ).onTap(() {
                      // Do your logic
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JTDashboardSreenUser()),
                      );
                    })
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}

class JTServiceListUser extends StatefulWidget {
  const JTServiceListUser({Key? key, required this.keyword}) : super(key: key);
  final String keyword;
  @override
  _JTServiceListUserState createState() => _JTServiceListUserState();
}

class _JTServiceListUserState extends State<JTServiceListUser> {

  // functions starts //

  List servicelist = [];
  Future<void> checkFeatured() async {
    print(server + "jtnew_user_filterservice&keyword="+widget.keyword);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_filterservice&keyword="+widget.keyword
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkFeatured();
  }

  // functions ends //
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: servicelist == null ? 0 : servicelist.length,
        itemBuilder: (BuildContext context, int index) {
          if(servicelist[index]["status"] == "1"){
            return GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JTServiceDetailScreen(
                        id: servicelist[index]["service_id"],
                        page: "detail"
                      )),
                );
              },
              child: Container(
                decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.appBarColor!),
                margin: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 110,
                      width: 126,
                      child: Stack(
                        children: [
                          Image.network(
                            "https://bobdomo.com/jobtuneai/JobTune/gig/JobTune/assets/img/" + servicelist[index]["profile_pic"],
                            fit: BoxFit.cover,
                            height: 110,
                            width: 126,
                          ).cornerRadiusWithClipRRect(8),
                        ],
                      ),
                    ),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(servicelist[index]["service_name"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                                fontSize: 17
                            )
                        ),
                        3.height,
                        DisplayRating(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                        13.height,
                        DisplayRate(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                        5.height,
                        Text(servicelist[index]["location"], style: secondaryTextStyle(size: 13)),
                      ],
                    ).paddingAll(8).expand(),
                  ],
                ),
              ),
            );
          }
          else{
            return Container();
          }
        }
    );
  }
}

class DisplayRate extends StatefulWidget {
  const DisplayRate({
    Key? key,
    required this.id,
    required this.rate,
  }) : super(key: key);
  final String id;
  final String rate;
  @override
  _DisplayRateState createState() => _DisplayRateState();
}

class _DisplayRateState extends State<DisplayRate> {

  // function starts //

  List servicelist = [];
  List numbers = [];
  double max = 0;
  double min = 0;
  Future<void> readPackage() async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectpackage&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      servicelist = json.decode(response.body);
    });

    for(var m=0;m<servicelist.length;m++) {
      numbers.add(servicelist[m]["package_rate"]);
    }

    min = double.parse(servicelist[0]["package_rate"]);
    for(var m=0;m<servicelist.length;m++) {
      if(double.parse(servicelist[m]["package_rate"])>max){
        max = double.parse(servicelist[m]["package_rate"]);
      }
      if(double.parse(servicelist[m]["package_rate"])<min){
        min = double.parse(servicelist[m]["package_rate"]);
      }
    }

    setState(() {
      print("result:" + min.toString()+" "+max.toString());
      min = min;
      max = max;
    });
  }

  @override
  void initState() {
    super.initState();
    this.readPackage();
  }
  // function ends //


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (widget.rate != "0.00")
            ? JTpriceWidget(double.parse(double.parse(widget.rate).toStringAsFixed(2)))
            : (min != max)
            ? Flexible(
          child: Text(
            "RM " + min.toStringAsFixed(2) + " ~ RM " + max.toStringAsFixed(2),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decoration: TextDecoration.none,
              color: appStore.textPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : JTpriceWidget(double.parse(min.toStringAsFixed(2))),
      ],
    );
  }
}