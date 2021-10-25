import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/Banking/utils/BankingContants.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:prokit_flutter/theme3/model/T3_Model.dart';
import 'package:prokit_flutter/theme3/screen/T3Listing.dart';
import 'package:prokit_flutter/theme3/utils/T3DataGenerator.dart';
import 'package:prokit_flutter/theme3/utils/T3Images.dart';
import 'package:prokit_flutter/theme3/utils/colors.dart';
import 'package:prokit_flutter/theme3/utils/strings.dart';

import '../../../../main.dart';
import 'JTResultScreen.dart';


class JTMatchingScreen1 extends StatefulWidget {
  static var tag = "/JTMatchingScreen1";

  @override
  JTMatchingScreen1State createState() => JTMatchingScreen1State();
}

class JTMatchingScreen1State extends State<JTMatchingScreen1> {

  List emo = ["happy","neutral","sad"];
  List num = [];

  Future<void> random1() async {
    Random rnd;
    int min = 1;
    int max = 20;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("ayam=" + r.toString());
    num.add(r.toString());
    random2();
  }

  Future<void> random2() async {
    Random rnd;
    int min = 1;
    int max = 20;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("itik=" + r.toString());
    if(num.any((item) => item.contains(r.toString()))){
      random2();
    }
    else{
      num.add(r.toString());
      random3();
    }
  }

  Future<void> random3() async {
    Random rnd;
    int min = 1;
    int max = 20;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("gajah=" + r.toString());
    if(num.any((item) => item.contains(r.toString()))){
      random3();
    }
    else{
      num.add(r.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    random1();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    return Scaffold(
      appBar: appBar(context, 'Daily Job Matching'),
      backgroundColor: appStore.scaffoldBackground,
      body: SafeArea(
        child: Observer(
          builder: (_) => Container(
            color: appStore.scaffoldBackground,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(17),
                  child: Column(
                    children: [
                      Text("NO IDEA OF SEARCHING \nTHE RIGHT JOB FOR YOU?", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.black87, fontFamily: "Bold"), maxLines: 3),
                      Text("\nUse this tool to assist you! Pick an image you can relate to your personality or your mood today.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.black54), maxLines: 3),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                            ),
                            boxShadow: defaultBoxShadow(),
                            color: appStore.scaffoldBackground
                        ),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ClipRRect(
                                  child: CachedNetworkImage(
                                    placeholder: (_, s) => placeholderWidget(),
                                    imageUrl: "https://jobtune.ai/gig/JobTune/assets/emo/"+emo[index]+"/"+emo[index]+" ("+num[index]+").jpg",
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: t3_white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0))),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: <Color>[t3_colorPrimary, t3_colorPrimaryDark]),
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(18.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Next",
                                              style: TextStyle(fontSize: 18),
                                              textAlign: TextAlign.center,
                                            ),
                                            7.width,
                                            Icon(
                                              Icons.double_arrow,
                                              size: 18
                                            ),
                                          ],
                                        )
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    var arr;
                                    print(num);
                                    for(var m=0; m<num.length; m++){
                                      if(m == 0){
                                        arr = num[0];
                                      }
                                      else{
                                        arr = arr + "," + num[m];
                                      }
                                    }

                                    if(emo[index] == "sad"){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTMatchingScreen2(
                                              id: "1",
                                              seq: arr
                                            )),
                                      );
                                    }
                                    if(emo[index] == "neutral"){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTMatchingScreen2(
                                                id: "2",
                                                seq: arr
                                            )),
                                      );
                                    }
                                    if(emo[index] == "happy"){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTMatchingScreen2(
                                                id: "3",
                                                seq: arr
                                            )),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class JTMatchingScreen2 extends StatefulWidget {
  static var tag = "/JTMatchingScreen2";

  const JTMatchingScreen2({
    Key? key,
    required this.id,
    required this.seq
  }) : super(key: key);
  final String id;
  final String seq;

  @override
  JTMatchingScreen2State createState() => JTMatchingScreen2State();
}

class JTMatchingScreen2State extends State<JTMatchingScreen2> {

  List emo = ["sad","happy","neutral"];
  List num = [];
  List newnum = [];

  Future<void> random1() async {
    Random rnd;
    int min = 1;
    int max = 20;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("ayam=" + r.toString());
    num.add(r.toString());
    random2();
  }

  Future<void> random2() async {
    Random rnd;
    int min = 1;
    int max = 20;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("itik=" + r.toString());
    if(num.any((item) => item.contains(r.toString()))){
      random2();
    }
    else{
      num.add(r.toString());
      random3();
    }
  }

  Future<void> random3() async {
    Random rnd;
    int min = 1;
    int max = 20;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("gajah=" + r.toString());
    if(num.any((item) => item.contains(r.toString()))){
      random3();
    }
    else{
      num.add(r.toString());
      newnum = num;
      print(newnum);
      newnum.remove(newnum[0]);
      newnum.remove(newnum[0]);
      newnum.remove(newnum[0]);
      print(newnum);
    }
  }

  @override
  void initState() {
    super.initState();
    var prev = widget.seq;
    num = prev.split(",");
    random1();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    return Scaffold(
      appBar: appBar(context, 'Daily Job Matching'),
      backgroundColor: appStore.scaffoldBackground,
      body: SafeArea(
        child: Observer(
          builder: (_) => Container(
            color: appStore.scaffoldBackground,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(17),
                  child: Text("Pick an image you can relate to your personality or your mood today.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.black54), maxLines: 3),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            boxShadow: defaultBoxShadow(),
                            color: appStore.scaffoldBackground
                        ),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ClipRRect(
                                  child: CachedNetworkImage(
                                    placeholder: (_, s) => placeholderWidget(),
                                    imageUrl: "https://jobtune.ai/gig/JobTune/assets/emo/"+emo[index]+"/"+emo[index]+" ("+newnum[index]+").jpg",
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: t3_white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0))),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: <Color>[t3_colorPrimary, t3_colorPrimaryDark]),
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Next",
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.center,
                                              ),
                                              7.width,
                                              Icon(
                                                  Icons.double_arrow,
                                                  size: 18
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    var arr;
                                    for(var m=0; m<num.length; m++){
                                      if(m == 0){
                                        arr = num[0];
                                      }
                                      else{
                                        arr = arr + "," + num[m];
                                      }
                                    }

                                    if(emo[index] == "sad"){
                                      var total = int.parse(widget.id) + 1;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTMatchingScreen3(
                                                id: total.toString(),
                                                seq: arr
                                            )),
                                      );
                                    }
                                    if(emo[index] == "neutral"){
                                      var total = int.parse(widget.id) + 2;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTMatchingScreen3(
                                                id: total.toString(),
                                                seq: arr
                                            )),
                                      );
                                    }
                                    if(emo[index] == "happy"){
                                      var total = int.parse(widget.id) + 3;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTMatchingScreen3(
                                                id: total.toString(),
                                                seq: arr
                                            )),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class JTMatchingScreen3 extends StatefulWidget {
  static var tag = "/JTMatchingScreen3";

  const JTMatchingScreen3({
    Key? key,
    required this.id,
    required this.seq
  }) : super(key: key);
  final String id;
  final String seq;

  @override
  JTMatchingScreen3State createState() => JTMatchingScreen3State();
}

class JTMatchingScreen3State extends State<JTMatchingScreen3> {

  List emo = ["neutral","sad","happy"];
  List num = [];
  List newnum = [];

  Future<void> random1() async {
    Random rnd;
    int min = 1;
    int max = 20;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("ayam=" + r.toString());
    num.add(r.toString());
    random2();
  }

  Future<void> random2() async {
    Random rnd;
    int min = 1;
    int max = 20;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("itik=" + r.toString());
    if(num.any((item) => item.contains(r.toString()))){
      random2();
    }
    else{
      num.add(r.toString());
      random3();
    }
  }

  Future<void> random3() async {
    Random rnd;
    int min = 1;
    int max = 20;
    rnd = new Random();
    var r = min + rnd.nextInt(max - min);
    print("gajah=" + r.toString());
    if(num.any((item) => item.contains(r.toString()))){
      random3();
    }
    else{
      num.add(r.toString());
      newnum = num;
      newnum.remove(newnum[0]);
      newnum.remove(newnum[0]);
      newnum.remove(newnum[0]);
      print(newnum);
    }
  }

  @override
  void initState() {
    super.initState();
    var prev = widget.seq;
    num = prev.split(",");
    random1();
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(appStore.appBarColor!);
    return Scaffold(
      appBar: appBar(context, 'Daily Job Matching'),
      backgroundColor: appStore.scaffoldBackground,
      body: SafeArea(
        child: Observer(
          builder: (_) => Container(
            color: appStore.scaffoldBackground,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(17),
                  child: Text("Pick an image you can relate to your personality or your mood today.", textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54), maxLines: 3),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            boxShadow: defaultBoxShadow(),
                            color: appStore.scaffoldBackground
                        ),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ClipRRect(
                                  child: CachedNetworkImage(
                                    placeholder: (_, s) => placeholderWidget(),
                                    imageUrl: "https://jobtune.ai/gig/JobTune/assets/emo/"+emo[index]+"/"+emo[index]+" ("+newnum[index]+").jpg",
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: t3_white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0))),
                                    padding: EdgeInsets.all(0.0),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: <Color>[t3_colorPrimary, t3_colorPrimaryDark]),
                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Next",
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.center,
                                              ),
                                              7.width,
                                              Icon(
                                                  Icons.double_arrow,
                                                  size: 18
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if(emo[index] == "sad"){
                                      var total = int.parse(widget.id) + 1;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTResultScreen(
                                                id: total.toString(),
                                            )),
                                      );
                                    }
                                    if(emo[index] == "neutral"){
                                      var total = int.parse(widget.id) + 2;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTResultScreen(
                                                id: total.toString(),
                                            )),
                                      );
                                    }
                                    if(emo[index] == "happy"){
                                      var total = int.parse(widget.id) + 3;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => JTResultScreen(
                                                id: total.toString(),
                                            )),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}