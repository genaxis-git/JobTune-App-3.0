import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/index/JTProductDetailWidget.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/theme2/utils/T2Colors.dart';

import '../../../../main.dart';

class JTOpenNotiScreen extends StatefulWidget {
  static String tag = '/DTCartScreen';

  const JTOpenNotiScreen({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  JTOpenNotiScreenState createState() => JTOpenNotiScreenState();
}

class JTOpenNotiScreenState extends State<JTOpenNotiScreen> {

  String date = "";
  String subject = "";
  String message = "";
  String provider = "";
  String img = "no profile.png";
  List follows = [];
  Future<void> readNoti() async {

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_user_readnoti&id="+ widget.id
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      follows = json.decode(response.body);
    });

    setState(() {
      date = follows[0]["noti_date"];
      subject = follows[0]["subject"];
      message = follows[0]["message"];
      img = follows[0]["profile_pic"];
      provider = follows[0]["name"];
    });

    if(follows[0]["attachment"] != ""){
      readService(follows[0]["attachment"]);
    }
  }

  List info = [];
  String servicename = "";
  String rate = "0";
  String desc = "";
  String category = "";
  String days = "";
  String hours = "";
  String location = "";
  String proid = "";
  String by = "Package";
  String ids = "";
  Future<void> readService(id) async {
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectservice&id=" + id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      info = json.decode(response.body);
    });

    setState(() {
      servicename = info[0]["name"];
      proid = info[0]["provider_id"];
      ids = info[0]["service_id"];
      rate = info[0]["rate"];
      desc = info[0]["description"];
      category = info[0]["category"];
      days = info[0]["available_day"];
      hours = info[0]["available_start"] + " to " + info[0]["available_end"];
      location = info[0]["location"];
      by = info[0]["rate_by"];
    });

    readPackage(ids);
  }

  List servicelist = [];
  List numbers = [];
  String packagelist = "";
  double max = 0;
  double min = 0;
  Future<void> readPackage(b) async {

    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectpackage&id=" + b),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      servicelist = json.decode(response.body);
    });

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
    this.readNoti();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  List<Widget> _package = [];

  void _packagename(a){
    _package =
    List.from(_package)
      ..add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(MaterialCommunityIcons.arrow_right, color: Color(0xFF0A79DF)),
            10.width,
            Text(
              a,
              style: boldTextStyle(size: 15),
              maxLines: 2,
            ),
            25.height,
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: appStore.appBarColor,
                title: appBarTitleWidget(context, 'Notifications'),
              ),
              body: Container(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                date,
                                style: TextStyle(
                                    fontSize: 10
                                ),
                              ),
                              Text(
                                subject,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900
                                ),
                              ),
                              20.height,
                              Text(
                                message,
                                maxLines: 20,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        10.height,
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Divider(height: 16),
                        ),
                        17.height,
                        (follows[0]["attachment"] != "")
                        ? Container(
                          margin: EdgeInsets.only(left: 10, right: 10, bottom: 16),
                          decoration: BoxDecoration(
                              boxShadow: defaultBoxShadow(),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: IntrinsicHeight(
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JTServiceDetailScreen(
                                        id: ids,
                                        page: "notifications",
                                      )),
                                );
                              },
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: appStore.scaffoldBackground,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Colors.indigoAccent,
                                                Colors.purpleAccent,
                                              ],
                                            )
                                        ),
                                        width: 10),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                CachedNetworkImage(
                                                  placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                                                  imageUrl: image + img,
                                                  width: width / 5,
                                                  height: 100,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 16),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(servicename, style: boldTextStyle(color: appStore.textPrimaryColor), maxLines: 2),
                                                        Text(provider, style: primaryTextStyle(size: 16, color: appStore.textSecondaryColor)),
                                                        DisplayRate(id: ids,rate: info[0]["rate"]),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 16),
                                            Text(desc, style: primaryTextStyle(size: 16, color: appStore.textSecondaryColor), maxLines: 2),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ) : Container(),
                        (follows[0]["attachment"] != "")
                        ? Container(
                            child: Image.network(
                              mobile + "resized/newsletter.jpg",
                              width: context.width() * 0.70,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Container(
                          child: Image.network(
                            mobile + "resized/ratings.jpg",
                            width: context.width() * 0.70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
            )));
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
    print("ayam");
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
            : JTpriceWidget(min),
      ],
    );
  }
}