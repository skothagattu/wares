import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:wares/models/products.dart';

import 'package:http/http.dart' as http;
import 'package:wares/models/products_submission.dart';

import '../Service/ApiService.dart';

abstract class IProductRepository {
  Future<ProductListResponse> fetchProductList({required int pageNumber, required int pageSize, String? searchQuery});
  Future<bool> updateProduct(String productNo, ProductSubmission productSubmission);
  Future<bool> createProduct(ProductSubmission productSubmission);
  Future<Tuple2<bool, Product?>> checkProduct(String productNo);
  Future<Product> fetchProductDetails(String productNo);
  Future<bool> hasRole(String requiredRole);
}

class ProductRepository implements IProductRepository{
  final _host = "https://localhost:44363/api/Products";
  final ApiService _apiService = ApiService();
  final Map<String, String> _headers = {
    "Accept" : "application/json",
    "content-type": "application/json",
  };

  @override
  Future<ProductListResponse> fetchProductList({int pageNumber = 1, int pageSize = 50, String? searchQuery}) async {
    var getAllProductsUrl = _host + "/GetAll?pageNumber=$pageNumber&pageSize=$pageSize";
    if (searchQuery != null && searchQuery.isNotEmpty) {
      getAllProductsUrl += "&searchQuery=$searchQuery";
    }
    /*var results = await http.get(Uri.parse(getAllProductsUrl), headers: _headers);
    *//*print('Raw JSON response: ${results.body}');*//*
    final jsonObject = json.decode(results.body);
    var response = ProductListResponse.fromJson(jsonObject);
*//*    print('ProductListResponse object: $response');*//*

    return response;*/
    var response = await _apiService.get(getAllProductsUrl);
    final jsonObject = json.decode(response.body);
    return ProductListResponse.fromJson(jsonObject);
  }

  @override
  Future<bool> updateProduct(String productNo,ProductSubmission productSubmission) async {
    final url = Uri.parse('$_host/updateProduct/$productNo'); // Adjust the URL as needed
    final productMap = productSubmission.toJson();
print(url);
    /*final response = await http.put(
      url,
      headers: _headers,
      body: json.encode(productMap),
     // Ensure your Product model has a toJson method
    );
    return response.statusCode == 200|| response.statusCode == 204;*/
    final response = await _apiService.put(url.toString(), productSubmission.toJson());
    print(response.body);
    return response.statusCode == 200 || response.statusCode == 204;// Adjust as needed based on your API's response
  }

  @override
  Future<bool> createProduct(ProductSubmission productSubmission) async {
    final url = Uri.parse('$_host/CreateProduct'); // Adjust the URL as needed
    final productMap = productSubmission.toJson();
    print(url);
    /*final response = await http.post(
      url,
      headers: _headers,
      body: json.encode(productMap),
    );
*/
    final response = await _apiService.post(url.toString(), productSubmission.toJson());
    print(response.body);
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    return response.statusCode == 201;  // Adjust as needed based on your API's response
  }

  @override
  Future<Tuple2<bool, Product?>> checkProduct(String productNo) async {
    final url = Uri.parse('$_host/$productNo');
    try {
      final response = await _apiService.get(url.toString());
      if (response.statusCode == 200) {
        final product = Product.fromJson(json.decode(response.body));
        return Tuple2(true, product);
      } else if (response.statusCode == 404) {
        return const Tuple2(false, null);
      } else {
        // Handle other HTTP status codes as needed
        print('Error checking product: ${response.body}');
        return const Tuple2(false, null);
      }
    } catch (e) {
      print('Error checking product: $e');
      return const Tuple2(false, null);
    }
  }

  @override
  Future<Product> fetchProductDetails(String productNo) async {
    final url = Uri.parse('$_host/$productNo');
    try {
      final response = await _apiService.get(url.toString());
      if (response.statusCode == 200) {
        final product = Product.fromJson(json.decode(response.body));
        return product;
      } else {
        // Handle other HTTP status codes as needed
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      // Handle any exceptions
      throw Exception('Error fetching product details: $e');
    }
  }
  @override

  Future<bool> hasRole(String requiredRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> roles = prefs.getStringList('roles') ?? [];
    return roles.contains(requiredRole);
  }


}

