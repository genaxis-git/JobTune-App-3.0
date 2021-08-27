import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewTimetableProvider extends StatefulWidget {
  const WebViewTimetableProvider({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  _WebViewTimetableProviderState createState() => _WebViewTimetableProviderState();
}

class _WebViewTimetableProviderState extends State<WebViewTimetableProvider> {
  WebViewController? _controller;
  @override
  void initState() {
    super.initState();
    EasyLoading.showToast('Loading..');
  }

  @override
  Widget build(BuildContext context) {
    print('https://jobtune.ai/gig/JobTune/jobtune-employee-timetable.html?key='+widget.id);
    EasyLoading.showToast('Loading..');
    var newsize = MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height - 22.5);
    return Container(
      padding: EdgeInsets.fromLTRB(0,newsize,0,0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Our Schedule",style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        body: FlutterEasyLoading(
          child: ListView(
            children: [
              Container(
                height: 1200,
                child: WebView(
                  initialUrl: 'https://jobtune.ai/gig/JobTune/jobtune-employee-timetable.html?key='+widget.id,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController c) {
                    _controller = c;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}