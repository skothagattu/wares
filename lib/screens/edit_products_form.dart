import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:wares/models/products_submission.dart';
import '../models/products.dart';
import '../models/roleMap.dart';
import '../providers/provider_products.dart';

class EditProductForm extends ConsumerStatefulWidget  {
  ProductSubmission productSubmission;
  final VoidCallback? onProductUpdated;

  EditProductForm({required this.productSubmission, this.onProductUpdated});


  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends ConsumerState<EditProductForm> {
  late TextEditingController _revController;
  late TextEditingController _descriptionController;
  late TextEditingController _configurationController;
/*  late TextEditingController _llcController;*/
  late TextEditingController _level1Controller;
  late TextEditingController _typeController;
  late TextEditingController _ecrController;
  late TextEditingController _listpriceController;
  late TextEditingController _commentsController;
  late TextEditingController _activeController;
  late TextEditingController _labelDescController;
  late TextEditingController _productSpecController;
  late TextEditingController _labelConfigController;
  late TextEditingController _dateReqController;
  late TextEditingController _dateDueController;
  late TextEditingController _level2Controller;
  late TextEditingController _level3Controller;
  late TextEditingController _level4Controller;
  late TextEditingController _level5Controller;
  late TextEditingController _sequenceNumController;
  late TextEditingController _locationWaresController;
  late TextEditingController _locationAccpacController;
  late TextEditingController _locationMisysController;
  late TextEditingController _level6Controller;
  late TextEditingController _level7Controller;
  late TextEditingController _instGuideController;
  late TextEditingController companyNameController;



  // ... Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();
    _revController = TextEditingController(text: widget.productSubmission.rev);
    _descriptionController = TextEditingController(text: widget.productSubmission.description);
    _configurationController = TextEditingController(text: widget.productSubmission.configuration);
    companyNameController = TextEditingController(text: widget.productSubmission.companyName?.toString() ?? '');
    _level1Controller = TextEditingController(text: widget.productSubmission.level1);
    _typeController = TextEditingController(text: widget.productSubmission.type);
    _ecrController = TextEditingController(text: widget.productSubmission.ecr);
    _listpriceController =TextEditingController(text: widget.productSubmission.listprice?.toString() ?? '');
    String decodedComments = widget.productSubmission.comments != null
        ? utf8.decode(base64Decode(widget.productSubmission.comments!))
        : '';
    _commentsController = TextEditingController(text: decodedComments);
    _activeController = TextEditingController(text: widget.productSubmission.active);
    _labelDescController = TextEditingController(text: widget.productSubmission.labelDesc);
    _productSpecController = TextEditingController(text: widget.productSubmission.productSpec);
    _labelConfigController = TextEditingController(text: widget.productSubmission.labelConfig);
    _dateReqController = TextEditingController(text: widget.productSubmission.dateReq);
    _dateDueController = TextEditingController(text: widget.productSubmission.dateDue);
    _level2Controller = TextEditingController(text: widget.productSubmission.level2);
    _level3Controller = TextEditingController(text: widget.productSubmission.level3);
    _level4Controller = TextEditingController(text: widget.productSubmission.level4);
    _level5Controller = TextEditingController(text: widget.productSubmission.level5);
    _sequenceNumController = TextEditingController(text: widget.productSubmission.sequenceNum?.toString() ?? '');
    _locationWaresController = TextEditingController(text: widget.productSubmission.locationWares);
    _locationAccpacController = TextEditingController(text: widget.productSubmission.locationAccpac);
    _locationMisysController = TextEditingController(text: widget.productSubmission.locationMisys);
    _level6Controller = TextEditingController(text: widget.productSubmission.level6);
    _level7Controller = TextEditingController(text: widget.productSubmission.level7);
    _instGuideController = TextEditingController(text: widget.productSubmission.instGuide);

    // ... Initialize other controllers as needed


  }
  final _formKey = GlobalKey<FormState>();

  List<String> companies = ['CMI', 'CabAire', 'Fleet Management', 'Security Management', 'Time Management', 'EVSE'];
  String? selectedCompany;
  Future<void> _selectDateTime(BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Use DateFormat to format the DateTime object
        String formattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(selectedDateTime);
        controller.text = formattedDateTime;
      }
    }
  }
  Future<bool> hasRole(String requiredRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> roleNumbers = prefs.getStringList('roles') ?? [];
    List<String> roles = roleNumbers.map((role) => roleMap[int.parse(role)] ?? 'Unknown').toList();
    return roles.contains(requiredRole);
  }
  void _fetchNextProduct() async {
    final currentProductNo = widget.productSubmission.productno;
    if (currentProductNo != null) {
      final nextProduct = await ref.read(productsRepositoryProvider).getNextProduct(currentProductNo);
      if (nextProduct != null) {
        setState(() {
          widget.productSubmission = ProductSubmission.fromProduct(nextProduct);
          _updateFormFields(nextProduct);
        });
      }
    }
  }

  void _fetchPreviousProduct() async {
    final currentProductNo = widget.productSubmission.productno;
    if (currentProductNo != null) {
      final previousProduct = await ref.read(productsRepositoryProvider).getPreviousProduct(currentProductNo);
      if (previousProduct != null) {
        setState(() {
          widget.productSubmission = ProductSubmission.fromProduct(previousProduct);
          _updateFormFields(previousProduct);
        });
      }
    }
  }


  void _updateFormFields(Product product) {
    print("9");
    // Update all your text controllers with the new product data
    _revController.text = product.rev ?? '';
    _activeController.text = product.active ?? '';
    _descriptionController.text = product.description ?? '';
    _configurationController.text = product.configuration ?? '';
    companyNameController.text = product.companyName ?? '';
    _level1Controller.text = product.leveL1 ?? '';
    _typeController.text = product.type ?? '';
    _ecrController.text = product.ecr ?? '';
    String decodedComments = product.comments != null
        ? utf8.decode(base64Decode(product.comments!))
        : '';
    _commentsController.text = decodedComments ?? '';
    _labelDescController.text = product.labeL_DESC ?? '';
    _labelConfigController.text = product.labeL_CONFIG ?? '';
    _dateReqController.text = product.datE_REQ ?? '';
    print("10");
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer(
      builder: (context, ref, child) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: SingleChildScrollView(
            child:
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [SizedBox(height: 20),
                    _buildFormRow(screenWidth, [
                      Text('Product No: '),
                      Text(widget.productSubmission.productno ?? 'N/A'),
                      _buildStandardTextField(_revController, 'REV'),
                      _buildStandardTextField(_activeController, 'STATUS'),
                      _buildStandardTextField(_typeController, 'TYPE'),
                      _buildStandardTextField(_descriptionController, 'DESCRIPTION'),
                      // ... other fields// Custom field with date picker
                      // ... other fields
                    ]),

                    SizedBox(height: screenWidth * 0.01),
                    _buildFormRow(screenWidth, [
                      _buildStandardTextField(_labelDescController, 'LABEL DESCRIPTION'),
                      _buildStandardTextField(_configurationController, 'CONFIGURATION'),
                      _buildStandardTextField(_labelConfigController, 'LABEL CONFIGURATION'),
                      _buildDateModifiedField(),
                      _buildCompanyDropdownField(companyNameController, companies),

                      // ... other fields// Custom field with date picker
                      // ... other fields
                    ]),

                    SizedBox(height: screenWidth * 0.01),
                    // Add more rows of fields in similar fashion
                    // ... (add other rows here)
                    _buildFormRow(screenWidth, [
                      _buildStandardTextField(_commentsController, 'COMMENTS'),
                      // Custom field with date picker
                      // ... other fields
                    ]),







                ]
                ),

              ),
            )
          ),
          actions: <Widget>[
            // Bottom Center: Back and Next buttons
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Back and Next buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop('clearProductNumber');
                  },
                  child: Text('Cancel'),
                ),

              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _fetchPreviousProduct,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _fetchNextProduct,
                ),
                ]
            ),

                TextButton(
                  onPressed: () async {
                    // Update the product details here
                    // For example, send a PUT request to your API
                    /* if (await hasRole('Admin') || await hasRole('Manager')) {*/
                    String encodedComments = base64Encode(
                        utf8.encode(_commentsController.text));
                    final productNo = widget.productSubmission.productno ??
                        (throw 'Product No is null');
                    final UpdateProductSubmission = ProductSubmission(
                      rev: _emptyToNull(_revController.text),
                      description: _emptyToNull(_descriptionController.text),
                      configuration: _emptyToNull(_configurationController.text),
                      companyName: _emptyToNull(companyNameController.text),
                      level1: _emptyToNull(_level1Controller.text),
                      type: _emptyToNull(_typeController.text),
                      ecr: _emptyToNull(_ecrController.text),
                      listprice: _emptyToNull(_listpriceController.text),
                      comments: _emptyToNull(encodedComments),
                      active: _emptyToNull(_activeController.text),
                      labelDesc: _emptyToNull(_labelDescController.text),
                      productSpec: _emptyToNull(_productSpecController.text),
                      labelConfig: _emptyToNull(_labelConfigController.text),
                      dateReq: _emptyToNull(_dateReqController.text),
                      dateDue: _emptyToNull(_dateDueController.text),
                      level2: _emptyToNull(_level2Controller.text),
                      level3: _emptyToNull(_level3Controller.text),
                      level4: _emptyToNull(_level4Controller.text),
                      level5: _emptyToNull(_level5Controller.text),
                      sequenceNum: _emptyToNull(_sequenceNumController.text),
                      locationWares: _emptyToNull(_locationWaresController.text),
                      locationAccpac: _emptyToNull(
                          _locationAccpacController.text),
                      locationMisys: _emptyToNull(_locationMisysController.text),
                      level6: _emptyToNull(_level6Controller.text),
                      level7: _emptyToNull(_level7Controller.text),
                      instGuide: _emptyToNull(_instGuideController.text),
                      // ... Set other fields as needed
                    );
                    /*      print('Updated Product: $UpdateProductSubmission');*/


                    ref.read(updateProductProvider(
                        Tuple2(productNo, UpdateProductSubmission)).future).then((
                        success) {
                      if (success) {
                        if (widget.onProductUpdated != null) {
                          widget.onProductUpdated!();
                        }
                        Navigator.of(context).pop('clearProductNumber');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Product updated successfully!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update product')),
                        );
                      }
                    }).catchError((error) {
                      print('An error occurred: $error');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                            'An error occurred while updating the product')),
                      );
                    });
                    /*}
                else {
                  // User does not have the required role, show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                        'You do not have permission to perform this action')),
                  );
                }*/

                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  Widget _buildFormRow(double screenWidth, List<Widget> rowFields) {
    double spaceBetweenFields = screenWidth * 0.02; // 2% of the screen width
    List<Widget> rowWidgets = [];

    for (int i = 0; i < rowFields.length; i++) {
      rowWidgets.add(
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: i < rowFields.length - 1 ? spaceBetweenFields : 0),
            child: rowFields[i], // Use the widget directly
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: rowWidgets,
    );
  }

  Widget _buildStandardTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
      validator: (value) {
        if (value == null || value!.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildCompanyDropdownField(TextEditingController controller, List<String> companies) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Company',
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
      value: controller.text.isEmpty ? null : controller.text,
      onChanged: (String? newValue) {
        setState(() {
          controller.text = newValue ?? ''; // Update the controller with the selected value
        });
      },
      items: companies.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a company';
        }
        return null;
      },
    );
  }

  Widget _buildDateModifiedField() {
    return TextFormField(
      controller: _dateReqController,
      readOnly: true, // Makes the field not editable directly
      decoration: InputDecoration(
        labelText: 'Date Modified',
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        suffixIcon: Icon(Icons.calendar_today), // Calendar icon
      ),
      onTap: () async {
        // Prevents keyboard from appearing
        FocusScope.of(context).requestFocus(new FocusNode());
        // Opens date picker
        await _selectDateTime(context, _dateReqController);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Date Modified';
        }
        return null;
      },
    );
  }
  String? _emptyToNull(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }
    return input;
  }


}
