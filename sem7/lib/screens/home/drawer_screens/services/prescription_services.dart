import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:ivrapp/model/prescription.dart';
import 'package:ivrapp/widgets/showSnackBar.dart';

class PrescriptionServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Prescription>> getUserPrescriptions(
      {required BuildContext context}) async {
    List<Prescription> prescriptions=[];
    try {

      QuerySnapshot snapshot = await _firestore
          .collection('prescriptions')
          .where('userid', isEqualTo: _auth.currentUser!.uid)
          .get();


      for(int i=0;i<snapshot.docs.length;i++)
      {
        Prescription prescription=await Prescription.fromSnap(snapshot.docs[i]);
        prescriptions.add(prescription);

      }


    } catch (err) {
      showSnackBar(context, err.toString());
    }

    return prescriptions;
  }
}
