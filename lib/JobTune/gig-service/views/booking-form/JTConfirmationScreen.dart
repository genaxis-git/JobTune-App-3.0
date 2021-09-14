import 'package:flutter/material.dart';
import 'package:prokit_flutter/JobTune/gig-service/views/service-detail/JTServiceDetailScreen.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({
    Key? key,
    required this.message,
    required this.id,
  }) : super(key: key);
  final String message;
  final String id;

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: Text(
          "Information",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          height: 90.0,
          child: Column(
            children: <Widget>[
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.0),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    elevation: 5.0,
                    child: Text(
                      "Okay",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color(0xff01A0C7),
                    onPressed: () {
                      int count = 0;
                      // Navigator.of(context).popUntil((_) => count++ >= 3);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => JTServiceDetailScreen(
                            id:widget.id
                          )
                      ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
