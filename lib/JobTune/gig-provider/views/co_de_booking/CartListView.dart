import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/defaultTheme/model/DTProductModel.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTDataProvider.dart';
import 'package:prokit_flutter/defaultTheme/utils/DTWidgets.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';

import 'package:prokit_flutter/defaultTheme/model/DTAddressListModel.dart';

import '../../../../main.dart';
// import 'DTOrderSummaryScreen.dart';
// import 'DTProductDetailScreen.dart';

// ignore: must_be_immutable
class CartListView extends StatefulWidget {
  static String tag = '/CartListView';

  bool? mIsEditable;
  bool? isOrderSummary;

  CartListView({this.mIsEditable, this.isOrderSummary});

  @override
  CartListViewState createState() => CartListViewState();
}

class CartListViewState extends State<CartListView> {
  List<DTProductModel> data = getCartProducts();
  List<DTAddressListModel> list = getAddressList();

  int subTotal = 0;
  int totalAmount = 0;
  int shippingCharges = 0;
  int mainCount = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    calculate();
  }

  calculate() async {
    subTotal = 0;
    shippingCharges = 0;
    totalAmount = 0;

    data.forEach((element) {
      subTotal += (element.discountPrice ?? element.price)! * element.qty!;
    });

    shippingCharges = (subTotal * 10).toInt() ~/ 100;
    totalAmount = subTotal + shippingCharges;

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget itemCart(DTProductModel data, int index) {
      return Container(
        decoration: boxDecorationRoundedWithShadow(8,
            backgroundColor: appStore.appBarColor!),
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              child: Image.asset(
                'images/defaultTheme/walkthrough1.png',
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ).cornerRadiusWithClipRRect(8),
            ),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Kap Kap Shahirah Thai',
                    style: primaryTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                4.height,
                Row(
                  children: [
                    // priceWidget(data.discountPrice),
                    priceWidget(13),
                    8.width,
                    // priceWidget(data.price, applyStrike: true),
                  ],
                ),
                8.height,
                Text('Delivery date : 28/7/2021',
                    style: primaryTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                8.height,
                Row(
                  children: [
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: appColorPrimaryDark,
                      ),
                      padding: EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon(Icons.remove, color: whiteColor).onTap(() {
                          //   var qty = data.qty!;
                          //   if (qty <= 1) return;
                          //   var q = qty - 1;
                          //   data.qty = q;

                          //   calculate();
                          // }),
                          6.width,
                          Text('Accept',
                              style: boldTextStyle(color: whiteColor)),
                          6.width,
                          Icon(Icons.check_rounded, color: whiteColor)
                              .onTap(() {
                            mainCount = data.qty! + 1;
                            data.qty = mainCount;

                            calculate();
                          }),
                        ],
                      ),
                    ).onTap(() async {
                      DTAddressListModel? model = await showInDialog(context,
                          child: AddAddressDialog(),
                          backgroundColor: Colors.transparent,
                          contentPadding: EdgeInsets.all(0));

                      if (model != null) {
                        list.add(model);

                        setState(() {});
                      }
                    }),
                  ],
                ),
              ],
            ).expand(),
          ],
        ),
      );
    }

    Widget cartItemList() {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (_, index) {
          DTProductModel data1 = data[index];

          return itemCart(data1, index).onTap(() {
            // DTProductDetailScreen(productModel: data1).launch(context);
          });
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      );
    }

    return ContainerX(
      mobile: Column(
        children: [
          // totalItemCountWidget(data.length),
          SingleChildScrollView(child: cartItemList()),
          20.height,
          // totalAmountWidget(subTotal, shippingCharges, totalAmount),
        ],
      ),
      web: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: SingleChildScrollView(child: cartItemList()),
          ).expand(flex: 60),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(8),
            decoration: boxDecoration(
                showShadow: true, bgColor: appStore.scaffoldBackground),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                totalAmountWidget(subTotal, shippingCharges, totalAmount)
                    .visible(widget.mIsEditable!),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  decoration: boxDecorationRoundedWithShadow(8,
                      backgroundColor: appColorPrimary),
                  child: Text('Checkout', style: boldTextStyle(color: white)),
                ).onTap(() {
                  // DTOrderSummaryScreen(data).launch(context);
                }).visible(widget.mIsEditable!),
              ],
            ),
          ).expand(flex: 40).visible(!widget.isOrderSummary!),
        ],
      ),
    );
  }
}

class UpdateStatusDialog extends StatefulWidget {
  @override
  _UpdateStatusDialogState createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  List<String> listOfCategory = [
    'Pending',
    'Shipped',
  ];
  String? selectedIndexCategory = 'Pending';
  String? dropdownNames;
  String? dropdownScrollable = 'I';

  var nameCont = TextEditingController();
  var addressLine1Cont = TextEditingController();
  var addressLine2Cont = TextEditingController();
  var typeCont = TextEditingController();
  var mobileCont = TextEditingController();

  var addressLine1Focus = FocusNode();
  var addressLine2Focus = FocusNode();
  var typeFocus = FocusNode();
  var mobileFocus = FocusNode();
  var autoValidate = false;
  var formKey = GlobalKey<FormState>();

  validate() {
    if (formKey.currentState!.validate()) {
      hideKeyboard(context);
      toast('Adding Successfully');
      formKey.currentState!.save();

      var addressData = DTAddressListModel();
      addressData.name = nameCont.text.validate();
      addressData.addressLine1 = addressLine1Cont.text.validate();
      addressData.addressLine2 = addressLine2Cont.text.validate();
      addressData.phoneNo = mobileCont.text.validate();
      addressData.type = 'Office';

      finish(context, addressData);
    } else {
      autoValidate = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: dynamicBoxConstraints(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Update Status', style: boldTextStyle(size: 18)),
                    IconButton(
                      icon: Icon(Icons.close, color: appStore.iconColor),
                      onPressed: () {
                        finish(context);
                      },
                    )
                  ],
                ),
                8.height,
                DropdownButtonFormField(
                  style: primaryTextStyle(),
                  decoration: InputDecoration(
                    // labelText: 'Co-De',
                    contentPadding: EdgeInsets.all(16),
                    labelStyle: secondaryTextStyle(),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: appColorPrimary)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            BorderSide(color: appStore.textSecondaryColor!)),
                  ),
                  isExpanded: true,
                  dropdownColor: appStore.appBarColor,
                  value: selectedIndexCategory,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: appStore.iconColor,
                  ),
                  onChanged: (dynamic newValue) {
                    setState(() {
                      toast(newValue);
                      selectedIndexCategory = newValue;
                    });
                  },
                  items: listOfCategory.map((category) {
                    return DropdownMenuItem(
                      child: Text(category, style: primaryTextStyle())
                          .paddingLeft(8),
                      value: category,
                    );
                  }).toList(),
                ),
                16.height,
                GestureDetector(
                  onTap: () {
                    validate();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: appColorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Center(
                      child: Text("Submit", style: boldTextStyle(color: white)),
                    ),
                  ),
                ),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddAddressDialog extends StatefulWidget {
  @override
  _AddAddressDialogState createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  List<String> listOfCategory = [
    'Co-De',
    'It',
    'Computer Science',
    'Business',
    'Data Science',
    'Infromation Technologies',
    'Health',
    'Physics'
  ];
  String? selectedIndexCategory = 'Co-De';
  String? dropdownNames;
  String? dropdownScrollable = 'I';

  var nameCont = TextEditingController();
  var addressLine1Cont = TextEditingController();
  var addressLine2Cont = TextEditingController();
  var typeCont = TextEditingController();
  var mobileCont = TextEditingController();

  var addressLine1Focus = FocusNode();
  var addressLine2Focus = FocusNode();
  var typeFocus = FocusNode();
  var mobileFocus = FocusNode();
  var autoValidate = false;
  var formKey = GlobalKey<FormState>();

  validate() {
    if (formKey.currentState!.validate()) {
      hideKeyboard(context);
      toast('Adding Successfully');
      formKey.currentState!.save();

      var addressData = DTAddressListModel();
      addressData.name = nameCont.text.validate();
      addressData.addressLine1 = addressLine1Cont.text.validate();
      addressData.addressLine2 = addressLine2Cont.text.validate();
      addressData.phoneNo = mobileCont.text.validate();
      addressData.type = 'Office';

      finish(context, addressData);
    } else {
      autoValidate = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: dynamicBoxConstraints(),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appStore.scaffoldBackground,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Accept Request', style: boldTextStyle(size: 18)),
                    IconButton(
                      icon: Icon(Icons.close, color: appStore.iconColor),
                      onPressed: () {
                        finish(context);
                      },
                    )
                  ],
                ),
                Text('Are you sure you want to accept this Co-De request?'),
                16.height,
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            validate();
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: appColorPrimary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Center(
                              child: Text("Yes",
                                  style: boldTextStyle(color: white)),
                            ),
                          ),
                        )),
                    8.width,
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          validate();
                        },
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: redColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Center(
                            child:
                                Text("No", style: boldTextStyle(color: white)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
