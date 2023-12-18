
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wares/providers/provider_products.dart';
import 'package:wares/repositories/products_repository.dart';
import 'package:wares/screens/edit_products_form.dart';
import 'package:wares/screens/lookup_list_screen.dart';
import 'package:wares/theme/theme_manager.dart';
import 'main.dart';
import 'models/products.dart';
import 'models/products_submission.dart';
ThemeManager _themeManager = ThemeManager();
class AllProducts extends ConsumerStatefulWidget  {
/*  const AllProducts({Key? key}) : super(key: key);*/
  void navigateBack(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return MyApp();
    }));
  }
  final formKey = GlobalKey<FormState>();
  final ProductSubmission productSubmission = ProductSubmission(
    // Initialize with default values or fetch from an API if needed
  );


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllProductsState();
}

class _AllProductsState extends ConsumerState<AllProducts> {
  late TextEditingController productNoController;
  late TextEditingController revController;
  late TextEditingController statusController;
  late TextEditingController typeController;
  late TextEditingController descriptionController;
  late TextEditingController configurationController;
  /*late TextEditingController llcController;*/
  late TextEditingController level1Controller;
  late TextEditingController ecrController;
  late TextEditingController listpriceController;
  late TextEditingController commentsController ;
  late TextEditingController labelDescController;
  late TextEditingController productSpecController;
  late TextEditingController labelConfigController;
  late TextEditingController dateReqController;
  late TextEditingController dateDueController;
  late TextEditingController level2Controller;
  late TextEditingController level3Controller;
  late TextEditingController level4Controller;
  late TextEditingController level5Controller;
  late TextEditingController level6Controller;
  late TextEditingController level7Controller;
  late TextEditingController sequenceNumController;
  late TextEditingController locationWaresController;
  late TextEditingController locationAccpacController;
  late TextEditingController locationMisysController;
  late TextEditingController instGuideController;
  late TextEditingController companyNameController;
  // Add more controllers as needed
  late FocusNode productNoFocusNode;
  String lastSearchQuery = '';
  List<Product> searchResults = [];
  bool isSearching = false;


  int currentPage = 1;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    productNoController = TextEditingController(text: widget.productSubmission.productno);
    revController = TextEditingController(text: widget.productSubmission.rev);
    descriptionController = TextEditingController(text: widget.productSubmission.description);
    configurationController = TextEditingController(text: widget.productSubmission.configuration);
    companyNameController = TextEditingController(text: widget.productSubmission.companyName?.toString() ?? '');
    level1Controller = TextEditingController(text: widget.productSubmission.level1);
    typeController = TextEditingController(text: widget.productSubmission.type);
    ecrController = TextEditingController(text: widget.productSubmission.ecr);
    listpriceController =TextEditingController(text: widget.productSubmission.listprice?.toString() ?? '');
    commentsController = TextEditingController(text: widget.productSubmission.comments);
    statusController = TextEditingController(text: widget.productSubmission.active);
    labelDescController = TextEditingController(text: widget.productSubmission.labelDesc);
    productSpecController = TextEditingController(text: widget.productSubmission.productSpec);
    labelConfigController = TextEditingController(text: widget.productSubmission.labelConfig);
    dateReqController = TextEditingController(text: widget.productSubmission.dateReq);
    dateDueController = TextEditingController(text: widget.productSubmission.dateDue);
    level2Controller = TextEditingController(text: widget.productSubmission.level2);
    level3Controller = TextEditingController(text: widget.productSubmission.level3);
    level4Controller = TextEditingController(text: widget.productSubmission.level4);
    level5Controller = TextEditingController(text: widget.productSubmission.level5);
    sequenceNumController = TextEditingController(text: widget.productSubmission.sequenceNum?.toString() ?? '');
    locationWaresController = TextEditingController(text: widget.productSubmission.locationWares);
    locationAccpacController = TextEditingController(text: widget.productSubmission.locationAccpac);
    locationMisysController = TextEditingController(text: widget.productSubmission.locationMisys);
    level6Controller = TextEditingController(text: widget.productSubmission.level6);
    level7Controller = TextEditingController(text: widget.productSubmission.level7);
    instGuideController = TextEditingController(text: widget.productSubmission.instGuide);

    // ... Initialize other controllers as needed
    productNoFocusNode = FocusNode();
    productNoFocusNode.addListener(() {
      // Pass the ref to the _onProductNoFocusChange function
      _onProductNoFocusChange(ref);
    });
  }
  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    productNoController.dispose();
    revController.dispose();
    statusController.dispose();
    typeController.dispose();
    descriptionController.dispose();
    configurationController.dispose();
    companyNameController.dispose();
    level1Controller.dispose();
    ecrController.dispose();
    listpriceController.dispose();
    commentsController.dispose();
    labelDescController.dispose();
    productSpecController.dispose();
    labelConfigController.dispose();
    dateReqController.dispose();
    dateDueController.dispose();
    level2Controller.dispose();
    level3Controller.dispose();
    level4Controller.dispose();
    level5Controller.dispose();
    level6Controller.dispose();
    level7Controller.dispose();
    sequenceNumController.dispose();
    locationWaresController.dispose();
    locationAccpacController.dispose();
    locationMisysController.dispose();
    instGuideController.dispose();

    productNoFocusNode = FocusNode();
    productNoFocusNode.addListener(() {
      _onProductNoFocusChange(ref);
    });
    // ... dispose other resources
    super.dispose();
  }

  bool _isProductNumberValid = false;
  void _onProductNoFocusChange(WidgetRef ref) async {
    if (!productNoFocusNode.hasFocus) {
      final productNumber = productNoController.text;
      if (productNumber.isNotEmpty) {
        final productCheckResult = await ref.read(checkProductProvider(productNumber).future);
        if (productCheckResult.item1) {
          // Product number exists, show dialog and set _isProductNumberValid to false
          setState(() {
            _isProductNumberValid = false;
          });
          _showProductExistsDialog(productCheckResult.item2);
        } else {
          // Product number does not exist, set _isProductNumberValid to true
          setState(() {
            _isProductNumberValid = true;
          });
        }
      } else {
        // Product number is empty, set _isProductNumberValid to false
        setState(() {
          _isProductNumberValid = false;
        });
      }
    }
  }






  void _showProductExistsDialog(Product? product) {
    if (product != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Product Exists'),
            content: Text('This product already exists. Do you want to edit it?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  ProductSubmission productSubmission = ProductSubmission.fromProduct(product);
                  final result = await showDialog(
                    context: context,
                    builder: (context) => EditProductForm(productSubmission: productSubmission),
                  );
                  if (result == 'clearProductNumber') {
                    productNoController.clear();
                  }
                },
                child: Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  productNoController.clear();
                },
                child: Text('No'),
              ),
            ],
          );
        },
      );
    }
  }
  void _showEditProductDialog(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProductForm(productSubmission: ProductSubmission.fromProduct(product));
      },
    ).then((result) {
      if (result == 'clearProductNumber') {
        productNoController.clear();
      }
      // You may want to do something with the result here, like refreshing the list
    });
  }


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


  void _onSubmitPressed() async {
    final isFormComplete = widget.formKey.currentState?.validate() ?? false;
    final partialProductNumber = productNoController.text;


    if (isFormComplete) {

      // All fields are filled in, proceed with creating a new product or checking existing
      final productCheckResult = await ref.read(checkProductProvider(partialProductNumber).future);
      if (productCheckResult.item1) {
        // Product number exists, show dialog to edit
        _showProductExistsDialog(productCheckResult.item2);
      } else {
        // Create a new product
        _createNewProduct();
      }
    } else if (partialProductNumber.isNotEmpty) {
      // If the form isn't complete but there's a partial product number, perform a search.
      final productCheckResult = await ref.read(checkProductProvider(partialProductNumber).future);
      if (productCheckResult.item1) {
        // Product number exists, show dialog to edit, don't perform a search
        _showProductExistsDialog(productCheckResult.item2);
      } else {
        // Perform search
        _performSearch(1);
      }
    } else {
      // If the form is incomplete and there's no product number, show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in the form to create a product or enter a product number to search')),
      );
    }
  }

  void _createNewProduct() {
    String base64Comments = base64Encode(utf8.encode(commentsController.text));
    final createProductSubmission = ProductSubmission(
      productno: productNoController.text,
      rev: _emptyToNull(revController.text),
      description: _emptyToNull(descriptionController.text),
      configuration: _emptyToNull(configurationController.text),
      companyName: companyNameController.text,
      level1: _emptyToNull(level1Controller.text),
      type: _emptyToNull(typeController.text),
      ecr: _emptyToNull(ecrController.text),
      listprice: _emptyToNull(listpriceController.text),
      comments: _emptyToNull(base64Comments),
      active: _emptyToNull(statusController.text),
      labelDesc: _emptyToNull(labelDescController.text),
      productSpec: _emptyToNull(productSpecController.text),
      labelConfig: _emptyToNull(labelConfigController.text),
      dateReq: _emptyToNull(dateReqController.text),
      dateDue: _emptyToNull(dateDueController.text),
      level2: _emptyToNull(level2Controller.text),
      level3: _emptyToNull(level3Controller.text),
      level4: _emptyToNull(level4Controller.text),
      level5: _emptyToNull(level5Controller.text),
      sequenceNum: _emptyToNull(sequenceNumController.text),
      locationWares: _emptyToNull(locationWaresController.text),
      locationAccpac: _emptyToNull(locationAccpacController.text),
      locationMisys: _emptyToNull(locationMisysController.text),
      level6: _emptyToNull(level6Controller.text),
      level7: _emptyToNull(level7Controller.text),
      instGuide: _emptyToNull(instGuideController.text),
      // ... Set other fields as needed
    );
    print(dateReqController.text);
    print('created product: $createProductSubmission');
    ref.read(createProductProvider(createProductSubmission).future).then((success) {
      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product created successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create product')),
        );
      }
    }).catchError((error) {
      print('An error occurred: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while creating the product')),
      );
    });
    // ... Existing logic to create a product
  }
  Future<void> _performSearch(int pageNumber) async {
    final partialProductNumber = productNoController.text;
    setState(() {
      isSearching = true; // Show a loading indicator
    });
    try {
      final response = await ref.read(productsRepositoryProvider).fetchProductList(
        pageNumber: pageNumber,
        pageSize: 50,
        searchQuery: partialProductNumber,
      );
      setState(() {
        searchResults = response.data.items;
        // Assuming 'items' contains a list of Product objects
        totalItems = response.data.totalItems; // Update the total number of items
        currentPage = pageNumber; // Update the current page
      });
    } catch (e) {
      // Handle the error appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while searching for products')),
      );
    } finally {
      setState(() {
        isSearching = false; // Hide the loading indicator
      });
    }
  }
  void _goToPreviousPage() {
    if (currentPage > 1) {
      _performSearch(currentPage - 1);
    }
  }

  void _goToNextPage() {
    if (currentPage < (totalItems / 50).ceil()) {
      _performSearch(currentPage + 1);
    }
  }

  void navigateLookUp(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return LookupListScreen();
    }));
  }
  Widget _buildTitleWithSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(), // Pushes the title to center
        Expanded(
          flex: 2, // Allocates twice the space for the title to ensure it stays centered
          child: Center( // Centers the title text within the allocated space
            child: Text("ALL PRODUCTS", style: TextStyle(fontSize: 30)),
          ),
        ),
        Spacer(), // Also pushes the title to center from the right
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Implement what happens when the search icon is pressed
          },
        ),
      ],
    );
  }

  List<String> companies = ['CMI', 'CabAire', 'Fleet Management', 'Security Management', 'Time Management', 'EVSE'];
  String? selectedCompany;


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer(builder: (context, ref, child)
    {
      return Scaffold(
          appBar: AppBar(
            title: Image.asset('images/logo_cmi.png'),
            centerTitle: true,
            leading: BackButton(
              onPressed: () {
                widget.navigateBack(context);
              },
            ),
          ),


          body: Row(
            children: [
              /*Positioned(
                  top: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: (){
                      navigateLookUp(context);
                    },
                    child: Text("Look Up"),
                  )
              ),*/
              Expanded(
                flex:  searchResults.isNotEmpty ? 4 : 5,
                child:  SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(40),

                    child: Container(
                      width: screenWidth * 0.8,
                     height: screenWidth* 0.29,

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
                            offset: Offset(0,3),
                          )
                        ],borderRadius: BorderRadius.circular(12),
                      ),
                      child: Form(
                        key: widget.formKey,
                        child:
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            _buildTitleWithSearch(),
                            SizedBox(height: screenWidth * 0.03),
                          _buildFormRow(screenWidth, [
                            _buildStandardTextField(productNoController, 'PRODUCT NUMBER'),
                            _buildStandardTextField(revController, 'REV'),
                            _buildStandardTextField(statusController, 'STATUS'),
                            _buildStandardTextField(typeController, 'TYPE'),
                            _buildStandardTextField(descriptionController, 'DESCRIPTION'),
                            // ... other fields// Custom field with date picker
                            // ... other fields
                          ]),

                          SizedBox(height: screenWidth * 0.01),
                          _buildFormRow(screenWidth, [
                            _buildStandardTextField(labelDescController, 'LABEL DESCRIPTION'),
                            _buildStandardTextField(configurationController, 'CONFIGURATION'),
                            _buildStandardTextField(labelConfigController, 'LABEL CONFIGURATION'),
                            _buildDateModifiedField(),
                            _buildCompanyDropdownField(companyNameController, companies)
                            // ... other fields// Custom field with date picker
                            // ... other fields
                          ]),

                            SizedBox(height: screenWidth * 0.01),
                            // Add more rows of fields in similar fashion
                            // ... (add other rows here)
                            _buildFormRow(screenWidth, [
                              _buildStandardTextField(commentsController, 'COMMENTS'),
                              // Custom field with date picker
                              // ... other fields
                            ]),
                            SizedBox(height: screenWidth *0.03),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *0.02,
                                ),
                                  child: Container(
                                    width: screenWidth*0.2,
                                    height: MediaQuery.of(context).size.height *0.05,
                                    child: ElevatedButton(
                                      onPressed: _onSubmitPressed,
                                      child: Text('Submit'),
                                    ),

                                  ),


                                ),
                                Container(
                                  width: screenWidth * 0.2,
                                  height: MediaQuery.of(context).size.height * 0.05,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (widget.formKey.currentState != null) {
                                        widget.formKey.currentState!.reset();
                                      }
                                      // Clear all the text controllers
                                      productNoController.clear();
                                      revController.clear();
                                      descriptionController.clear();
                                      configurationController.clear();
                                      companyNameController.clear();
                                      level1Controller.clear();
                                      typeController.clear();
                                      ecrController.clear();
                                      listpriceController.clear();
                                      commentsController.clear();
                                      statusController.clear();
                                      labelDescController.clear();
                                      productSpecController.clear();
                                      labelConfigController.clear();
                                      dateReqController.clear();
                                      dateDueController.clear();
                                      level2Controller.clear();
                                      level3Controller.clear();
                                      level4Controller.clear();
                                      level5Controller.clear();
                                      sequenceNumController.clear();
                                      locationWaresController.clear();
                                      locationAccpacController.clear();
                                      locationMisysController.clear();
                                      level6Controller.clear();
                                      level7Controller.clear();
                                      instGuideController.clear();
                                      // Set _isProductNumberValid to false

                                      setState(() {
                                        _isProductNumberValid = false;
                                        searchResults.clear();
                                      });
                                    },
                                    child: Text('Clear'),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),



                      ),
                    ),

                  ),
                ),
              ),
              if (searchResults.isNotEmpty)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Fixed header
                      Container(
                        padding: EdgeInsets.all(15),

                        child:
                        Text('PRODUCT NUMBER', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),

                      // Scrollable DataTable
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              columns: [DataColumn(label: Text(''))],
                              rows: searchResults.map((product) {
                                return DataRow(
                                  onSelectChanged: (bool? selected) {
                                    if (selected ?? false) {
                                      _showEditProductDialog(product);
                                    }
                                  },
                                  cells: [DataCell(Text(product.productno))],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),

                      // Fixed footer for pagination
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left),
                            onPressed: currentPage > 1 ? _goToPreviousPage : null,
                          ),
                          Text('Page $currentPage of ${((totalItems - 1) / 50).ceil()}'),
                          IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: currentPage < (totalItems / 50).ceil() ? _goToNextPage : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),



      ],
          )



      );
    }
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
      controller: dateReqController,
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
        await _selectDateTime(context, dateReqController);
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
