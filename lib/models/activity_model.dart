import 'package:json_annotation/json_annotation.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel {
  int no;
  String type;
  @JsonKey(name: 'activity_id')
  String activityId;
  String name;
  String targets;
  @JsonKey(name: 'start_time')
  String startTime;
  @JsonKey(name: 'end_time')
  String? endTime;
  String title;
  String? subtitle;
  @JsonKey(name: 'banner_desktop')
  String bannerDesktop;
  @JsonKey(name: 'banner_mobile')
  String bannerMobile;
  String banner;
  String image;
  String? url;
  int popup;
  String? config;

  ActivityModel({
    this.no = 0,
    this.type = '',
    this.activityId = '',
    this.name = '',
    this.targets = '',
    this.startTime = '',
    this.endTime,
    this.title = '',
    this.subtitle,
    this.bannerDesktop = '',
    this.bannerMobile = '',
    this.banner = '',
    this.image = '',
    this.url,
    this.popup = 0,
    this.config,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}