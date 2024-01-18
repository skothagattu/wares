import 'package:flutter/material.dart';
import 'package:resize/resize.dart';
import 'package:wares/models/products_submission.dart';

import '../models/products.dart';
import '../repositories/products_repository.dart';
import 'edit_products_form.dart';

class ProductTable extends StatefulWidget {
  final List<Product> products;
  final List<ProductSubmission> productSubmission;

  ProductTable({required this.products, required this.productSubmission});

  @override
  _ProductTableState createState() => _ProductTableState();
}

class _ProductTableState extends State<ProductTable> {
  List<Product> displayedProducts = [];
  int currentPage = 1;
  final pageSize = 15;
  final scrollController = ScrollController();
  String searchQuery = "";


  @override
  void initState() {
    super.initState();
    displayedProducts = List.from(widget.products);
    _fetchProducts();
  }


  _loadMoreProducts() async {
    currentPage++;
    var newProducts = await ProductRepository().fetchProductList(pageNumber: currentPage, pageSize: pageSize);
    setState(() {
      displayedProducts.addAll(newProducts.data.items);
    });
  }

  _fetchProducts({String? searchQuery}) async {
    var newProducts = await ProductRepository().fetchProductList(searchQuery: searchQuery);
    setState(() {
      displayedProducts = newProducts.data.items;
    });
  }
  Future<void> _refreshProducts() async {
    var newProducts = await ProductRepository().fetchProductList();
    setState(() {
      displayedProducts = newProducts.data.items;
    });
  }
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 15.0,
      thumbVisibility: true,
      controller: scrollController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            Row(
              children : [
                Expanded(child:
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _fetchProducts(searchQuery: value);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _fetchProducts(searchQuery: '');
                        });
                      },
                    ) : null,
                  ),
                ),
                ),

                InkWell(
                  onTap: _refreshProducts,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.refresh),
                        Text('Refresh'),
                      ],
                    ),
                  ),
                ),
                ]

            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('PRODUCTNO')),
                    DataColumn(label: Text('REV')),
                    DataColumn(label: Text('DESCRIPTION')),
                    DataColumn(label: Text('CONFIGURATION')),
                    DataColumn(label: Text('LLC')),
                    DataColumn(label: Text('LEVEL1')),
                    DataColumn(label: Text('TYPE')),
                    DataColumn(label: Text('ECR')),
                    DataColumn(label: Text('LISTPRICE')),
                    DataColumn(label: Text("COMMENTS")),
                    DataColumn(label: Text('ACTIVE')),
                    DataColumn(label: Text('LABEL_DESC')),
                    DataColumn(label: Text('PRODUCT_SPEC')),
                    DataColumn(label: Text('LABEL_CONFIG')),
                    DataColumn(label: Text('DATE_REQ')),
                    DataColumn(label: Text('DATE_DUE')),
                    DataColumn(label: Text('LEVEL2')),
                    DataColumn(label: Text('LEVEL3')),
                    DataColumn(label: Text('LEVEL4')),
                    DataColumn(label: Text('LEVEL5')),
                    DataColumn(label: Text('SEQUENCE_NUM')),
                    DataColumn(label: Text('LOCATION_WARES')),
                    DataColumn(label: Text('LOCATION_ACCPAC')),
                    DataColumn(label: Text('LOCATION_MISYS')),
                    DataColumn(label: Text('LEVEL6')),
                    DataColumn(label: Text('LEVEL7')),
                    DataColumn(label: Text('INST_GUIDE')),
                  ],
                  rows: displayedProducts
                      .map(
                        (product) {
                       /* print("Debug Product: $product");*/
                        return DataRow(cells: [
                          DataCell(Text(product.id.toString())),
                          DataCell(Text(product.productno)),
                          DataCell(Text(product.rev ?? 'N/A')),
                          DataCell(Text(product.description ?? 'N/A')),
                          DataCell(Text(product.configuration ?? 'N/A')),
                          /*DataCell(Text(product.llc?.toString() ?? 'N/A')),*/
                          DataCell(Text(product.leveL1 ?? 'N/A')),
                          DataCell(Text(product.type ?? 'N/A')),
                          DataCell(Text(product.ecr ?? 'N/A')),
                          DataCell(
                              Text(product.listprice?.toString() ?? 'N/A')),
                          DataCell(ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 100, // Set this width to your preference
                            ),
                            child: Text(
                              product.comments ?? 'N/A',
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),),
                          DataCell(Text(product.active ?? 'N/A')),
                          DataCell(Text(product.labeL_DESC ?? 'N/A')),
                          DataCell(Text(product.producT_SPEC ?? 'N/A')),
                          DataCell(Text(product.labeL_CONFIG ?? 'N/A')),
                          DataCell(Text(product.datE_REQ ?? 'N/A')),
                          DataCell(Text(product.datE_DUE ?? 'N/A')),
                          DataCell(Text(product.leveL2 ?? 'N/A')),
                          DataCell(Text(product.leveL3 ?? 'N/A')),
                          DataCell(Text(product.leveL4 ?? 'N/A')),
                          DataCell(Text(product.leveL5 ?? 'N/A')),
                          DataCell(
                              Text(product.sequencE_NUM?.toString() ?? 'N/A')),
                          DataCell(Text(product.locatioN_WARES ?? 'N/A')),
                          DataCell(Text(product.locatioN_ACCPAC ?? 'N/A')),
                          DataCell(Text(product.locatioN_MISYS ?? 'N/A')),
                          DataCell(Text(product.leveL6 ?? 'N/A')),
                          DataCell(Text(product.leveL7 ?? 'N/A')),
                          DataCell(Text(product.insT_GUIDE ?? 'N/A')),
                        ],
                          onSelectChanged: (isSelected) {
                            if (isSelected != null && isSelected) {
                              ProductSubmission productSubmission = ProductSubmission.fromProduct(product);
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    EditProductForm(productSubmission: productSubmission, onProductUpdated: (Product ){  } ),
                              );
                            }
                          },


                        );

                      }
                  )
                      .toList(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: _loadMoreProducts,
                child: Text("Load More"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
