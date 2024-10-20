import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? myFile;
  @override
  Widget build(BuildContext context) {
    Future<File?> cropImage(String filePath) async {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: filePath,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: false,
                aspectRatioPresets: [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio7x5
                ]),
          ]);
      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    }

    Widget imageCard() {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    child: Image.file(
                      myFile!,
                      height: 500,
                      width: 500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      );
    }

    Widget uploadCard() {
      return Center(
        child: Card(
          color: Colors.white,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            width: 320.0,
            height: 300.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DottedBorder(
                      radius: const Radius.circular(12.0),
                      borderType: BorderType.RRect,
                      dashPattern: const [8, 4],
                      color: Theme.of(context).highlightColor.withOpacity(0.4),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: Theme.of(context).highlightColor,
                              size: 50,
                            ),
                            const SizedBox(
                              height: 24.0,
                            ),
                            Text(
                              'Upload an image to start',
                              style: kIsWeb
                                  ? Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                          color:
                                              Theme.of(context).highlightColor)
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color:
                                              Theme.of(context).highlightColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final tempImage =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (tempImage != null) {
                        final tempFile = await cropImage(tempImage.path);
                        if (tempFile != null) {
                          setState(() {
                            myFile = tempFile;
                          });
                        }
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text(
                      'Upload',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: (myFile != null) ? imageCard() : uploadCard())
        ],
      ),
    );
  }
}
