class ProductListResponse {
  ProductListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  late final bool status;
  late final String message;
  late final ProductData data;

  ProductListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = ProductData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
  @override
  String toString() {
    return 'ProductListResponse{status: $status, message: $message, data: $data}';
  }
}

class ProductData {
  ProductData({
    required this.items,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
  });

  late final List<Product> items;
  late final int totalCount;
  late final int currentPage;
  late final int pageSize;
  late final int totalItems;

  ProductData.fromJson(Map<String, dynamic> json) {
    items = List.from(json['items']).map((e) => Product.fromJson(e)).toList();
    totalCount = json['totalCount'];
    currentPage = json['currentPage'];
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['items'] = items.map((e) => e.toJson()).toList();
    _data['totalCount'] = totalCount;
    _data['currentPage'] = currentPage;
    _data['pageSize'] = pageSize;
    _data['totalItems'] = totalItems;
    return _data;
  }
  @override
  String toString() {
    return 'ProductData{items: $items, totalCount: $totalCount, currentPage: $currentPage, pageSize: $pageSize, totalItems: $totalItems}';
  }
}

class Product {
  Product({
    required this.id,
    required this.productno,
    this.rev,
    this.alpha,
    this.description,
    this.configuration,
    this.leveL1,
    this.type,
    this.ecr,
    this.listprice,
    this.comments,
    this.active,
    this.labeL_DESC,
    this.producT_SPEC,
    this.labeL_CONFIG,
    this.datE_REQ,
    this.datE_DUE,
    this.leveL2,
    this.leveL3,
    this.leveL4,
    this.leveL5,
    this.sequencE_NUM,
    this.locatioN_WARES,
    this.locatioN_ACCPAC,
    this.locatioN_MISYS,
    this.leveL6,
    this.leveL7,
    this.insT_GUIDE,
    this.rowVersion,
    this.companyName,
  });

  late final int id;
  late final String productno;
  late final String? rev;
  late final String? alpha;
  late final String? description;
  late final String? configuration;
  late final String? leveL1;
  late final String? type;
  late final String? ecr;
  late final int? listprice;
  late final String? comments;
  late final String? active;
  late final String? labeL_DESC;
  late final String? producT_SPEC;
  late final String? labeL_CONFIG;
  late final String? datE_REQ;
  late final String? datE_DUE;
  late final String? leveL2;
  late final String? leveL3;
  late final String? leveL4;
  late final String? leveL5;
  late final int? sequencE_NUM;
  late final String? locatioN_WARES;
  late final String? locatioN_ACCPAC;
  late final String? locatioN_MISYS;
  late final String? leveL6;
  late final String? leveL7;
  late final String? insT_GUIDE;
  late final String? rowVersion;
  late final String? companyName;

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productno = json['productno'];
    rev = json['rev'];
    alpha = json['alpha'];
    description = json['description'];
    configuration = json['configuration'];
    leveL1 = json['leveL1'];
    type = json['type'];
    ecr = json['ecr'];
    listprice = json['listprice'];
    comments = json['comments'];
    active = json['active'];
    labeL_DESC = json['labeL_DESC'];
    producT_SPEC = json['producT_SPEC'];
    labeL_CONFIG = json['labeL_CONFIG'];
    datE_REQ = json['datE_REQ'];
    datE_DUE = json['datE_DUE'];
    leveL2 = json['leveL2'];
    leveL3 = json['leveL3'];
    leveL4 = json['leveL4'];
    leveL5 = json['leveL5'];
    sequencE_NUM = json['sequencE_NUM'];
    locatioN_WARES = json['locatioN_WARES'];
    locatioN_ACCPAC = json['locatioN_ACCPAC'];
    locatioN_MISYS = json['locatioN_MISYS'];
    leveL6 = json['leveL6'];
    leveL7 = json['leveL7'];
    insT_GUIDE = json['insT_GUIDE'];
    rowVersion = json['rowVersion'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['productno'] = productno;
    _data['rev'] = rev;
    _data['alpha'] = alpha;
    _data['description'] = description;
    _data['configuration'] = configuration;
    _data['leveL1'] = leveL1;
    _data['type'] = type;
    _data['ecr'] = ecr;
    _data['listprice'] = listprice;
    _data['comments'] = comments;
    _data['active'] = active;
    _data['labeL_DESC'] = labeL_DESC;
    _data['producT_SPEC'] = producT_SPEC;
    _data['labeL_CONFIG'] = labeL_CONFIG;
    _data['datE_Req'] = datE_REQ;
    _data['datE_Due'] = datE_DUE;
    _data['leveL2'] = leveL2;
    _data['leveL3'] = leveL3;
    _data['leveL4'] = leveL4;
    _data['leveL5'] = leveL5;
    _data['sequencE_NUM'] = sequencE_NUM;
    _data['locatioN_WARES'] = locatioN_WARES;
    _data['locatioN_ACCPAC'] = locatioN_ACCPAC;
    _data['locatioN_MISYS'] = locatioN_MISYS;
    _data['leveL6'] = leveL6;
    _data['leveL7'] = leveL7;
    _data['insT_GUIDE'] = insT_GUIDE;
    _data['rowVersion'] = rowVersion;
    _data['companyName'] = companyName;
    return _data;


  }
  @override
  String toString() {
    return 'Product{id: $id, productno: $productno, rev: $rev, description: $description, configuration: $configuration,companyName: $companyName level1: $leveL1, type: $type, ecr: $ecr, listprice: $listprice, comments: $comments, active: $active, labelDesc: $labeL_DESC, productSpec: $producT_SPEC, labelConfig: $labeL_CONFIG, dateReq: $datE_REQ, dateDue: $datE_DUE, level2: $leveL2, level3: $leveL3, level4: $leveL4, level5: $leveL5, sequenceNum: $sequencE_NUM, locationWares: $locatioN_WARES, locationAccpac: $locatioN_ACCPAC, locationMisys: $locatioN_MISYS, level6: $leveL6, level7: $leveL7, instGuide: $insT_GUIDE, rowVersion: $rowVersion}';
  }
}
