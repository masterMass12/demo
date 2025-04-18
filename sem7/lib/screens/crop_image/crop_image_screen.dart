import 'package:flutter/material.dart';
import 'package:ivrapp/constants.dart';
import 'package:ivrapp/pick_file.dart';
import 'package:ivrapp/screens/extracted_med_list/extracted-med-list.dart';
import 'package:ivrapp/storage_methods/firestore_methods.dart';
import 'package:ivrapp/widgets/custom_button.dart';

class CropImageScreen extends StatefulWidget {
  static const routeName = '/crop-image-screen';
  final Map<String, dynamic> filedetails;
  CropImageScreen({super.key, required this.filedetails});

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  String url = '';
  bool isLoading = false;
  Map<String, dynamic> filedetails = {};
  List<String> medicines=[];


  void addPdf() async {
    setState(() {
      isLoading = true;
    });

    medicines=await FirestoreMethods().uploadPrescriptionDetails(
        context: context,
        filedetails: filedetails.isNotEmpty ? filedetails : widget.filedetails);
    setState(() {
      isLoading = false;
    });
    Navigator.pushNamed(context, MedicineList.routeName,arguments: medicines);
  }

  void getCroppedImage() async {
    filedetails = await Pickfile().cropImage(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: () {
                getCroppedImage();
              },
              child: Text(
                'Retake Photo',
                style: TextStyle(color: whiteColor, fontSize: 20),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: Image.file(filedetails.isNotEmpty
                    ? filedetails['file']
                    : widget.filedetails['file'])),
            (isLoading)
                ? Container(
                    height: 48,
                    margin: EdgeInsets.all(8),
                    color: greenColor,
                    width: double.infinity,
                    child: Center(
                      child: const CircularProgressIndicator(
                        color: whiteColor,
                      ),
                    ),
                  )
                : CustomButton(
                    width: double.infinity,
                    callback: () {
                      addPdf();

                    },
                    buttontitle: 'Extract Medicines list')
          ],
        ),
      ),
    );
  }
}
