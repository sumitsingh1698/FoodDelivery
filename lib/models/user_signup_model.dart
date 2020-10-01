class UserSignupModel {
  String email;
  String password;
  String firstName;
  String lastName;
  String otp;
  String mobile;

  UserSignupModel(this.email, this.password, this.firstName, this.lastName,
      this.otp, this.mobile);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['otp'] = this.otp;
    data['mobile'] = this.mobile;
    return data;
  }
}
