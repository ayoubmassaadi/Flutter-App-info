import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? imageFile;
  String? recognizedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  openDialog(context);
                },
                child: Text(
                  'Pick Image',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Text(
                  recognizedText ?? '',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepOrangeAccent, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageFile != null
                        ? FileImage(imageFile!)
                        : AssetImage('images/profile.jpg') as ImageProvider,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> textRecognition(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedTextResult = await textRecognizer.processImage(inputImage);
    textRecognizer.close();
    
    setState(() {
      recognizedText = recognizedTextResult.text;
    });
  }

  Future<void> openDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Make a Choice'),
          actions: <Widget>[
            TextButton(
              child: Text('Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final croppedFile = await ImageCropper().cropImage(
                    sourcePath: pickedFile.path,
                    uiSettings: [
                      AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false,
                      ),
                      IOSUiSettings(
                        minimumAspectRatio: 1.0,
                      ),
                    ],
                  );

                  if (croppedFile != null) {
                    File file = File(croppedFile.path);
                    await textRecognition(file);
                    setState(() {
                      imageFile = file;
                    });
                  }
                }
              },
            ),
            TextButton(
              child: Text('Camera'),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  maxWidth: 400,
                  maxHeight: 400,
                );
                if (pickedFile != null) {
                  final croppedFile = await ImageCropper().cropImage(
                    sourcePath: pickedFile.path,
                    uiSettings: [
                      AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Colors.deepOrange,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false,
                      ),
                      IOSUiSettings(
                        minimumAspectRatio: 1.0,
                      ),
                    ],
                  );

                  if (croppedFile != null) {
                    File file = File(croppedFile.path);
                    await textRecognition(file);
                    setState(() {
                      imageFile = file;
                    });
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
