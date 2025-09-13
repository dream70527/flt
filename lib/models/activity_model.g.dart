// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      no: (json['no'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      activityId: json['activity_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      targets: json['targets'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String?,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      bannerDesktop: json['banner_desktop'] as String? ?? '',
      bannerMobile: json['banner_mobile'] as String? ?? '',
      banner: json['banner'] as String? ?? '',
      image: json['image'] as String? ?? '',
      url: json['url'] as String?,
      popup: (json['popup'] as num?)?.toInt() ?? 0,
      config: json['config'] as String?,
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'address': instance.address.toJson(),
      'no': instance.no,
      'type': instance.type,
      'activity_id': instance.activityId,
      'name': instance.name,
      'targets': instance.targets,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'banner_desktop': instance.bannerDesktop,
      'banner_mobile': instance.bannerMobile,
      'banner': instance.banner,
      'image': instance.image,
      'url': instance.url,
      'popup': instance.popup,
      'config': instance.config,
    };
