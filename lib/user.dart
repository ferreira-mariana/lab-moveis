import 'dart:convert';

class User{
  String name;
  String password;
  
  User({
    this.name,
    this.password
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "password": password,
  };

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      name: json["name"],
      password: json["password"]
    );
  }
  String userToJson(User data) => json.encode(data.toJson());

  factory User.fromMap(Map<String, dynamic> map){
    return User(
      name: map["name"],
      password: map["password"]
    );
  }
}

