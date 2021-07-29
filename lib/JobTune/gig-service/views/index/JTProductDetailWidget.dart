import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JTCustomTheme extends StatelessWidget {
  final Widget? child;

  JTCustomTheme({required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appStore.isDarkModeOn
          ? ThemeData.dark().copyWith(
        accentColor: Color(0xFF0A79DF),
        backgroundColor: appStore.scaffoldBackground,
      )
          : ThemeData.light(),
      child: child!,
    );
  }
}

class JTContainerX extends StatelessWidget {
  final Widget? mobile;
  final Widget? web;
  final bool? useFullWidth;

  JTContainerX({this.mobile, this.web, this.useFullWidth});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.device == DeviceSize.mobile) {
          return mobile ?? SizedBox();
        } else {
          return Container(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: useFullWidth.validate() ? null : JTdynamicBoxConstraints(maxWidth: context.width() * 0.9),
              child: web ?? SizedBox(),
            ),
          );
        }
      },
    );
  }
}

Widget JTsettingItem(context, String text, {Function? onTap, Widget? detail, Widget? leading, Color? textColor, int? textSize, double? padding}) {
  return InkWell(
    onTap: onTap as void Function()?,
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: padding ?? 8, bottom: padding ?? 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(child: leading ?? SizedBox(), width: 30, alignment: Alignment.center),
              leading != null ? 10.width : SizedBox(),
              Text(text, style: primaryTextStyle(size: textSize ?? 18, color: textColor ?? appStore.textPrimaryColor)).expand(),
            ],
          ).expand(),
          detail ?? Icon(Icons.arrow_forward_ios, size: 16, color: appStore.textSecondaryColor),
        ],
      ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
    ),
  );
}

Widget JTpriceWidget(double? price, {bool applyStrike = false, double? fontSize, Color? textColor}) {
  return Text(
    applyStrike ? '$price' : '\RM $price',
    style: TextStyle(
      decoration: applyStrike ? TextDecoration.lineThrough : TextDecoration.none,
      color: textColor != null
          ? textColor
          : applyStrike
          ? appStore.textSecondaryColor
          : appStore.textPrimaryColor,
      fontSize: fontSize != null
          ? fontSize
          : applyStrike
          ? 15
          : 18,
      fontWeight: FontWeight.bold,
    ),
  );
}

BoxDecoration JTboxDecoration({double radius = 2, Color color = Colors.transparent, Color? bgColor, var showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? appStore.scaffoldBackground,
    boxShadow: showShadow ? defaultBoxShadow(shadowColor: shadowColorGlobal) : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

AppBar JTappBar(BuildContext context, String title, {List<Widget>? actions, bool showBack = true, Color? color, Color? iconColor, Color? textColor}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: color ?? appStore.appBarColor,
    leading: showBack
        ? IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back, color: appStore.isDarkModeOn ? white : black),
          )
        : null,
    title: JTappBarTitleWidget(context, title, textColor: textColor, color: color),
    actions: actions,
  );
}

Widget JTappBarTitleWidget(context, String title, {Color? color, Color? textColor}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 60,
    color: color ?? appStore.appBarColor,
    child: Row(
      children: <Widget>[
        Text(
          title,
          style: boldTextStyle(color: color ?? appStore.textPrimaryColor, size: 20),
          maxLines: 1,
        ).expand(),
      ],
    ),
  );
}

BoxConstraints JTdynamicBoxConstraints({double? maxWidth}) {
  return BoxConstraints(maxWidth: maxWidth ?? 500.0);
}