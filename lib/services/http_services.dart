import 'dart:convert';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';
import '../utility/constants.dart';

class HttpService  {
  final String baseUrl = MAIN_URL;

  //与C#的 TASK<IActionResult> 类似
  Future<Response> getItems({required String endpointUrl}) async {
    try {
      return await GetConnect().get('$baseUrl/$endpointUrl');
    } catch (e) {
      return Response(body: json.encode({'error': e.toString()}), statusCode: 500);
    }
  }

  //dynamic类似C++模板的T,区别在于虽然更灵活但相对没那么安全
  Future<Response> addItem({required String endpointUrl, required dynamic itemData}) async {
    try {
      final response = await GetConnect().post('$baseUrl/$endpointUrl',itemData);
      print(response.body);
      return response;
    } catch (e) {
      print('Error: $e');
      return Response(body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  //参数里包含者itemId和itemData,GetConnect就是连接那个网址，后面跟的是数据
  Future<Response> updateItem({required String endpointUrl, required String itemId, required dynamic itemData}) async {
    try {
      return await GetConnect().put('$baseUrl/$endpointUrl/$itemId', itemData);
    } catch (e) {
      return Response(body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }

  Future<Response> deleteItem({required String endpointUrl, required String itemId}) async {
    try {
      return await GetConnect().delete('$baseUrl/$endpointUrl/$itemId');
    } catch (e) {
      return Response(body: json.encode({'message': e.toString()}), statusCode: 500);
    }
  }
}
