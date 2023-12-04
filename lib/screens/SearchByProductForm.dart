import 'package:flutter/material.dart';
import '../models/KitBomItem.dart';
import '../models/KitByProductitem.dart';
import '../repositories/KitBomRepository.dart';

class SearchByProductForm extends StatefulWidget {
  @override
  _SearchByProductFormState createState() => _SearchByProductFormState();
}

class _SearchByProductFormState extends State<SearchByProductForm> {
  TextEditingController productNumberController = TextEditingController();
  final IKitBomRepository _kitBomRepository = KitBomRepository();
  List<KitByProductItem> kits = [];

  void _fetchKitsByProductNo() async {
    try {
      String productNo = productNumberController.text;
      List<KitByProductItem> fetchedKits = await _kitBomRepository.fetchKitsByProductNo(productNo);

      setState(() {
        kits = fetchedKits;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    }
  }
  void _clearForm() {
    setState(() {
      productNumberController.clear();
      kits.clear();
    });
  }


  @override
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
            border: Border.all(color: Colors.black, width: 2),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(child: Text("SEARCH BY PRODUCT", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: productNumberController,
                        decoration: InputDecoration(labelText: 'Product Number'),
                        onSubmitted: (_) => _fetchKitsByProductNo(),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _fetchKitsByProductNo,
                      child: Text('Search Kits'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (kits.isNotEmpty) _createKitsDataTable(),
                if (kits.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _fetchKitsByProductNo,
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _createKitsDataTable() {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Kit Number')),
        DataColumn(label: Text('Quantity')),
      ],
      rows: kits.map((kit) => DataRow(
        cells: <DataCell>[
          DataCell(Text(kit.kitNo)),
          DataCell(Text(kit.quantity.toString())),
        ],
      )).toList(),
    );
  }
}
