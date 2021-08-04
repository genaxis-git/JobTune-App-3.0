import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class UploadPhoto extends StatefulWidget{
  @override
  _UploadPhotoState createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  PickedFile? _imageFile;
//  final String uploadUrl = 'https://jobtune.ai/gig/JobTune/assets/img/mobile_uploadPhoto_user.php';
  final String uploadUrl = 'http://jobtune-dev.my1.cloudapp.myiacloud.com/gig/JobTune/assets/img/jtnew_uploadPhoto_user.php';
  final ImagePicker _picker = ImagePicker();

  uploadImage(filepath, url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String user = prefs.getString('email').toString();
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['lgid'] = "syeeraayeem@gmail.com";
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    return res.reasonPhrase;
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      print('Retrieve error ');
    }
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.file(File(_imageFile.path)),
            Text(
              'Image Selected',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () async {
                      final snackBar = SnackBar(content: Text('Image Uploaded!'));
                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      var res = await uploadImage(_imageFile!.path, uploadUrl);
                      print("hai sini: " +_imageFile!.path);
                      print(res);
                    },
                    child: Text('Upload Image'),
                  ),
                ]
            ),
          ],
        ),
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Profile Photo',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 6,),
                  OutlinedButton(
                    onPressed: _pickImage,
                    child: Text('Choose Image'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: FutureBuilder<void>(
                      future: retriveLostData(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Text('Picked an image');
                          case ConnectionState.done:
                            return _previewImage();
                          default:
                            return const Text('Picked an image');
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  SizedBox(height: 16,),
                ],
              ),
            ),
          ),
        ],

      ),
    );
  }
}