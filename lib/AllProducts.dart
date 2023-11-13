
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  // Add more controllers as needed
  late FocusNode productNoFocusNode;
  @override
  void initState() {
    super.initState();
    productNoController = TextEditingController(text: widget.productSubmission.productno);
    revController = TextEditingController(text: widget.productSubmission.rev);
    descriptionController = TextEditingController(text: widget.productSubmission.description);
    configurationController = TextEditingController(text: widget.productSubmission.configuration);
    llcController = TextEditingController(text: widget.productSubmission.llc?.toString() ?? '');
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
    llcController.dispose();
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




  void navigateLookUp(BuildContext ctx){
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return LookupListScreen();
    }));
  }


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


          body: Stack(
            children: [
              Positioned(
                  top: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: (){
                      navigateLookUp(context);
                    },
                    child: Text("Look Up"),
                  )
              ),
              Center(
                child:  SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top:50,left: 40, right: 40, bottom: 40),

                    child: Container(
                      width: screenWidth * 0.8,
                      /* height: screenWidth* 0.35,*/
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "ALL PRODUCTS"
                                    ,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: screenWidth *0.03),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    SizedBox(width: screenWidth *0.03, height: 10,),
                                    Flexible(child: SizedBox(
                                      width: 200,

                                      child:
                                      TextFormField(
                                        controller: productNoController,
                                        focusNode: productNoFocusNode,
                                        decoration: InputDecoration(
                                          labelText: 'PRODUCT NUMBER',
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,  // This makes the labelText bold
                                          ),
                                          suffixIcon: _isProductNumberValid ? Icon(Icons.check_circle, color: Colors.green) : null,

                                        ),

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
                                      ),
                                    ),
                                    ),

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
                                        ),
                                      ),
                                    ),),
                                    SizedBox(width: screenWidth *0.03),

                                  ],
                                ),

                                SizedBox(height: screenWidth *0.01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
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
                                        ),
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
                                        ),
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
                                        ),
                                      ),
                                    ),),

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
                                        ),
                                      ),
                                    ),),

                                    SizedBox(width: screenWidth *0.03),
                                    Flexible(child: SizedBox(
                                      width: screenWidth*0.3,
                                      child:
                                      GestureDetector(
                                        onTap: () => _selectDateTime(context, dateReqController),
                                        child: AbsorbPointer(
                                          child: TextFormField(
                                            controller: dateReqController,
                                            decoration: InputDecoration(
                                                labelText: 'DATE REQUIRED',
                                                labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),),
                                    SizedBox(width: screenWidth *0.03),
                                  ],
                                ),
                                SizedBox(height: screenWidth *0.01),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: screenWidth *0.03, height: 10,),
                                    Flexible(child: SizedBox(
                                      width: screenWidth*0.3,
                                      child:
                                      GestureDetector(
                                        onTap: () => _selectDateTime(context, dateDueController),
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
                                            ),
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

                                        ),
                                      ),
                                    ),


                                    ),

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

                                        ),
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

                                        ),
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

                                        ),
                                      ),
                                    ),),
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
                                        controller: level3Controller,
                                        decoration: InputDecoration(
                                          labelText: 'LEVEL 3',
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,  // This makes the labelText bold
                                          ),

                                        ),
                                      ),
                                    ),


                                    ),
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

                                        ),
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

                                        ),
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

                                        ),
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

                                        ),
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

                                        ),
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

                                        ),
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

                                        ),
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

                                        ),
                                      ),
                                    ),


                                    ),

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

                                        ),
                                      ),
                                    ),


                                    ),
                                    SizedBox(width: screenWidth *0.03),
                                  ],
                                ),



                              ],
                            ),

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
                                      onPressed: () {
                                        if (widget.formKey.currentState!.validate()) {
                                          final createProductSubmission = ProductSubmission(
                                            productno: productNoController.text,
                                            rev: _emptyToNull(revController.text),
                                            description: _emptyToNull(descriptionController.text),
                                            configuration: _emptyToNull(configurationController.text),
                                            llc: _emptyToNull(llcController.text),
                                            level1: _emptyToNull(level1Controller.text),
                                            type: _emptyToNull(typeController.text),
                                            ecr: _emptyToNull(ecrController.text),
                                            listprice: _emptyToNull(listpriceController.text),
                                            comments: _emptyToNull(commentsController.text),
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
                                        }
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
                                      // Set _isProductNumberValid to false
                                      setState(() {
                                        _isProductNumberValid = false;
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
            ],
          )



      );
    }
    );

  }
  String? _emptyToNull(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }
    return input;
  }
}