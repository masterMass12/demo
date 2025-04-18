import 'package:flutter/cupertino.dart';
import 'package:ivrapp/model/prescription.dart';

class PrescriptionProvider extends ChangeNotifier
{
  Prescription _prescription=Prescription(userid: '', prescriptionUrl: '', uploadDate: '', medicines: [], id: '', fileName: '');
  Prescription get prescription=>_prescription;

  void getPrescription(Prescription prescription)
  {
    _prescription=prescription;
    notifyListeners();
  }

}