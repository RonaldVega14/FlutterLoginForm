class User {
  final String email;
  final String password;

  User({this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json){
    return new User(
      email : json['email'].toString(), 
      password : json['password'].toString(),
      );
  }
  
}
