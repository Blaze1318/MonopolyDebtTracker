final String tableUsers = 'users';

class UserFields{

  static final List<String> values = [
    //add all fields
    uid, fName, lName
  ];
  static final String uid = '_uid';
  static final String fName = 'fName';
  static final String lName = 'lName';
}
class Users
{
  final int? uid;
  final String fName;
  final String lName;

  const Users({this.uid,required this.fName,required this.lName});

  Map<String, Object?> toJson() => {
    UserFields.uid: uid,
    UserFields.fName: fName,
    UserFields.lName: lName
  };

  Users copy({
    int? uid,
    String? fName,
    String? lName,
  })  =>
      Users(
        uid: uid ?? this.uid,
        fName: fName ?? this.fName,
        lName: lName ?? this.lName
      );

  static Users fromJson(Map<String, Object?> json) => Users(
    uid:  json[UserFields.uid] as int?,
    fName: json[UserFields.fName] as String,
    lName: json[UserFields.lName] as String
  );
}