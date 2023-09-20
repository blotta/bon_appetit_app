import 'dart:convert';
import 'dart:typed_data';

import 'package:bon_appetit_app/config/apis.dart';
import 'package:bon_appetit_app/models/discovery_restaurant.dart';
import 'package:bon_appetit_app/models/partner_models.dart';
import 'package:http/http.dart' as http;

class BonAppetitLoginResponse {
  const BonAppetitLoginResponse({required this.id, required this.token});
  final String id;
  final String token;

  factory BonAppetitLoginResponse.fromJson(Map<String, dynamic> json) =>
      BonAppetitLoginResponse(id: json["id"], token: json["token"]);
}

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

  Future<DiscoveryRestaurant> getDiscoveryRestaurant(
      String restaurantId) async {
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

  Future<BonAppetitLoginResponse> postLoginWithEmailAndPassword(
      String email, String password) async {
    var url = Uri.parse('${Apis.baseUrl}/User/Login');
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    var content = json.encode({
      'username': email,
      'password': password,
    });

    var response = await http.patch(url, headers: headers, body: content);

    if (response.statusCode >= 400) {
      throw Exception('Error logging in');
    }

    var jd = json.decode(response.body);
    return BonAppetitLoginResponse.fromJson(jd);
  }

  Future<String> postRegisterWithEmailAndPassword(
      String name, String email, String password) async {
    var url = Uri.parse('${Apis.baseUrl}/User');

    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    var content = json.encode({
      'name': name,
      'username': email,
      'password': password,
    });

    var response = await http.post(url, headers: headers, body: content);

    if (response.statusCode >= 400) {
      throw Exception('Error logging in');
    }

    var userId = response.body;
    return userId;
  }

  Future<int> postMakeOrder(
      String restaurantId, List<DOrderItem> orderItems) async {
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
    Map<String, dynamic> body = {"partnerId": restaurantId, "itens": items};

    var content = json.encode(body);

    var response = await http.post(url, headers: headers, body: content);

    if (response.statusCode == 201) {
      var orderNumber = json.decode(response.body)['data']['number'];
      return orderNumber;
    }

    return -1;
  }

  Future<DOrder> getOrder(int orderNumber) async {
    var url = Uri.parse("${Apis.baseUrl}/order/$orderNumber");

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error loading orders');
    }

    var jd = json.decode(response.body)['message'];
    var order = DOrder.fromJson(jd);
    return order;
  }

  Future<List<DOrder>> getRestaurantOrders(String restaurantId) async {
    var url = Uri.parse("${Apis.baseUrl}/Order/Partner/$restaurantId");

    var response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error loading orders');
    }

    var jd = json.decode(response.body)['message'];
    var str = json.encode(jd);
    var orders = ordersModelFromJson(str);
    return orders;
  }

  Future<List<BriefPartnerRestaurant>> getPartnerRestaurants() async {
    var url = Uri.parse("${Apis.baseUrl}/Partner");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jd = json.decode(response.body)["message"];
      var str = json.encode(jd);
      List<BriefPartnerRestaurant> model =
          briefPartnerRestaurantModelFromJson(str);
      return model;
    } else {
      throw Exception('Error loading restaurants');
    }
  }

  Future<PartnerRestaurant> getPartnerRestaurant(String restaurantId) async {
    var url = Uri.parse("${Apis.baseUrl}/Partner/$restaurantId");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jd = json.decode(response.body)["message"];
      return PartnerRestaurant.fromJson(jd);
    } else {
      throw Exception('Error loading restaurants');
    }
  }

  Future<String?> postCreatePartner(PartnerRestaurant restaurant) async {
    var url = Uri.parse("${Apis.baseUrl}/Partner");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      "title": restaurant.title,
      "description": restaurant.description,
      "phoneNumber": restaurant.phoneNumber,
      "specialty": restaurant.specialty,
      "street": restaurant.address!.streetName,
      "streetNumber": restaurant.address!.streetNumber,
      "city": restaurant.address!.city,
      "zipCode": restaurant.address!.zipCode,
      "country": restaurant.address!.country,
      "state": restaurant.address!.state,
      "district": restaurant.address!.district
    };

    var content = json.encode(body);

    var response = await http.post(url, headers: headers, body: content);

    if (response.statusCode == 201) {
      var partnerId = json.decode(response.body)['aggregateId'];
      return partnerId;
    }

    return null;
  }

  Future<bool> putUpdatePartner(
      String restaurantId, PartnerRestaurant restaurant) async {
    var url = Uri.parse("${Apis.baseUrl}/Partner/$restaurantId");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      "title": restaurant.title,
      "description": restaurant.description,
      "phoneNumber": restaurant.phoneNumber,
      "specialty": restaurant.specialty,
      "street": restaurant.address!.streetName,
      "streetNumber": restaurant.address!.streetNumber,
      "city": restaurant.address!.city,
      "zipCode": restaurant.address!.zipCode,
      "country": restaurant.address!.country,
      "state": restaurant.address!.state,
      "district": restaurant.address!.district
    };

    var content = json.encode(body);

    var response = await http.put(url, headers: headers, body: content);

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> patchPartnerActivate(String restaurantId) async {
    var url = Uri.parse("${Apis.baseUrl}/Partner/Activate/$restaurantId");

    var response = await http.patch(url);

    if (response.statusCode < 400) {
      return true;
    }

    return false;
  }

  Future<bool> patchPartnerDeactivate(String restaurantId) async {
    var url = Uri.parse("${Apis.baseUrl}/Partner/Deactivate/$restaurantId");

    var response = await http.patch(url);

    if (response.statusCode < 400) {
      return true;
    }

    return false;
  }

  Future<List<DMenu>> getPartnerMenus(String restaurantId) async {
    var rest = await getDiscoveryRestaurant(restaurantId);
    if (rest.menu == null) {
      return [];
    }
    return [rest.menu!];
  }

  Future<DMenu?> getPartnerMenu(String restaurantId, String menuId) async {
    var rest = await getDiscoveryRestaurant(restaurantId);
    if (menuId == rest.menu!.id) {
      return rest.menu!;
    }
    return null;
  }

  Future<String?> postCreateMenu(String restaurantId, DMenu menu) async {
    var url = Uri.parse("${Apis.baseUrl}/Menu");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      "name": menu.name,
      "description": menu.name,
      "partnerId": restaurantId,
    };

    var content = json.encode(body);

    var response = await http.post(url, headers: headers, body: content);

    if (response.statusCode == 201) {
      var menuId = json.decode(response.body)['aggregateId'];
      return menuId;
    }

    return null;
  }

  Future<String?> postCreateMenuSection(
      String menuId, DMenuSection section) async {
    var url = Uri.parse("${Apis.baseUrl}/Menu/Section");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      "menuId": menuId,
      "name": section.name,
    };

    var content = json.encode(body);

    var response = await http.post(url, headers: headers, body: content);

    if (response.statusCode == 201) {
      var sectionId = json.decode(response.body)['aggregateId'];
      return sectionId;
    }

    return null;
  }

  Future<String?> deleteMenuSection(String menuId, String sectionId) async {
    var url = Uri.parse("${Apis.baseUrl}/Menu/$menuId/Section/$sectionId");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    var response = await http.delete(url, headers: headers);

    if (response.statusCode == 201) {
      var sectionId = json.decode(response.body)['aggregateId'];
      return sectionId;
    }

    return null;
  }

  Future<String?> postCreateMenuSectionProduct(
      String menuId, String sectionId, DProduct product) async {
    var url =
        Uri.parse("${Apis.baseUrl}/Menu/$menuId/Section/$sectionId/Product");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> body = {
      "name": product.name,
      "description": product.description,
      "price": product.price,
    };

    var content = json.encode(body);

    var response = await http.post(url, headers: headers, body: content);

    if (response.statusCode == 201) {
      var partnerId = json.decode(response.body)['aggregateId'];
      return partnerId;
    }

    return null;
  }

  Future<bool> uploadMenuSectionProductImage(String menuId, String sectionId,
      String productId, Uint8List pngBytes) async {
    var patchUrl = Uri.parse(
        "${Apis.baseUrl}/Menu/$menuId/Section/$sectionId/Product/$productId");

    var patchResponse = await http.patch(patchUrl);

    if (patchResponse.statusCode == 200) {
      var putUrl = Uri.parse(patchResponse.body);

      var headers = {
        'x-ms-blob-type': 'BlockBlob',
        'Content-Type': 'image/png'
      };

      var body = pngBytes;

      var putResponse = await http.put(putUrl, headers: headers, body: body);

      if (putResponse.statusCode == 201) {
        return true;
      }
    }

    return false;
  }

  Future<String?> deleteMenuSectionProduct(
      String menuId, String sectionId, String productId) async {
    var url = Uri.parse(
        "${Apis.baseUrl}/Menu/$menuId/Section/$sectionId/Product/$productId");
    var headers = <String, String>{
      'Content-Type': 'application/json',
    };

    var response = await http.delete(url, headers: headers);

    if (response.statusCode == 201) {
      var deletedProductId = json.decode(response.body)['aggregateId'];
      return deletedProductId;
    }

    return null;
  }
}
