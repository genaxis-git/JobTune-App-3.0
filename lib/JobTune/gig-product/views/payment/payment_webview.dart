import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'dart:convert';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

// import 'package:flutterappjobtune/screen/service_detail/service_detail_screen.dart';
// import 'package:flutterappjobtune/screen/service_detail/confirmation_screen.dart';

class WebviewPayment extends StatefulWidget {
  var productid;
  var providerid;
  var clientid;
  var clientlocation;
  var expecteddelivery;
  var clientname;
  var clientphone;
  var totalamount;
  var productname;

  WebviewPayment({
    this.productid,
    this.providerid,
    this.clientid,
    this.clientlocation,
    this.expecteddelivery,
    this.clientname,
    this.clientphone,
    this.totalamount,
    this.productname,
  });

  @override
  _WebviewPaymentState createState() => _WebviewPaymentState();
}

class _WebviewPaymentState extends State<WebviewPayment> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final url =
        'http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/Product/gig-product-checkout.php?postproductid=' +
            widget.productid.toString() +
            '&postproviderid=' +
            widget.providerid.toString() +
            '&postclientid=' +
            widget.clientid.toString() +
            '&postclientlocation=' +
            widget.clientlocation.toString() +
            '&postexpecteddelivery=' +
            widget.expecteddelivery.toString() +
            '&postclientname=' +
            widget.clientname.toString() +
            '&postclientphone=' +
            widget.clientphone.toString() +
            '&posttotalamount=' +
            widget.totalamount.toString() +
            '&postproductname=' +
            widget.productname.toString();

    print(url);
  }

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
          initialUrl:
              'http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/Product/gig-product-checkout-mobile.php?postproductid=' +
                  widget.productid.toString() +
                  '&postproviderid=' +
                  widget.providerid.toString() +
                  '&postclientid=' +
                  widget.clientid.toString() +
                  '&postclientlocation=' +
                  widget.clientlocation.toString() +
                  '&postexpecteddelivery=' +
                  widget.expecteddelivery.toString() +
                  '&postclientname=' +
                  widget.clientname.toString() +
                  '&postclientphone=' +
                  widget.clientphone.toString() +
                  '&posttotalamount=' +
                  widget.totalamount.toString() +
                  '&postproductname=' +
                  widget.productname.toString(),
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
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

  _closeWebview(paymentMessage) {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) => ConfirmationScreen(
    //           message: paymentMessage,
    //         )));
    Navigator.pop(context);
    Navigator.pop(context);
    toast(paymentMessage);
  }
}
