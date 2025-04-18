import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:majorproject/models/MedicineModel.dart';
import 'package:majorproject/models/OrderModel.dart';
import 'package:majorproject/providers/OrdersProvider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MedicineField {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
}

class CreateOrderView extends StatefulWidget {
  const CreateOrderView({super.key});
  @override
  _CreateOrderViewState createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  final _formKey = GlobalKey<FormState>();
  final OrderProvider _orderProvider = OrderProvider();
  bool _isLoading = false;

  // A dynamic list to store medicine fields
  List<MedicineField> medicineFields = [];

  @override
  void initState() {
    super.initState();
    // Start with one medicine field by default
    medicineFields.add(MedicineField());
  }

  void placeOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    // Create dynamic medicine list from user inputs
    List<MedicineModel> medicines = [];
    for (var field in medicineFields) {
      String name = field.nameController.text.trim();
      // Try parsing the quantity input; if it fails, default to 1.
      int quantity = int.tryParse(field.quantityController.text.trim()) ?? 1;
      if (name.isNotEmpty) {
        medicines.add(MedicineModel(name: name, quantity: quantity));
      }
    }

    String orderId = Uuid().v4().toString();
    OrderModel newOrder = OrderModel(
      orderID: orderId,
      userID: "user1",
      location: "Mumbai",
      medicineList: medicines,
      prescriptionCode: "1234",
      isPrescription: false,
      status: "Pending",
      dateOfOrder: DateTime.now(),
    );
    await _orderProvider.createOrder(newOrder);
    setState(() {
      _isLoading = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _orderProvider.message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green, // Adjust based on success/error
      ),
    );
  }

  // Build dynamic medicine input fields.
  Widget buildMedicineFields() {
    return Column(
      children: List.generate(medicineFields.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              // Expanded medicine name field
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: medicineFields[index].nameController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontSize: 12),
                    labelText: 'Medicine Name',
                    prefixIcon: Icon(Iconsax.note),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter medicine name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 10),
              // Expanded quantity field with numeric keyboard
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: medicineFields[index].quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(fontSize: 12),
                    prefixIcon: Icon(Iconsax.hashtag),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter quantity';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Invalid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 5),
              // Show remove icon if there is more than one medicine field
              if (medicineFields.length > 1)
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      medicineFields.removeAt(index);
                    });
                  },
                ),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    String message = Provider.of<OrderProvider>(context).message;
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Order"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Medicine Fields Dynamic List
              buildMedicineFields(),
              // Button to add another medicine row
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    medicineFields.add(MedicineField());
                  });
                },
                icon: Icon(Icons.add, color: Colors.green),
                label: Text(
                  "Add Medicine",
                  style: TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                  _formKey.currentState!.save();
                  placeOrder();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: (_isLoading)
                    ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
                    : Text(
                  "Create Order",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
