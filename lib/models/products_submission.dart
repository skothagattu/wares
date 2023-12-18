
import 'package:json_annotation/json_annotation.dart';
import 'package:wares/models/products.dart';

part 'products_submission.g.dart';
String? _emptyToNull(String? value) {
  return (value == null || value.trim().isEmpty) ? null : value;
}
@JsonSerializable()
class ProductSubmission {
  final String? id;
  final String? productno;
  final String? rev;
  final String? description;
  final String? configuration;
  final String? listprice;
  @JsonKey(name: 'leveL1')
  final String? level1;
  final String? type;
  final String? comments;
  final String? ecr;
  final String? active;
  @JsonKey(name: 'labeL_DESC')
  final String? labelDesc;
  @JsonKey(name: 'producT_SPEC')
  final String? productSpec;
  @JsonKey(name: 'labeL_CONFIG')
  final String? labelConfig;
  @JsonKey(name: 'datE_REQ')
  final String? dateReq;
  @JsonKey(name: 'datE_DUE')
  final String? dateDue;
  @JsonKey(name: 'leveL2')
  final String? level2;
  @JsonKey(name: 'leveL3')
  final String? level3;
  @JsonKey(name: 'leveL4')
  final String? level4;
  @JsonKey(name: 'leveL5')
  final String? level5;
  @JsonKey(name: 'sequencE_NUM')
  final String? sequenceNum;
  @JsonKey(name: 'locatioN_WARES')
  final String? locationWares;
  @JsonKey(name: 'locatioN_ACCPAC')
  final String? locationAccpac;
  @JsonKey(name: 'locatioN_MISYS')
  final String? locationMisys;
  @JsonKey(name: 'leveL6')
  final String? level6;
  @JsonKey(name: 'leveL7')
  final String? level7;
  @JsonKey(name: 'insT_GUIDE')
  final String? instGuide;
  final String? rowVersion;
  final String? companyName;

  ProductSubmission({
    this.id,
    this.productno,
    this.rev,
    this.description,
    this.configuration,
    this.listprice,
    this.level1,
    this.type,
    this.comments,
    this.ecr,
    this.active,
    this.labelDesc,
    this.productSpec,
    this.labelConfig,
    this.dateReq,
    this.dateDue,
    this.level2,
    this.level3,
    this.level4,
    this.level5,
    this.sequenceNum,
    this.locationWares,
    this.locationAccpac,
    this.locationMisys,
    this.level6,
    this.level7,
    this.instGuide,
    this.rowVersion,
    this.companyName
  });

  factory ProductSubmission.fromProduct(Product product) {
    return ProductSubmission(
      id: product.id?.toString(),
      productno: product.productno,
      rev: _emptyToNull(product.rev),
      description: _emptyToNull(product.description),
      configuration: _emptyToNull(product.configuration),
      listprice: _emptyToNull(product.listprice?.toString()),
      level1: _emptyToNull(product.leveL1),
      type: _emptyToNull(product.type),
      comments: _emptyToNull(product.comments),
      ecr: _emptyToNull(product.ecr),
      active: _emptyToNull(product.active),
      labelDesc: _emptyToNull(product.labeL_DESC),
      productSpec: _emptyToNull(product.producT_SPEC),
      labelConfig: _emptyToNull(product.labeL_CONFIG),
      dateReq: _emptyToNull(product.datE_REQ),
      dateDue: _emptyToNull(product.datE_DUE),
      level2: _emptyToNull(product.leveL2),
      level3: _emptyToNull(product.leveL3),
      level4: _emptyToNull(product.leveL4),
      level5: _emptyToNull(product.leveL5),
      sequenceNum: _emptyToNull(product.sequencE_NUM?.toString()),
      locationWares: _emptyToNull(product.locatioN_WARES),
      locationAccpac: _emptyToNull(product.locatioN_ACCPAC),
      locationMisys: _emptyToNull(product.locatioN_MISYS),
      level6: _emptyToNull(product.leveL6),
      level7: _emptyToNull(product.leveL7),
      instGuide: _emptyToNull(product.insT_GUIDE),
        rowVersion: _emptyToNull(product.rowVersion),
      companyName: _emptyToNull(product.companyName),
    );
  }




  factory ProductSubmission.fromJson(Map<String, dynamic> json) => _$ProductSubmissionFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSubmissionToJson(this);
}

