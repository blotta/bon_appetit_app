import 'dart:convert';

List<DiscoveryRestaurant> discoveryRestaurantModelFromJson(String str) =>
    List<DiscoveryRestaurant>.from(
        json.decode(str).map((x) => DiscoveryRestaurant.fromJson(x)));

class DiscoveryRestaurant {
  const DiscoveryRestaurant(
      this.id, this.title, this.description, this.specialty, this.menu);
  final String id;
  final String title;
  final String description;
  final String specialty;
  final DMenu? menu;

  factory DiscoveryRestaurant.fromJson(Map<String, dynamic> json) =>
      DiscoveryRestaurant(
        json["id"],
        json["title"],
        json["description"],
        json["specialty"],
        (json['menu'] == null ? null : DMenu.fromJson(json["menu"])),
      );
}

class DMenu {
  const DMenu(this.id, this.name, this.sections);
  final String id;
  final String name;
  final List<DMenuSection> sections;

  factory DMenu.fromJson(Map<String, dynamic> json) {
    List<DMenuSection> sections = [];
    for (var i = 0; i < json['sections'].length; i++) {
      sections.add(DMenuSection.fromJson(json['sections'][i]));
    }
    return DMenu(json['id'], json['name'], sections);
  }
}

class DMenuSection {
  const DMenuSection(this.id, this.name, this.products);
  final String id;
  final String name;
  final List<DProduct> products;

  factory DMenuSection.fromJson(Map<String, dynamic> json) {
    List<DProduct> products = [];
    for (var i = 0; i < json['products'].length; i++) {
      products.add(DProduct.fromJson(json['products'][i]));
    }
    return DMenuSection(json['id'], json['name'], products);
  }
}

class DProduct {
  const DProduct(this.id, this.name, this.description, this.price, this.imageUrl);
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;

  factory DProduct.fromJson(Map<String, dynamic> json) => DProduct(
        json['id'],
        json['name'],
        json['description'],
        json['price'],
        json['imageUrl'],
      );
}

class DOrderItem {
  DOrderItem(this.item, this.quantity);
  final DProduct item;
  int quantity;

  factory DOrderItem.fromJson(Map<String, dynamic> json) => DOrderItem(
        DProduct.fromJson(json['item']),
        json['quantity'],
      );
}

class DComanda {
  DComanda(this.items);

  final List<DOrderItem> items;
}

List<DOrder> ordersModelFromJson(String str) =>
    List<DOrder>.from(
        json.decode(str).map((x) => DOrder.fromJson(x)));

class DOrder {
  DOrder(this.number, this.createdAt, this.canceled, this.total, this.itens);

  final int number;
  final DateTime createdAt;
  final bool canceled;
  final double total;
  final List<DOrderProduct> itens;

  factory DOrder.fromJson(Map<String, dynamic> json) {
    List<DOrderProduct> itens = [];
    for (var i = 0; i < json['itens'].length; i++) {
      itens.add(DOrderProduct.fromJson(json['itens'][i]));
    }
    return DOrder(
      json['number'],
      DateTime.parse(json['createdAt']),
      json['canceled'],
      json['total'],
      itens,
    );
  }
}

class DOrderProduct {
  DOrderProduct(
      this.name, this.description, this.price, this.quantity, this.total);

  final String name;
  final String description;
  final double price;
  final int quantity;
  final double total;

  factory DOrderProduct.fromJson(Map<String, dynamic> json) => DOrderProduct(
        json['name'],
        json['description'],
        json['price'],
        json['quantity'],
        json['total'],
      );
}
