import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:wares/models/products.dart';
import 'package:wares/repositories/products_repository.dart';
import 'package:wares/models/products_submission.dart';

final productsRepositoryProvider = Provider<IProductRepository>((ref)=> ProductRepository());
final productList = FutureProvider.autoDispose<ProductListResponse>((ref) async{
  final repository = ref.watch(productsRepositoryProvider);
  return repository.fetchProductList(pageNumber: 1, pageSize: 50);
});

final updateProductProvider = FutureProvider.autoDispose.family<bool,Tuple2<String, ProductSubmission>>((ref, tuple) async {
  final repository = ref.watch(productsRepositoryProvider);
  return await repository.updateProduct(tuple.item1, tuple.item2);
});

