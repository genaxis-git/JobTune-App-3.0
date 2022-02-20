import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/Banking/utils/BankingContants.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/profile/JTProfileWidgetUser.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/theme10/utils/T10Colors.dart';
import 'package:prokit_flutter/theme8/model/T8Models.dart';
import 'package:prokit_flutter/theme8/utils/T8Colors.dart';
import 'package:prokit_flutter/theme8/utils/T8Constant.dart';
import 'package:prokit_flutter/theme8/utils/T8DataGenerator.dart';
import 'package:prokit_flutter/theme8/utils/T8Strings.dart';
import 'package:prokit_flutter/theme8/utils/T8Widget.dart';

import '../../../../main.dart';
import 'JTPageScreen.dart';


class JTServiceTagScreen extends StatefulWidget {
  static String tag = '/JTServiceTagScreen';

  const JTServiceTagScreen({
    Key? key,
    required this.id,
    required this.provider
  }) : super(key: key);
  final String id;
  final String provider;

  @override
  JTServiceTagScreenState createState() => JTServiceTagScreenState();
}

class JTServiceTagScreenState extends State<JTServiceTagScreen> {
  late var width;

  // starts function //

  List servicelist = [];
  Future<void> checkFeatured() async {
    print(server + "jtnew_provider_selectserviceforpage&id="+widget.provider);
    http.Response response = await http.get(
        Uri.parse(
            server + "jtnew_provider_selectserviceforpage&id="+widget.provider
        ),
        headers: {"Accept": "application/json"});

    this.setState(() {
      servicelist = json.decode(response.body);
    });

  }

  // ends function //

  @override
  void initState() {
    super.initState();
    this.checkFeatured();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: appStore.appBarColor,
        title: jtprofile_appBarTitleWidget(context, widget.id),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(
                context,
              );
            }
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            15.height,
            ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: servicelist == null ? 0 : servicelist.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if(servicelist[index]["category"] == widget.id){
                    return InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JTServiceDetailScreen(
                                    id: servicelist[index]["service_id"],
                                    page: "provider-page"
                                )),
                          );
                        },
                        child: Container(
                            margin: EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new, bottom: spacing_standard_new),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(spacing_middle)),
                                        child: CachedNetworkImage(
                                          placeholder: placeholderWidgetFn() as Widget Function(BuildContext, String)?,
                                          imageUrl: image + servicelist[index]["profile_pic"],
                                          fit: BoxFit.cover,
                                          height: width * 0.2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: spacing_standard_new,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(servicelist[index]["name"],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: appStore.textSecondaryColor
                                              )
                                          ),
                                          Text(servicelist[index]["category"],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                  color: appStore.textSecondaryColor,
                                                  fontSize: 17
                                              )
                                          ),
                                          3.height,
                                          // DisplayRating(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                                          13.height,
                                          DisplayRate(id: servicelist[index]["service_id"],rate: servicelist[index]["rate"]),
                                          5.height,
                                          Text(servicelist[index]["location"], style: secondaryTextStyle(size: 13)),
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: <Widget>[
                                          //     Row(
                                          //       children: <Widget>[
                                          //         text(model.price, textColor: appStore.textSecondaryColor),
                                          //         SizedBox(width: spacing_control),
                                          //         text(model.subPrice, textColor: appStore.textSecondaryColor, lineThrough: true),
                                          //       ],
                                          //     ),
                                          //     Row(
                                          //       children: <Widget>[
                                          //         Icon(Icons.remove_circle, color: t10_textColorSecondary, size: 20),
                                          //         SizedBox(width: 4),
                                          //         text("2", textColor: appStore.textSecondaryColor, fontFamily: fontMedium, fontSize: textSizeLargeMedium),
                                          //         SizedBox(width: 4),
                                          //         Icon(Icons.add_circle, color: t10_textColorSecondary, size: 20)
                                          //       ],
                                          //     )
                                          //   ],
                                          // )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: spacing_standard_new),
                                Divider(color: t10_view_color, height: 0.5)
                              ],
                            ))
                    );
                  }
                  else{
                    return Container();
                  }
                })
          ],
        ),
      ),
    );
  }
}
