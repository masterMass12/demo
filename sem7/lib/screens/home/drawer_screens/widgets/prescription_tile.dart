import 'package:flutter/material.dart';
import 'package:ivrapp/model/prescription.dart';
class PrescriptionTile extends StatelessWidget {
  const PrescriptionTile({
    super.key,
    required this.prescription,
    required this.deletecallback,
    required this.pagecallback
  });
  final VoidCallback deletecallback;
  final VoidCallback pagecallback;
  final Prescription prescription;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pagecallback,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: 350,
            width: double.infinity,
            child : Container(
              height: 300,
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: Image.network(prescription.prescriptionUrl,fit:BoxFit.fitHeight ,),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              child: CircleAvatar(
                radius: 17,
                child: Icon(
                  Icons.delete,
                  color: Colors.black,

                ),
              ),
              onTap: deletecallback,
            ),
          )
        ],
      ),
    );
  }
}
