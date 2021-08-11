import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/model/DTReviewModel.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/flutter_rating_bar.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../../../../main.dart';

class JTReviewWidget extends StatefulWidget {
  const JTReviewWidget({Key? key, required this.id, this.enableScrollPhysics}) : super(key: key);
  final String id;
  final bool? enableScrollPhysics;
  @override
  _JTReviewWidgetState createState() => _JTReviewWidgetState();
}

class _JTReviewWidgetState extends State<JTReviewWidget> {

  // functions starts //

  String totalrating = "0";
  List ratinglist = [];
  Future<void> readTotal() async {
    http.Response response = await http.get(
        Uri.parse(
            "http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_user_selecttotalrate&id=" + widget.id),
        headers: {"Accept": "application/json"}
    );

    this.setState(() {
      ratinglist = json.decode(response.body);
    });
  }

  @override
  void initState() {
    this.readTotal();
    super.initState();
  }

  // function ends //


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 8, top: 16),
      itemCount: ratinglist == null ? 0 : ratinglist.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(16),
          decoration: boxDecorationRoundedWithShadow(8, backgroundColor: appStore.appBarColor!),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Image.network("http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/" + ratinglist[index]["profile_pic"],
                    height: 30, width: 30, fit: BoxFit.cover)
                    .cornerRadiusWithClipRRect(40),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                padding: EdgeInsets.all(1),
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ratinglist[index]["first_name"] + " " + ratinglist[index]["last_name"], style: boldTextStyle()),
                  Row(
                    children: [
                      IgnorePointer(
                        child: RatingBar(
                          onRatingUpdate: (r) {},
                          itemSize: 14.0,
                          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                          initialRating: double.parse(ratinglist[index]["amount"]),
                        ),
                      ),
                      16.width,
                      Text(ratinglist[index]["amount"], style: secondaryTextStyle()),
                    ],
                  ),
                  Text(ratinglist[index]["comment"], style: secondaryTextStyle()),
                  15.height,
                  Text(ratinglist[index]["rating_date"],
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueAccent
                    ),
                  ),
                ],
              ).expand(),
            ],
          ),
        );
      },

      physics: widget.enableScrollPhysics.validate(value: true) ? ScrollPhysics() : NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }
}


Gradient JTdefaultThemeGradient() {
  return LinearGradient(
    colors: [
      appColorPrimary,
      appColorPrimary.withOpacity(0.5),
    ],
    tileMode: TileMode.mirror,
    begin: Alignment.topCenter,
    end: Alignment.bottomLeft,
  );
}

double JTdynamicWidth(BuildContext context) {
  return isMobile ? context.width() : 500.0;
}