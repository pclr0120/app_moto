class User {
  int id;
  int userId;
  String userName;
  String name;
  String userLastName;
  String userGender;
  String userImage;
  String userBirthday;
  String email;
  String phone;
  String userPassword;
  String userToken;
  String token;
  // ignore: non_constant_identifier_names
  String profile_id;
  // ignore: non_constant_identifier_names
  String user_type;
  // ignore: non_constant_identifier_names
  int employee_id;
  // ignore: non_constant_identifier_names
  int branchoffice_id;
  // ignore: non_constant_identifier_names
  String branch_office_type;

  User({
    this.id,
    this.userId,
    this.userName,
    this.userLastName,
    this.userGender,
    this.userImage,
    this.userBirthday,
    this.email,
    this.phone,
    this.userPassword,
    this.userToken,
    this.token,
    // ignore: non_constant_identifier_names
    this.profile_id,
    // ignore: non_constant_identifier_names
    this.user_type,
    // ignore: non_constant_identifier_names
    this.employee_id,
    // ignore: non_constant_identifier_names
    this.branchoffice_id,
    // ignore: non_constant_identifier_names
    this.branch_office_type,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON provided to SimpleObject");
    }

    return User(
      id: json['id'],
      userId: json['userId'],
      userName: json['name'],
      userLastName: json['userLastName'],
      userGender: json['userGender'],
      userImage: json['userImage'],
      userBirthday: json['userBirthday'],
      email: json['email'],
      phone: json['phone'],
      userPassword: json['userPassword'],
      token: json['accessToken'] != null ? json['accessToken']['token'] : null,
      userToken: json['token'] != null ? json['token'] : null,
      profile_id: json['profile_id'],
      user_type: json['user_type'],
      employee_id: json['employee_id'],
      branchoffice_id: json['branchoffice_id'],
      branch_office_type: json['branch_office_type'],
    );
  }
}
