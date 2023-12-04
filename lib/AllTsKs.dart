import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wares/repositories/KitBomRepository.dart';
import 'package:wares/repositories/products_repository.dart';
import 'package:wares/screens/AddKitForm.dart';
import 'package:wares/screens/DeleteKitForm.dart';
import 'package:wares/screens/SearchByProductForm.dart';
import 'package:wares/screens/UpdateKitForm.dart';
import 'package:wares/screens/lookup_list_screen.dart';
import 'main.dart';
import 'models/KitBomItem.dart';
import 'models/products.dart';
enum DisplayState { search,searchByProd, add, update, delete }
class AllTsKs extends StatefulWidget{
   AllTsKs({Key? key}) : super(key: key);
  void navigateBack(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return MyApp();
    }));
  }
  final formKey = GlobalKey<FormState>();


  @override
  State<AllTsKs> createState() => _AllTsKsState();
}

class _AllTsKsState extends State<AllTsKs> {
  bool _isDataVisible = false;

  late TextEditingController productNoController;
  late TextEditingController revController;
  late TextEditingController statusController;
  late TextEditingController typeController;
  late TextEditingController descriptionController;
  late TextEditingController configurationController;
  late TextEditingController llcController;
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
  List<KitBomItem> kitBomItems = [];
  final KitBomRepository kitBomRepository = KitBomRepository();
  late FocusNode productNoFocusNode;

  @override
  void initState() {
    super.initState();
    productNoFocusNode = FocusNode();
    productNoFocusNode.addListener(() {
      if (!productNoFocusNode.hasFocus) {
        // Call the API here
        fetchAndDisplayProductDetails(productNoController.text);
      }
    });
    productNoController = TextEditingController();
    revController = TextEditingController();
    descriptionController = TextEditingController();
    configurationController = TextEditingController();
    llcController = TextEditingController();
    level1Controller = TextEditingController();
    typeController = TextEditingController();
    ecrController = TextEditingController();
    listpriceController =TextEditingController();
    commentsController = TextEditingController();
    statusController = TextEditingController();
    labelDescController = TextEditingController();
    productSpecController = TextEditingController();
    labelConfigController = TextEditingController();
    dateReqController = TextEditingController();
    dateDueController = TextEditingController();
    level2Controller = TextEditingController();
    level3Controller = TextEditingController();
    level4Controller = TextEditingController();
    level5Controller = TextEditingController();
    sequenceNumController = TextEditingController();
    locationWaresController = TextEditingController();
    locationAccpacController = TextEditingController();
    locationMisysController = TextEditingController();
    level6Controller = TextEditingController();
    level7Controller = TextEditingController();
    instGuideController = TextEditingController();




  }
 fetchAndDisplayKitBomItems(String kitNo) async {
    try {
      List<KitBomItem> items = await kitBomRepository.fetchKitBomItems(kitNo);
      if (items.isNotEmpty) {
        // Kit number exists in KitBom and has components
        setState(() {
          kitBomItems = items;
          _isDataVisible = true; // Set this to true to show the DataTable
        });
      } else {
        // Kit number does not exist in KitBom
        _clearForm(); // Clear all form fields
        setState(() {
          kitBomItems.clear();
          _isDataVisible = false; // Set this to false to hide the DataTable
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kit number is not available in KitBom")),
        );
      }
    } catch (e) {
      if (e is NotFoundException) {
        // Handle the case where the kit number does not exist in both ProductTable and KitBom
        _clearForm(); // Clear all form fields
        setState(() {
          _isDataVisible = false; // Set this to false to hide the DataTable
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Kit number does not exist")),
        );
      } else {
        // Handle other errors
        print(e);
        setState(() {
          _isDataVisible = false; // Set this to false to hide the DataTable
        });
      }
    }
  }




  void handleSubmit() async {
    if (widget.formKey.currentState!.validate()) {
      // Form is valid, proceed to fetch data
      String kitNo = productNoController.text;
      await fetchAndDisplayKitBomItems(kitNo);
      await fetchAndDisplayProductDetails(kitNo);
    }
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

        String formattedDateTime = "${selectedDateTime.toLocal()}".split('.')[0];
        controller.text = formattedDateTime;
      }
    }
  }
  final ProductRepository productRepository = ProductRepository();
  bool _showProductDetails = false;

  fetchAndDisplayProductDetails(String productNo) async {
    try {
      List<KitBomItem> kitBomItems = await kitBomRepository.fetchKitBomItems(productNo);
      bool existsInKitBom = kitBomItems.isNotEmpty;

      if (!existsInKitBom) {
        _clearForm();
        setState(() {
          _isDataVisible = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Product exists but Kit does not exist")),
        );
      } else {
        Product? product = await productRepository.fetchProductDetails(productNo);
        if (product != null)  {
          // Update your controllers here with the data from 'product'
          revController.text = product.rev ?? '';
          descriptionController.text = product.description ?? '';
          configurationController.text = product.configuration ?? '';
          llcController.text = product.llc.toString() ?? '';
          level1Controller.text = product.leveL1 ?? '';
          level2Controller.text = product.leveL2 ?? '';
          level3Controller.text = product.leveL3 ?? '';
          level4Controller.text = product.leveL4 ?? '';
          level5Controller.text = product.leveL5 ?? '';
          level6Controller.text = product.leveL6 ?? '';
          level7Controller.text = product.leveL7 ?? '';
          typeController.text = product.type ?? '';
          ecrController.text = product.ecr ?? '';
          listpriceController.text = product.listprice.toString() ?? '';
          commentsController.text = decodeBase64String(product.comments ?? '');
          statusController.text = product.active ?? '';
          productSpecController.text = product.producT_SPEC ?? '';
          labelDescController.text = product.labeL_DESC ?? '';
          labelConfigController.text = product.labeL_CONFIG ?? '';
          dateReqController.text = product.datE_REQ ?? '';
          dateDueController.text = product.datE_DUE ?? '';
          sequenceNumController.text = product.sequencE_NUM.toString() ?? '';
          locationWaresController.text = product.locatioN_WARES ?? '';
          locationAccpacController.text = product.locatioN_ACCPAC ?? '';
          locationMisysController.text = product.locatioN_MISYS ?? '';
          instGuideController.text = product.insT_GUIDE ?? '';

          setState(() {
            _showProductDetails = true; // Set to true to show the product details
          });
          // ... [Update other controllers similarly]
        } else {
          _clearForm();
          setState(() {
            _isDataVisible = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Product details not found")),
          );
        }
      }

    } catch (e) {
      // Handle other errors
      print(e);
      setState(() {
        _showProductDetails = false; // Hide the details section in case of error
      });
    }
  }
  void _clearForm() {
    // Clear all the text controllers
 /*   productNoController.clear();*/
    revController.clear();
    statusController.clear();
    typeController.clear();
    descriptionController.clear();
    configurationController.clear();
    llcController.clear();
    level1Controller.clear();
    ecrController.clear();
    listpriceController.clear();
    commentsController.clear();
    labelDescController.clear();
    productSpecController.clear();
    labelConfigController.clear();
    dateReqController.clear();
    dateDueController.clear();
    level2Controller.clear();
    level3Controller.clear();
    level4Controller.clear();
    level5Controller.clear();
    level6Controller.clear();
    level7Controller.clear();
    sequenceNumController.clear();
    locationWaresController.clear();
    locationAccpacController.clear();
    locationMisysController.clear();
    instGuideController.clear();

    setState(() {
      _isDataVisible = false; // Hide the DataTable
      kitBomItems.clear(); // Clear the kitBomItems list
    });
  }

  void navigateLookUp(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return LookupListScreen();
    }));
  }
  DisplayState _currentDisplay = DisplayState.search;
  void _changeDisplay(DisplayState state) {
    setState(() {
      _currentDisplay = state;
    });
  }


  String decodeBase64String(String base64String) {
    if (base64String.isEmpty) {
      return "";
    }
    try {
      return utf8.decode(base64.decode(base64String));
    } catch (e) {
      print("Error decoding Base64 string: $e");
      return "Error in decoding";
    }
  }

// Use this method wherever you need to decode a base64 string.


  @override
  void dispose() {
    productNoFocusNode.dispose();
    // Dispose other controllers and focus nodes
    super.dispose();
  }


  List<Map<String, dynamic>> kitData = [];
  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth * 0.6;

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

        body: Column(
          children: [
            _buildActionButtons(context),
            Expanded(child: _buildContent(context))
          ],
        )



    );

  }

  Widget _buildContent(BuildContext context) {
    switch (_currentDisplay) {
      case DisplayState.search:
        return _buildSearchForm(context);
      case DisplayState.searchByProd:
        return SearchByProductForm(); // Method that returns your search form and datatable
      case DisplayState.add:
        return AddKitForm(); // Widget for adding kits
      case DisplayState.update:
        return UpdateKitForm(); // Widget for updating
      case DisplayState.delete:
        return DeleteKitForm(); // Widget for deleting
      default:
        return Container(); // Fallback for an undefined state
    }
  }
  Widget _buildActionButtons(BuildContext context)

  {
    double screenWidth = MediaQuery.of(context).size.width;
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        SizedBox(height: screenWidth *0.06),
        SizedBox(width: screenWidth *0.06),
        ElevatedButton(onPressed: () => _changeDisplay(DisplayState.search), child: Text('Search By Kit')),
        SizedBox(width: screenWidth *0.06),
        ElevatedButton(onPressed: () => _changeDisplay(DisplayState.searchByProd), child: Text('Search By Product')),
        SizedBox(width: screenWidth *0.06),
        ElevatedButton(onPressed: () => _changeDisplay(DisplayState.update), child: Text('Modify')),
        SizedBox(width: screenWidth *0.06),
        ElevatedButton(onPressed: () => _changeDisplay(DisplayState.delete), child: Text('Delete')),
        SizedBox(width: screenWidth *0.06),
        ElevatedButton(onPressed: () {navigateLookUp(context);}, child: Text('LookUp')),
      ],
    );
  }
  Widget _buildSearchForm(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double formWidth = screenWidth * 0.6;

    return  Column(
      children: [
        // Row for Add, Update, Delete buttons

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top:10,left: 40, right: 40, bottom: 50),
                  child: Container(
                    width: formWidth,
                    /* height: screenWidth* 0.25,*/
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

                    child:  Form(
                      key: widget.formKey,
                      child:
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "T's K's AND A's",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                              SizedBox(height: screenWidth *0.06),
                            ],

                          ),

                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.15,

                                    child:
                                    TextFormField(
                                      controller: productNoController,
                                      focusNode: productNoFocusNode,
                                      decoration: InputDecoration(
                                        labelText: 'KIT NUMBER',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),
                                      /* onFieldSubmitted: (value) {
                                              // Call the method when the user submits the product number
                                              fetchAndDisplayProductDetails(value);
                                            },*/
                                    ),
                                  ),),
                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: revController,
                                      decoration: InputDecoration(
                                        labelText: 'REV',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),
                                      readOnly: true,
                                    ),
                                  ),),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: statusController,
                                      decoration: InputDecoration(
                                        labelText: 'STATUS',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),
                                      readOnly: true,
                                    ),
                                  ),
                                  ),
                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: typeController,
                                      decoration: InputDecoration(
                                        labelText: 'TYPE',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),
                                      readOnly: true,
                                    ),
                                  ),
                                  ),

                                  SizedBox(width: screenWidth *0.03),
                                ],
                              ),

                              SizedBox(height: screenWidth *0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,
                                    child:
                                    TextFormField(
                                      controller: descriptionController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'DESCRIPTION',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),
                                      ),readOnly: true,
                                    ),
                                  ),),

                                  SizedBox(width: screenWidth *0.03, height: 10,),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,
                                    child:
                                    TextFormField(
                                      controller: labelDescController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'LABEL DESCRIPTION',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),
                                      ),readOnly: true,
                                    ),
                                  ),),
                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,
                                    child:
                                    TextFormField(
                                      controller: configurationController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'CONFIGURATION',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),
                                      ),readOnly: true,
                                    ),
                                  ),),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,
                                    child:
                                    TextFormField(
                                      controller: labelConfigController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'LABEL CONFIGURATION',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),
                                      ),readOnly: true,
                                    ),
                                  ),),


                                  SizedBox(width: screenWidth *0.03),
                                ],
                              ),
                              SizedBox(height: screenWidth *0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,
                                    child:
                                    TextFormField(
                                      controller: listpriceController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'LIST PRICE',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),
                                      ),readOnly: true,
                                    ),
                                  ),),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,
                                    child:
                                    GestureDetector(
                                      /*onTap: () => _selectDateTime(context, dateReqController),*/
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          controller: dateReqController,
                                          decoration: InputDecoration(
                                              labelText: 'DATE REQUIRED',
                                              labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )
                                          ),readOnly: true,
                                        ),
                                      ),
                                    ),
                                  ),),
                                  SizedBox(width: screenWidth *0.03, height: 10,),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,
                                    child:
                                    GestureDetector(
                                      /*onTap: () => _selectDateTime(context, dateDueController),*/
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                          controller: dateDueController,
                                          decoration: InputDecoration(
                                              labelText: 'DATE DUE',
                                              labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )
                                          ),readOnly: true,
                                        ),
                                      ),
                                    ),
                                  ),),
                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,

                                    child:
                                    TextFormField(
                                      controller: llcController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'LLC',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),


                                  SizedBox(width: screenWidth *0.03),
                                ],
                              ),

                              SizedBox(height: screenWidth *0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,

                                    child:
                                    TextFormField(
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      controller: productSpecController,
                                      decoration: InputDecoration(
                                        labelText: 'PRODUCT SPECIFICATION',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,
                                    child:
                                    TextFormField(
                                      controller: level1Controller,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'LEVEL 1',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: screenWidth*0.3,
                                    child:
                                    TextFormField(
                                      controller: level2Controller,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'LEVEL 2',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),),
                                  SizedBox(width: screenWidth *0.03, height: 10,),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: level3Controller,
                                      decoration: InputDecoration(
                                        labelText: 'LEVEL 3',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),


                                  //

                                  SizedBox(width: screenWidth *0.03),
                                ],
                              ),
                              SizedBox(height: screenWidth *0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: level4Controller,
                                      decoration: InputDecoration(
                                        labelText: 'LEVEL 4',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),
                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: level5Controller,
                                      decoration: InputDecoration(
                                        labelText: 'LEVEL 5',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: level6Controller,
                                      decoration: InputDecoration(
                                        labelText: 'LEVEL 6',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: level7Controller,
                                      decoration: InputDecoration(
                                        labelText: 'LEVEL 7',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),
                                  ),
                                  SizedBox(width: screenWidth *0.03),
                                ],
                              ),
                              SizedBox(height: screenWidth *0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: screenWidth *0.03, height: 10,),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: sequenceNumController,
                                      decoration: InputDecoration(
                                        labelText: 'SEQUENCE NO',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),
                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: locationWaresController,
                                      decoration: InputDecoration(
                                        labelText: 'LOCATION WARES',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: locationAccpacController,
                                      decoration: InputDecoration(
                                        labelText: 'LOCATION ACCPAC',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: locationMisysController,
                                      decoration: InputDecoration(
                                        labelText: 'LOCATION MISYS',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),
                                  SizedBox(width: screenWidth *0.03),
                                ],
                              ),
                              SizedBox(height: screenWidth *0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [


                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,

                                    child:
                                    TextFormField(
                                      controller: instGuideController,
                                      decoration: InputDecoration(
                                        labelText: 'INST GUIDE',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),readOnly: true,
                                    ),
                                  ),


                                  ),

                                  SizedBox(width: screenWidth *0.03),
                                  Flexible(child: SizedBox(
                                    width: 200,
                                    child:
                                    TextFormField(
                                      controller: commentsController,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'COMMENT',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,  // This makes the labelText bold
                                        ),

                                      ),
                                    ),
                                  ),),
                                  SizedBox(width: screenWidth *0.03),
                                ],
                              ),

                            ],
                          ),
                          SizedBox(height: screenWidth *0.01),
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
                                    onPressed: () {
                                      // Validate the form data here.
                                      handleSubmit();
                                    },
                                    child: Text('Submit'),
                                  ),
                                ),

                              ),
                              Container(
                                width: screenWidth * 0.2,
                                height: MediaQuery.of(context).size.height * 0.05,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Clear all the text controllers
                                    productNoController.clear();
                                    revController.clear();
                                    descriptionController.clear();
                                    configurationController.clear();
                                    llcController.clear();
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
                                    setState(() {
                                      _showProductDetails = false;
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
              _isDataVisible
                  ? _buildDataTable()
                  : Container(),
            ],
          ),


        ),

      ],
    );
  }
  Widget _buildDataTable() {
    return Expanded(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Product No')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('List Price')),
        ],
        rows: kitBomItems.map((item) => DataRow(cells: [
          DataCell(Text(item.productNo)),
          DataCell(Text(item.quantity.toString())),
          DataCell(Text(item.listPrice.toString())),
        ])).toList(),
      ),
    );
  }


}
