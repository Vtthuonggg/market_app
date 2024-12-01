import 'package:nylo_framework/nylo_framework.dart';

class User extends Model {
  String? name;
  String? email;
  String? note;
  String? phone;
  String? storeName;
  String? avatar;

  User();

  User.fromJson(dynamic data) {
    name = data['name'];
    email = data['email'];
    phone = data['phone_number'];
    storeName = data['store_name'];
    note = data['notes'];
    avatar = data['avatar'];
  }

  @override
  toJson() => {
        "name": name,
        "phone_number": phone,
        "store_name": storeName,
        "notes": note,
        "avatar": avatar,
      };
}
