import 'dart:convert';

class UserInfoEntity {
  int no = 0;
  String account = '';
  String email = '';
  String emailAuth = '';
  String phoneNo = '';
  dynamic phoneAuth;
  dynamic lineId;
  dynamic wechatId;
  dynamic birthday;
  String nickname = '';
  dynamic gender;
  String bankAccountName = '';
  String idNumber = '';
  String role = '';
  String gameRole = '';
  String state = '';
  dynamic fbAccount;
  dynamic googleAccount;
  String welcomeMsg = '';
  String addTime = '';
  String addIp = '';
  String lastLoginTime = '';
  String lastLoginIp = '';
  String device = '';
  String host = '';
  String lastLoginArea = '';
  String lastLoginIsp = '';
  String introducerCode = '';
  bool hasUnread = false;
  int unreadCount = 0;
  int rewardNum = 0;
  String zipCode = '';
  String city = '';
  String address = '';
  String token = '';
  int vipLevel = 0; // vip等级

  UserInfoEntity();

  factory UserInfoEntity.fromJson(Map<String, dynamic> json) {
    final entity = UserInfoEntity();
    entity.no = json['no'] ?? 0;
    entity.account = json['account'] ?? '';
    entity.email = json['email'] ?? '';
    entity.emailAuth = json['email_auth'] ?? '';
    entity.phoneNo = json['phone_no'] ?? '';
    entity.phoneAuth = json['phone_auth'];
    entity.lineId = json['line_id'];
    entity.wechatId = json['wechat_id'];
    entity.birthday = json['birthday'];
    entity.nickname = json['nickname'] ?? '';
    entity.gender = json['gender'];
    entity.bankAccountName = json['bank_account_name'] ?? '';
    entity.idNumber = json['id_number'] ?? '';
    entity.role = json['role'] ?? '';
    entity.gameRole = json['game_role'] ?? '';
    entity.state = json['state'] ?? '';
    entity.fbAccount = json['fb_account'];
    entity.googleAccount = json['google_account'];
    entity.welcomeMsg = json['welcome_msg'] ?? '';
    entity.addTime = json['add_time'] ?? '';
    entity.addIp = json['add_ip'] ?? '';
    entity.lastLoginTime = json['last_login_time'] ?? '';
    entity.lastLoginIp = json['last_login_ip'] ?? '';
    entity.device = json['device'] ?? '';
    entity.host = json['host'] ?? '';
    entity.lastLoginArea = json['last_login_area'] ?? '';
    entity.lastLoginIsp = json['last_login_isp'] ?? '';
    entity.introducerCode = json['introducer_code'] ?? '';
    entity.hasUnread = json['has_unread'] ?? false;
    entity.unreadCount = json['unread_count'] ?? 0;
    entity.rewardNum = json['reward_num'] ?? 0;
    entity.zipCode = json['zip_code'] ?? '';
    entity.city = json['city'] ?? '';
    entity.address = json['address'] ?? '';
    entity.token = json['token'] ?? '';
    entity.vipLevel = json['vip_level'] ?? 0;
    return entity;
  }

  Map<String, dynamic> toJson() {
    return {
      'no': no,
      'account': account,
      'email': email,
      'email_auth': emailAuth,
      'phone_no': phoneNo,
      'phone_auth': phoneAuth,
      'line_id': lineId,
      'wechat_id': wechatId,
      'birthday': birthday,
      'nickname': nickname,
      'gender': gender,
      'bank_account_name': bankAccountName,
      'id_number': idNumber,
      'role': role,
      'game_role': gameRole,
      'state': state,
      'fb_account': fbAccount,
      'google_account': googleAccount,
      'welcome_msg': welcomeMsg,
      'add_time': addTime,
      'add_ip': addIp,
      'last_login_time': lastLoginTime,
      'last_login_ip': lastLoginIp,
      'device': device,
      'host': host,
      'last_login_area': lastLoginArea,
      'last_login_isp': lastLoginIsp,
      'introducer_code': introducerCode,
      'has_unread': hasUnread,
      'unread_count': unreadCount,
      'reward_num': rewardNum,
      'zip_code': zipCode,
      'city': city,
      'address': address,
      'token': token,
      'vip_level': vipLevel,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
