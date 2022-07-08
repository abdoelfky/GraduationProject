class UserModel
{
  String name,email,phone,uId;
  bool isEmailVerified;
  UserModel({this.uId,this.email,this.phone,this.name,this.isEmailVerified});

  UserModel.fromJson(Map <String,dynamic> json)
  {
    name =json['name'];
    phone =json['phone'];
    email =json['email'];
    uId =json['uId'];
    isEmailVerified=json['isEmailVerified'];
  }

  Map <String,dynamic> toMap()
  {
    return {
      'name':name,
      'phone':phone,
      'email':email,
      'uId':uId,
      'isEmailVerified':isEmailVerified,
    };
  }

}