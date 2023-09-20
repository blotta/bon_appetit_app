import 'dart:convert';

List<PartnerRestaurant> partnerRestaurantModelFromJson(String str) =>
    List<PartnerRestaurant>.from(
        json.decode(str).map((x) => PartnerRestaurant.fromJson(x)));

class PartnerRestaurant {
  const PartnerRestaurant(this.id, this.title, this.description, this.specialty,
      this.phoneNumber, this.enable, this.address);
  final String id;
  final String title;
  final String description;
  final String specialty;
  final String phoneNumber;
  final bool enable;
  final Address? address;

  factory PartnerRestaurant.fromJson(Map<String, dynamic> json) =>
      PartnerRestaurant(
          json["id"],
          json["title"],
          json["description"],
          json["specialty"],
          json["phoneNumber"],
          json["enable"],
          Address.fromJson(json['address']));
}

class Address {
  Address(this.country, this.state, this.city, this.district, this.streetName,
      this.streetNumber, this.zipCode);

  final String country;
  final String state;
  final String city;
  final String district;
  final String streetName;
  final String streetNumber;
  final String zipCode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      json["country"],
      json["state"],
      json["city"],
      json["district"],
      json["streetName"],
      json["streetNumber"],
      json["zipCode"]);
}

List<BriefPartnerRestaurant> briefPartnerRestaurantModelFromJson(String str) =>
    List<BriefPartnerRestaurant>.from(
        json.decode(str).map((x) => BriefPartnerRestaurant.fromJson(x)));

class BriefPartnerRestaurant {
  const BriefPartnerRestaurant(
      this.id, this.title, this.description, this.specialty);
  final String id;
  final String title;
  final String description;
  final String specialty;

  factory BriefPartnerRestaurant.fromJson(Map<String, dynamic> json) =>
      BriefPartnerRestaurant(
        json["id"],
        json["title"],
        json["description"],
        json["specialty"],
      );
}
