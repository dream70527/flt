import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Address {
  String street;
  String city;

  Address(this.street, this.city);

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}