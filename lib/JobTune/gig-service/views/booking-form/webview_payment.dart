import 'package:flutter/material.dart';
import 'package:prokit_flutter/JobTune/constructor/server.dart';
import 'dart:convert';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

import 'JTConfirmationScreen.dart';


class WebviewPayment extends StatefulWidget {
  var postid;
  var clientid;
  var starts;
  var ends;
  var quantity;
  var address;
  var desc;
  var type;
  var total;

  var packname;
  var username;
  var teluser;
  var proname;
  var proemail;
  var protel;
  var servicename;

  WebviewPayment({
    this.postid,
    this.clientid,
    this.starts,
    this.ends,
    this.quantity,
    this.address,
    this.desc,
    this.type,
    this.total,
    this.packname,
    this.username,
    this.teluser,
    this.proname,
    this.proemail,
    this.protel,
    this.servicename,
  });

  @override
  _WebviewPaymentState createState() => _WebviewPaymentState();
}

class _WebviewPaymentState extends State<WebviewPayment> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Checkout Information"),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: WebView(

          initialUrl: servicePayments + 'name='+widget.username+
          '&package='+widget.packname+'&email='+widget.clientid+'&phone='+widget.teluser+'&amount='+widget.total+
          '&detail='+widget.postid+'&proid='+widget.proemail+'&jempid=&jemprid=&timein='+widget.starts+'&timeout='+widget.ends+
          '&dayin=&dayout=&address='+widget.address+'&desc='+widget.desc+'&user_id='+widget.clientid+'&platformfee=&servicename='+widget.servicename+
          '&proname='+widget.proname+'&hours='+widget.quantity+'&proemail='+widget.proemail+'&protel='+widget.protel+'&insurance=&adminfee=',

          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (request) {
            if (request.url.contains('&status_id=1')) {
              final String paymentMessage = 'Your booking is confirmed!';
              _closeWebview(paymentMessage,widget.postid);
            } else if (request.url.contains('&status_id=0')) {
              final String paymentMessage = 'Your payment was not successful!';
              _closeWebview(paymentMessage,widget.postid);
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  _closeWebview(paymentMessage,id){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ConfirmationScreen(
          message: paymentMessage,
          id: id,
        )
      )
    );
  }
}

