import 'package:flutter/material.dart';

import '../models/KitBomItem.dart';
import '../repositories/KitBomRepository.dart';

class UpdateKitForm extends StatefulWidget {
  @override
  _UpdateKitFormState createState() => _UpdateKitFormState();
}

class _UpdateKitFormState extends State<UpdateKitForm> {
  TextEditingController kitNumberController = TextEditingController();
  List<KitComponent> components = []; // List to hold kit components
  final IKitBomRepository _kitBomRepository = KitBomRepository();
  List<Map<String, TextEditingController>> componentControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize with one row
  }


  List<Map<String, TextEditingController>> newComponentControllers = [];

  void _addNewComponentRow({bool isNew = true}) {
    setState(() {
      var controllerSet = {
        "productNumber": TextEditingController(),
        "quantity": TextEditingController(),
        "listPrice": TextEditingController(),
      };
      newComponentControllers.add(controllerSet);
    });
  }

  void _handleSubmit() async {
    String kitNumber = kitNumberController.text;
    List<KitBomItem> components = componentControllers.map((controllers) {
      return KitBomItem(
        id: int.tryParse(controllers["id"]!.text) ?? 0,
        productNo: controllers["productNumber"]!.text,
        quantity: int.tryParse(controllers["quantity"]!.text) ?? 0,
        listPrice: double.tryParse(controllers["listPrice"]!.text) ?? 0.0,
      );
    }).toList();
    List<KitBomItem> newComponents = newComponentControllers.map((controllers) {
      return KitBomItem(
        productNo: controllers["productNumber"]!.text,
        quantity: int.tryParse(controllers["quantity"]!.text) ?? 0,
        listPrice: double.tryParse(controllers["listPrice"]!.text) ?? 0.0,
      );
    }).toList();

    try {
      bool updateResult = await _kitBomRepository.updateKitBom(kitNumber, components);
      bool createResult = await _kitBomRepository.createKitBom(kitNumber, newComponents);

      if (updateResult && createResult) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("KitBom updated successfully")),
        );
        fetchAndDisplayKitComponents(kitNumber); // Reload the data
        setState(() {
          newComponentControllers.clear(); // Clear the additional rows
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update KitBom")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    }
  }
  bool shouldDisplayDataTable = false;

  void _clearForm() {
    setState(() {
      kitNumberController.clear();
      componentControllers.clear();
      newComponentControllers.clear();
      shouldDisplayDataTable = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth * 0.6;

    return SingleChildScrollView(

      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 50),
        child: Container(
          width: formWidth,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child:  Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(child: Text("UPDATE KIT", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: kitNumberController,
                        decoration: InputDecoration(labelText: 'Kit Number'),
                        onSubmitted: (value) => fetchAndDisplayKitComponents(value),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => fetchAndDisplayKitComponents(kitNumberController.text),
                      child: Text('Get Details'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
               /* if (componentControllers.isNotEmpty) ...[*/
                if (shouldDisplayDataTable) ...[
                  createComponentsDataTable(),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _addNewComponentRow(isNew: true),
                    child: Text('Add Component'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _handleSubmit,
                        child: Text('Submit'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => fetchAndDisplayKitComponents(kitNumberController.text),
                        child: Text('Refresh'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue, // Optional: Style for the refresh button
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _clearForm,
                        child: Text('Clear'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey, // Optional: Style for the clear button
                        ),
                      ),
                    ],
                  ),
                /*],*/
      ]
              ],
            ),
          ),

        ),
      ),

    );
  }

  void fetchAndDisplayKitComponents(String kitNumber) async {
    try {
      List<KitBomItem> fetchedComponents = await _kitBomRepository.fetchKitBomItemsWithId(kitNumber);
      setState(() {
        componentControllers.clear();
        shouldDisplayDataTable = true; // Set to true if API call is successful
        for (var component in fetchedComponents) {
          componentControllers.add({
            "id": TextEditingController(text: component.id.toString()),
            "productNumber": TextEditingController(text: component.productNo),
            "quantity": TextEditingController(text: component.quantity.toString()),
            "listPrice": TextEditingController(text: component.listPrice.toString()),
          });
        }
        if (fetchedComponents.isEmpty) {
          newComponentControllers.clear(); // Clear any existing new component rows
          _addNewComponentRow(isNew: true); // Add a new row only if there are no components
        }
      });
    } catch (e) {
      setState(() {
        shouldDisplayDataTable = false; // Set to false in case of an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    }
  }





  Widget createComponentsDataTable() {
    var componentControllersRows = componentControllers.map((controllers) {
      return DataRow(
        cells: <DataCell>[
          DataCell(TextField(controller: controllers["id"], enabled: false)), // ID field should be read-only
          DataCell(TextField(controller: controllers["productNumber"])),
          DataCell(TextField(controller: controllers["quantity"])),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: TextField(controller: controllers["listPrice"])),
              // No remove button for existing components
            ],
          )),
        ],
      );
    }).toList();

    var newComponentRows = newComponentControllers.asMap().map((index, controllers) {
      return MapEntry(index, DataRow(
        cells: <DataCell>[
          DataCell(Container()),
          DataCell(TextField(controller: controllers["productNumber"])),
          DataCell(TextField(controller: controllers["quantity"])),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: TextField(controller: controllers["listPrice"])),
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () => _removeNewComponentRow(index),
              ),
            ],
          )),
        ],
      ));
    }).values.toList();

    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('ID')),
        DataColumn(label: Text('Product Number')),
        DataColumn(label: Text('Quantity')),
        DataColumn(label: Text('List Price')),
      ],
      rows: componentControllersRows + newComponentRows,
    );
  }

  void _removeNewComponentRow(int index) {
    setState(() {
      newComponentControllers.removeAt(index);
    });
  }





}

class KitComponent {
  String name;
  int quantity;

  KitComponent({required this.name, required this.quantity});
}
