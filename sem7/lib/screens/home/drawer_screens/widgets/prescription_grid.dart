import 'package:flutter/material.dart';
import 'package:ivrapp/model/prescription.dart';
import 'package:ivrapp/screens/home/drawer_screens/widgets/individual_prescription.dart';
import 'package:ivrapp/screens/home/drawer_screens/widgets/prescription_tile.dart';
import 'package:ivrapp/storage_methods/store_prescriptions.dart';

class PrescriptionGrid extends StatefulWidget {
  const PrescriptionGrid({super.key, required this.prescriptions});
  final List<Prescription> prescriptions;

  @override
  State<PrescriptionGrid> createState() => _PrescriptionGridState();
}

class _PrescriptionGridState extends State<PrescriptionGrid> {
  void delete(
      {required BuildContext context,
      required Prescription prescription}) async {
    await FirebaseStorageMethods()
        .deleteFromFirestorage(context: context, prescription: prescription);
    setState(()
    {
      widget.prescriptions.remove(prescription);
    });
  }
  
  void goToprescriptionDetails({required BuildContext context,required Prescription prescription})
  {
    Navigator.pushNamed(context, IndividualPrescriptionPage.routeName,arguments: prescription);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: (widget.prescriptions.isEmpty)
          ? Center(
              child: Text('No prescriptions'),
            )
          : GridView.builder(
        shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return PrescriptionTile(
                    prescription: widget.prescriptions[index],
                    deletecallback: () {
                      delete(
                          context: context,
                          prescription: widget.prescriptions[index]);
                    }, pagecallback: () { 
                      goToprescriptionDetails(context: context, prescription: widget.prescriptions[index]);
                },);
              },
              itemCount: widget.prescriptions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 10,
                  childAspectRatio: 49 / 51),
            ),
    );
  }
}
