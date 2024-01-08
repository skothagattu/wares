import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Service/ApiService.dart';
import '../models/compat.dart'; // Define this model based on your needs

abstract class ICompatRepository {
  Future<List<String>> fetchDistinctModels();
  Future<List<String>> fetchDistinctProductTypes();
  Future<List<CompatModel>> fetchProductsByModelAndType(String model, String type);
}

class CompatRepository implements ICompatRepository {
  final _host = "http://10.89.2.120:86/Compat";// Adjust with your actual API endpoint
  final ApiService _apiService = ApiService();
  final Map<String, String> _headers = {
    "Accept": "application/json",
    "content-type": "application/json",
  };

  @override
  Future<List<String>> fetchDistinctModels() async {
    final url = Uri.parse('$_host/models');
    final response = await _apiService.get(url.toString());
/*    print('Status code1: ${response.statusCode}');
    print('Response body1: ${response.body}');*/
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load models');
    }
  }


  @override
  Future<List<String>> fetchDistinctProductTypes() async {
    final url = Uri.parse('$_host/productTypes');
    final response = await _apiService.get(url.toString());
    if (response.statusCode == 200) {
      List<dynamic> types = json.decode(response.body);
      // Filter out null and empty strings
      return types.where((type) => type != null && type.isNotEmpty).cast<String>().toList();
    } else {
      throw Exception('Failed to load product types');
    }
  }



  @override
  Future<List<CompatModel>> fetchProductsByModelAndType(String model, String type) async {
    final url = Uri.parse('$_host/products?model=$model&type=$type');
    final response = await _apiService.get(url.toString());
/*    print('Status code3: ${response.statusCode}');
    print('Response body3: ${response.body}');*/
    if (response.statusCode == 200) {
      final List<dynamic> productsJson = json.decode(response.body);
      return productsJson.map((jsonItem) => CompatModel.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

}
