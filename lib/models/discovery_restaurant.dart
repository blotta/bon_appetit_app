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
    return DMenu(
        json['id'],
        json['name'],
        sections
      );
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
    return DMenuSection(
        json['id'],
        json['name'],
        products
      );
  }
}

class DProduct {
  const DProduct(this.id, this.name, this.description, this.price);
  final String id;
  final String name;
  final String description;
  final double price;

  factory DProduct.fromJson(Map<String, dynamic> json) => DProduct(
        json['id'],
        json['name'],
        json['description'],
        json['price'],
      );
}
