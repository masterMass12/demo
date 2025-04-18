import 'dart:io';
import 'package:file_picker/file_picker.dart' as filepicker;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ivrapp/constants.dart';

class Pickfile {
  Future<Map<String,dynamic>> pickfile() async {
    var file_details;
    File? file;
    String name;
    try {
      filepicker.FilePickerResult? docs = await filepicker.FilePicker.platform
          .pickFiles(type: filepicker.FileType.custom,allowedExtensions: ['jpg','png','svg','jpeg']);
      if (docs != null || docs!.files.isNotEmpty) {
        file=File(docs.files.first.path!);
        name=docs.files.first.name;
        file_details=
        {
          "name":name,
          "file":file
        };
      }
    } catch (err) {
      print(err.toString());
    }
    return file_details!;
  }

  Future<Map<String,dynamic>> cropImage({required BuildContext context}) async {

       Map<String,dynamic> filedetails=await Pickfile().pickfile();
       File file;
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filedetails['file']!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: greenColor,
              toolbarWidgetColor: whiteColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Crop Image',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
            const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        filedetails['file'] = File(croppedFile.path);
       // filedetails['file']=croppedFile;
      }

    return filedetails;
  }


}
