import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';


class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List indexlist = [];

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String user = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            'http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_sortservice&id=' + user),
        headers: {"Accept": "application/json"});


    this.setState(() {
      indexlist = json.decode(response.body);
    });
  }
  @override
  void initState() {
    super.initState();
    this.getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Service"),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: (indexlist.length > 0)
          ? (indexlist.length == 1)
          ? (indexlist[0]["service_id"] != null)
          ? ServiceList()
          : ListView()
          : ServiceList()
          : null,
    );
  }
}

class ServiceList extends StatefulWidget {
  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  List indexlist = [];
  List newlist = [];
  List rates = [];
  String empid = "";
  String sharedType ="";
  String carry ="";
  List arr = [];
  List price = [];
  String smallest="";

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String user = prefs.getString('email').toString();

    http.Response response = await http.get(
        Uri.parse(
            'http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_sortservice&id=' + user),
        headers: {"Accept": "application/json"});


    this.setState(() {
      indexlist = json.decode(response.body);
    });
  }

  Future<void> deletejob(a) async {
    http.get(
        Uri.parse(
            'http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_updatedeactive&id=' + a),
        headers: {"Accept": "application/json"});
  }

  Future<void> addjob(a) async {
    http.get(
        Uri.parse(
            'http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_updateactive&id=' + a),
        headers: {"Accept": "application/json"});
  }

  Future<void> getinfo(a) async {
    http.Response response = await http.get(
        Uri.parse(
            'http://jobtune-dev.my1.cloudapp.myiacloud.com/REST/API/index.php?interface=jtnew_provider_selectservice&id=' + a),
        headers: {"Accept": "application/json"});


    this.setState(() {
      newlist = json.decode(response.body);
    });


  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    final deviceData = MediaQuery.of(context).size;
    var fontScaling = MediaQuery.of(context).textScaleFactor;
    print(deviceData);
    return ListView.builder(
      itemCount: indexlist == null ? 0 : indexlist.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => JTServiceDetailScreen(
                  id: indexlist[index]["service_id"]
              )),
            );
          },
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(9.0, 10.0, 7.0, 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: deviceData.width/30,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: deviceData.width - 175,
                                child: Text( indexlist[index]["name"],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              (indexlist[index]["rate"] != "undefined" || indexlist[index]["rate"] != "0.00")
                                  ? (double.parse(indexlist[index]["rate"]) > 100) ? Container(width: 0,) :  Container(width: 10,)
                                  : Container(),
                              (indexlist[index]["rate"] != "undefined" || indexlist[index]["rate"] != "0.00")
                                  ? Column(
                                children: <Widget>[
                                  (double.parse(indexlist[index]["rate"]) > 100)
                                      ? Text( ">RM 100.00",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.green,
                                    ),
                                  )
                                      : Text( "RM " + double.parse(indexlist[index]["rate"]).toStringAsFixed(2).toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    'per hour',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13
                                    ),
                                  ),
                                ],
                              )
                                  : displayRate(id:indexlist[index]["service_id"]),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            width: deviceData.width/1.7,
                            child: Text( indexlist[index]["available_day"],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: LiteRollingSwitch(
                                  value: (indexlist[index]["status"]=="1") ? true : false,
                                  textOn: 'active',
                                  textOff: 'inactive',
                                  colorOn: Colors.greenAccent,
                                  colorOff: Colors.blueGrey,
                                  iconOn: Icons.lightbulb_outline,
                                  iconOff: Icons.power_settings_new,
                                  onChanged: (bool state) {
                                    print(state);
                                    if(state == false){
                                      deletejob(indexlist[index]["service_id"]);
                                    }
                                    else{
                                      addjob(indexlist[index]["service_id"]);
                                    }
                                  },
                                ),
                              )
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class displayRate extends StatefulWidget {
  const displayRate({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _displayRateState createState() => _displayRateState();
}

class _displayRateState extends State<displayRate> {
  List servicelist = [];
  List numbers = [];
  String packagelist = "";
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
  Widget build(BuildContext context) {
    readPackage();
    return Column(
      children: <Widget>[
        (min == max)
            ? Text(
          "RM " + min.toStringAsFixed(2),
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w900,
            color: Colors.green,
          ),
        )
            : Text(
          "RM " + min.toStringAsFixed(2) + "\n to \n" + "RM " + max.toStringAsFixed(2),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w900,
            color: Colors.green,
          ),

        ),
        Text(
          'per package',
          style: TextStyle(
              color: Colors.grey,
              fontSize: 13
          ),
        ),
      ],
    );
  }
}