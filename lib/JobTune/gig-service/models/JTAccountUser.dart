import 'package:flutter/material.dart';
import 'package:prokit_flutter/theme4/utils/T4Colors.dart';
import 'package:prokit_flutter/theme4/utils/T4Images.dart';

class AccountModel {
  var name = "";
  var image = "";
  var info = "";
  var category = "";
  var otherinfo = "";
  Color? color;
}

List<AccountModel> getData() {
  List<AccountModel> list = [];
  var model1 = AccountModel();
  model1.name = "Life speed racered";
  model1.info = "7th aug- 3 min read";
  model1.image = t4_img9;
  model1.otherinfo = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.dummy text of the printing and typesetting";

  var model2 = AccountModel();
  model2.name = "Move the world";
  model2.info = "7th aug- 3 min read";
  model2.image = t4_img8;
  model2.otherinfo = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.dummy text of the printing and typesetting";

  var model3 = AccountModel();
  model3.name = "Piece of Pie";
  model3.info = "7th aug- 3 min read";
  model3.image = t4_img6;
  model3.otherinfo = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.dummy text of the printing and typesetting";

  var model4 = AccountModel();
  model4.name = "The Addams Family";
  model4.info = "7th aug- 3 min read";
  model4.image = t4_img5;
  model4.otherinfo = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.dummy text of the printing and typesetting";

  var model5 = AccountModel();
  model5.name = "Life speed racered";
  model5.info = "7th aug- 3 min read";
  model5.image = t4_img2;
  model5.otherinfo = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.dummy text of the printing and typesetting";

  list.add(model1);
  list.add(model3);
  list.add(model2);
  list.add(model4);
  list.add(model5);
  list.add(model5);
  list.add(model1);
  list.add(model3);
  list.add(model2);
  list.add(model4);
  list.add(model5);
  list.add(model5);
  return list;
}

List<AccountModel> getCategoryData() {
  List<AccountModel> list = [];
  var model1 = AccountModel();
  model1.category = "World";
  model1.color = t4_cat1;

  var model2 = AccountModel();
  model2.category = "Politics";
  model2.color = t4_cat2;
  var model3 = AccountModel();
  model3.category = "Tech";
  model3.color = t4_cat3;
  var model4 = AccountModel();
  model4.category = "Sports";
  model4.color = t4_cat4;
  var model5 = AccountModel();
  model5.category = "Science";
  model5.color = t4_cat5;

  list.add(model1);
  list.add(model2);
  list.add(model3);
  list.add(model4);
  list.add(model5);
  list.add(model1);
  list.add(model2);
  list.add(model3);
  list.add(model4);
  list.add(model5);
  return list;
}

List<AccountModel> getList2Data() {
  List<AccountModel> list = [];
  var model1 = AccountModel();
  model1.name = "Life speed racered";
  model1.info = "7th aug- 3 min read";
  model1.image = t4_img8;

  var model2 = AccountModel();
  model2.name = "Life speed racered";
  model2.info = "7th aug- 3 min read";
  model2.image = t4_img10;

  var model3 = AccountModel();
  model3.name = "Life speed racered";
  model3.info = "7th aug- 3 min read";
  model3.image = t4_img5;

  list.add(model2);
  list.add(model3);
  list.add(model1);
  list.add(model2);
  list.add(model3);
  list.add(model1);
  list.add(model2);
  list.add(model3);
  list.add(model1);
  return list;
}

List<AccountModel> getDashboardData() {
  List<AccountModel> list = [];
  var model1 = AccountModel();
  model1.name = "Life speed racered";
  model1.info = "7th aug- 3 min read";
  model1.image = t4_img2;

  var model2 = AccountModel();
  model2.name = "Life speed racered";
  model2.info = "7th aug- 3 min read";
  model2.image = t4_img1;

  var model3 = AccountModel();
  model3.name = "Life speed racered";
  model3.info = "7th aug- 3 min read";
  model3.image = t4_img_3;

  var model4 = AccountModel();
  model4.name = "Life speed racered";
  model4.info = "7th aug- 3 min read";
  model4.image = t4_img5;

  var model5 = AccountModel();
  model5.name = "Life speed racered";
  model5.info = "7th aug- 3 min read";
  model5.image = t4_img6;

  var model6 = AccountModel();
  model6.name = "Life speed racered";
  model6.info = "7th aug- 3 min read";
  model6.image = t4_img4;

  list.add(model1);
  list.add(model2);
  list.add(model3);
  list.add(model4);
  list.add(model6);
  list.add(model5);
  list.add(model1);
  list.add(model2);
  list.add(model3);
  list.add(model4);
  list.add(model6);
  list.add(model5);
  list.add(model1);
  list.add(model2);
  list.add(model3);
  list.add(model4);
  list.add(model6);
  list.add(model5);
  return list;
}