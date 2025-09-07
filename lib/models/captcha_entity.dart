class CaptchaEntity {
  final String key;
  final String img;

  CaptchaEntity({
    required this.key,
    required this.img,
  });

  factory CaptchaEntity.fromJson(Map<String, dynamic> json) {
    return CaptchaEntity(
      key: json['key'] ?? '',
      img: json['img'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'img': img,
    };
  }
}