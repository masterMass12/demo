import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:ivrapp/model/prescription.dart';
import 'package:ivrapp/widgets/showSnackBar.dart';


class FirebaseStorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final User _user=FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Future<String> uploadtoFirestorage({required BuildContext context,required Map<String,dynamic> filedetails}) async {

    String filename = filedetails['name'];

    Reference _ref =
        _storage.ref().child('prescriptions/').child(_user.uid).child(filename);
    UploadTask uploadTask = _ref.putFile(filedetails['file']);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteFromFirestorage({required BuildContext context,required Prescription prescription})async
  {
    try
    {
      await _firestore.collection('prescriptions').doc(prescription.id).delete();
      Reference _ref =
      _storage.ref().child('prescriptions/').child(_user.uid).child(prescription.fileName);
      await _ref.delete();
      print('deleted');
    }catch(err)
    {
      showSnackBar(context, err.toString());
    }


  }


}
