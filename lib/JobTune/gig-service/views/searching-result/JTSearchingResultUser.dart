import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
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

  // functions ends //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContainerX(
        mobile: Container(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(' Results from searching  "' + widget.searchkey + '"  ...', style: boldTextStyle()).paddingAll(15),
                  Container(
                      height: 1000,
                      child: JTServiceListUser(keyword: widget.searchkey)
                  ),
                ],
              ),
            ],
          ),
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
          return GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JTServiceDetailScreen(
                      id: servicelist[index]["service_id"],
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
                          "http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + servicelist[index]["profile_pic"],
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
                      Text(servicelist[index]["name"], style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                      4.height,
                      DisplayRate(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                    ],
                  ).paddingAll(8).expand(),
                ],
              ),
            ),
          );
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
            ? Row(
          children: [
            JTpriceWidget(min),
            Text(
              " to ",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            JTpriceWidget(max),
          ],
        )
            : JTpriceWidget(double.parse(min.toStringAsFixed(2))),
      ],
    );
  }
}