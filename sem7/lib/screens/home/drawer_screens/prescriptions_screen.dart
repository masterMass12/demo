import 'package:flutter/material.dart';
import 'package:ivrapp/screens/home/drawer_screens/services/prescription_services.dart';
import 'package:ivrapp/screens/home/drawer_screens/widgets/prescription_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';
import '../../../model/prescription.dart';
import '../../../pick_file.dart';
import '../../../widgets/showAlert.dart';
import '../../crop_image/crop_image_screen.dart';

class PrescriptionScreen extends StatefulWidget {
  static const routeName = '/prescriptions-screen';
  const PrescriptionScreen({super.key});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  List<Prescription> prescriptions = [];
  bool isLoading = false;
  Map<String, dynamic>? filedetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getpres();
  }

  Future<void> getpres() async {
    prescriptions =
        await PrescriptionServices().getUserPrescriptions(context: context);
    (prescriptions.isEmpty) ? null : await Future.delayed(Duration(seconds: 2));
  }

  void getCroppedImage() async {
    filedetails = await Pickfile().cropImage(context: context);

    Navigator.pushNamed(context, CropImageScreen.routeName,
        arguments: filedetails!);
  }

  void redirectToURL() async {
    var url = Uri.parse("https://youtu.be/xvFZjo5PgG0?si=IUREnmSXPMjKC0Os");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                redirectToURL();
              },
              icon: Icon(
                Icons.web,
                color: whiteColor,
              ))
        ],
        centerTitle: true,
        title: Text(
          'Your Prescriptions',
          style: TextStyle(color: whiteColor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //getCroppedImage();
          showAlert(context: context, title: '', callback: getCroppedImage);
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: getpres(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: greenColor,
              ));
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.error == null) {
              return PrescriptionGrid(prescriptions: prescriptions);
            } else {
              return Text('Error. Please retry later');
            }
          }),
    );
  }
}
