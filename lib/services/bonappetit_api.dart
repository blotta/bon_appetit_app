import 'dart:convert';

import 'package:bon_appetit_app/config/apis.dart';
import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:http/http.dart' as http;

class BonAppetitApiService {

  Future<List<DiscoveryRestaurant>> getDiscoveryRestaurants() async {
    var url = Uri.parse("${Apis.baseUrl}/discover");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // return jsonDecode(utf8.decode(response.bodyBytes));
      var jd = json.decode(response.body)["message"];
      var str = json.encode(jd);
      List<DiscoveryRestaurant> model = discoveryRestaurantModelFromJson(str);
      return model;
    } else {
      throw Exception('Error loading restaurants');
    }
  }

  Future<DiscoveryRestaurant> getDiscoveryRestaurant(String restaurantId) async {
    var url = Uri.parse("${Apis.baseUrl}/discover");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      // return jsonDecode(utf8.decode(response.bodyBytes));
      var jd = json.decode(response.body)["message"];
      var str = json.encode(jd);
      List<DiscoveryRestaurant> model = discoveryRestaurantModelFromJson(str);
      var rest = model.firstWhere((r) => r.id == restaurantId);
      return rest;
    } else {
      throw Exception('Error loading restaurants');
    }
  }

  Future<int> postMakeOrder(String restaurantId, List<DOrderItem> orderItems) async {
    var url = Uri.parse("${Apis.baseUrl}/order");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    var items = [];
    for (var orderItem in orderItems) {
      Map<String, dynamic> item = {
        "productId": orderItem.item.id,
        "quantity": orderItem.quantity
      };
      items.add(item);
    }
    Map<String, dynamic> body = {
      "partnerId": restaurantId,
      "itens": items
    };

    var content = json.encode(body);

    var response = await http.post(url, headers: headers, body: content);

    if (response.statusCode == 201) {
      var orderNumber = json.decode(response.body)['data']['number'];
      return orderNumber;
    }

    return -1;
  }

  // Future<int> getOrder(int orderNumber) async {
  //   var url = Uri.parse("${Apis.baseUrl}/order/${orderNumber}");

  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     var orderNumber = json.decode(response.body)['data']['number'];
  //     return orderNumber;
  //   }

  //   return -1;
  // }
}