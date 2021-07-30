import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';


class WebviewPayment extends StatefulWidget {
  var postid;
  var nilaidb;
  var fullname;
  var email;
  var telno;
  var platformdb;
  var proid;
  var empid;
  var emprid;
  var timein;
  var date;
  var address;
  var describe;
  var timeout;
  var input;
  var service;
  var proname;
  var hr;
  var emailid;
  var protel;
  var package;
  var insurancedb;
  var adminfeedb;

  WebviewPayment({
    this.postid, this.nilaidb, this.fullname, this.email, this.telno, this.platformdb, this.proid, this.empid, this.emprid, this.timein, this.date, this.address, this.describe,
    this.timeout, this.input, this.service, this.proname, this.hr, this.emailid, this.protel, this.package, this.insurancedb, this.adminfeedb,
  });

  @override
  _WebviewPaymentState createState() => _WebviewPaymentState();
}

class _WebviewPaymentState extends State<WebviewPayment> {
//  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Payment"),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: WebView(

          initialUrl: 'https://jobtune.ai/gig/JobTune/Provider/checkoutSenangPayMobile.php?name='+widget.fullname+'&package='+widget.package+'&email='+widget.email+'&phone='+widget.telno+'&amount='+widget.nilaidb+
          '&detail='+widget.postid+'&proid='+widget.proid+'&jempid='+widget.empid+'&jemprid='+widget.emprid+'&timein='+widget.timein+'&timeout='+widget.timeout+'&dayin='+widget.date+
          '&dayout='+widget.date+'&address='+widget.address+'&desc='+widget.describe+'&user_id='+widget.input+'&platformfee='+widget.platformdb+'&servicename='+widget.service+
          '&proname='+widget.proname+'&hours='+widget.hr+'&proemail='+widget.emailid+'&protel='+widget.protel+'&insurance='+widget.insurancedb+'&adminfee='+widget.adminfeedb,

          onWebViewCreated: (WebViewController webViewController) {
//            _controller = webViewController;
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (request) {
            if (request.url.contains('&status_id=1')) {
              final String paymentMessage = 'Your booking is confirmed!';
              _closeWebview(paymentMessage);
            } else if (request.url.contains('&status_id=0')) {
              final String paymentMessage = 'Your payment was not successful!';
              _closeWebview(paymentMessage);
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  _closeWebview(paymentMessage){
//    Navigator.of(context).push(
//      MaterialPageRoute(
//        builder: (BuildContext context) => ConfirmationScreen(
//          message: paymentMessage,
//        )
//      )
//    );
  }
}

