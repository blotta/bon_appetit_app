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
}