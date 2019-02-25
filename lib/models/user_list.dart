import 'package:login_form/models/user_model.dart';

class UserList{
  final List<User> users;

  UserList({
    this.users,
    });

  factory UserList.fromJson(List<dynamic> parsedJson){
    List<User> users = new List<User>();
    users =parsedJson.map((i) => User.fromJson(i)).toList(growable: true);

    return new UserList(
      users: users,
    );
  }
}

