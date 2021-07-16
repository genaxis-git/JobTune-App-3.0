import 'package:flutter/material.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/theme5/utils/T5Images.dart';

class SpendingModel {
  var name;
  var day;
  var date;
  var isPaid = false;
  late var icon;
  var amount;
  var wallet = "Mastercard";
}

List<SpendingModel> getBillData() {
  List<SpendingModel> list = [];
  var bill = SpendingModel();
  bill.name = "Electric wiring";
  bill.day = "22";
  bill.icon = "images/dashboard/db2_decor1.jpeg";
  bill.amount = "\RM 155.00";
  bill.date = "10/2/2019";

  list.add(bill);

  var bill1 = SpendingModel();
  bill1.name = "Lawn Mow 1 hour";
  bill1.day = "20";
  bill1.icon = "images/dashboard/ic_chair2.jpg";
  bill1.amount = "\RM 855.00";
  bill1.date = "10/2/2019";

  list.add(bill1);

  var bill2 = SpendingModel();
  bill2.name = "Math Tutoring at home";
  bill2.day = "12";
  bill2.icon = "images/dashboard/db_profile.jpeg";
  bill2.amount = "\RM 155.00";
  bill2.isPaid = true;
  bill2.date = "10/2/2019";

  list.add(bill2);

  var bill3 = SpendingModel();
  bill3.name = "Hair Treatment";
  bill3.day = "12";
  bill3.icon = "images/dashboard/db_restau_4.jpeg";
  bill3.amount = "\RM 25.00";
  bill3.date = "10/2/2019";

  list.add(bill3);

  var bill4 = SpendingModel();
  bill4.name = "Runner pemindahan barang";
  bill4.day = "11";
  bill4.icon = "images/dashboard/db2_item3.jpg";
  bill4.amount = "\RM 70.00";
  bill4.date = "10/2/2019";

  list.add(bill4);
  var bill5 = SpendingModel();
  bill5.name = "Food delivery";
  bill5.day = "10";
  bill5.icon = "images/dashboard/db_restau_4.jpeg";
  bill5.amount = "\RM 600.00";
  bill5.date = "10/2/2019";
  bill5.isPaid = true;
  list.add(bill);
  list.add(bill2);
  list.add(bill);
  list.add(bill);
  list.add(bill1);
  list.add(bill2);
  list.add(bill3);
  list.add(bill4);
  list.add(bill);
  list.add(bill1);
  list.add(bill2);
  list.add(bill3);
  list.add(bill4);

  return list;
}