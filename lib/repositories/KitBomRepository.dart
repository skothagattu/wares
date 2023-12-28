import 'dart:convert';
import '../Service/ApiService.dart';
import '../models/KitBomItem.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../models/KitByProductitem.dart';

abstract class IKitBomRepository {
  Future<List<KitBomItem>> fetchKitBomItems(String kitNo);
  Future<List<KitBomItem>> fetchKitBomItemsWithId(String kitNo);
  Future<List<KitByProductItem>> fetchKitsByProductNo(String productNo);
  Future<bool> createKitBom(String kitNo, List<KitBomItem> components);
  Future<bool> updateKitBom(String kitNo, List<KitBomItem> components);
  Future<bool> deleteKitComponent(String kitNo, String productNo);
  Future<bool> deleteKit(String kitNo);
}

class KitBomRepository implements IKitBomRepository {
  final _host = "http://10.89.2.117:86/Kits";
  final ApiService _apiService = ApiService();
  final Map<String, String> _headers = {
    "Accept": "application/json",
    "content-type": "application/json",
  };



  @override
  Future<List<KitBomItem>> fetchKitBomItems(String kitNo) async {
    final url = Uri.parse('$_host/$kitNo');
    final response = await _apiService.get(url.toString());
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> itemsJson = data['items'];
      return itemsJson.map((jsonItem) => KitBomItem.fromJson(jsonItem)).toList();
    } else if (response.statusCode == 404) {
      throw NotFoundException('KitBom items not found for kit number $kitNo');
    } else {
      // Handle other errors
      throw Exception('Failed to load KitBom items');
    }
  }

  @override
  Future<List<KitBomItem>> fetchKitBomItemsWithId(String kitNo) async {
    final url = Uri.parse('$_host/GetWithId/$kitNo');
    final response = await _apiService.get(url.toString());
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> itemsJson = data['items'];
      return itemsJson.map((jsonItem) => KitBomItem.fromJson(jsonItem)).toList();
    } else {
      // Handle errors
      throw Exception('Failed to load KitBom items');
    }
  }
  @override
  Future<List<KitByProductItem>> fetchKitsByProductNo(String productNo) async {
    final url = Uri.parse('$_host/kitsByComponent/$productNo');
    final response = await _apiService.get(url.toString());
    developer.log('URL: ${response.request?.url}', name: 'KitBomRepository');
    developer.log('Status code: ${response.statusCode}', name: 'KitBomRepository');

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> itemsJson = json.decode(response.body);
      return itemsJson.map((jsonItem) => KitByProductItem.fromJson(jsonItem)).toList();
    } else {
      // Handle errors
      throw Exception('Failed to load kits for product number $productNo');
    }
  }
  @override
  Future<bool> createKitBom(String kitNo, List<KitBomItem> components) async {
    final url = Uri.parse('$_host/Create');
    final body = json.encode({
      "kitNo": kitNo,
      "components": components.map((item) => item.toJson()).toList(),
    });

    final response = await _apiService.post(url.toString(), body);

    if (response.statusCode == 200) {
      return true;
    } else {
      // Handle errors
      throw Exception('Failed to create KitBom');
    }
  }
  @override
  Future<bool> updateKitBom(String kitNo, List<KitBomItem> components) async {
    final url = Uri.parse('$_host/Update'); // Adjust the endpoint as needed
    final body = json.encode({
      "kitNo": kitNo,
      "components": components.map((item) => item.toJson()).toList(),
    });

    final response = await _apiService.put(url.toString(), body);
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      // Handle errors
      throw Exception('Failed to update KitBom');
    }
  }
  @override
  Future<bool> deleteKitComponent(String kitNo, String productNo) async {
    final url = Uri.parse('$_host/DeleteComponent/$kitNo/$productNo'); // Adjust the endpoint as needed
    final response = await _apiService.get(url.toString());
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      // Handle errors
      throw Exception('Failed to delete KitBom component');
    }
  }

  @override
  Future<bool> deleteKit(String kitNo) async {
    final url = Uri.parse('$_host/DeleteKit/$kitNo'); // Adjust the endpoint as needed
    final response = await _apiService.get(url.toString());
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      // Handle errors
      throw Exception('Failed to delete kit');
    }
  }

}
class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => message;
}

