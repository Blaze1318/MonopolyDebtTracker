final String tableDebts = 'debts';

class DebtsFields
{

  static final List<String> values = [
    //add all fields
    debtId, uid, dtID, amount
  ];

  static final String debtId = '_debtId';
  static final String uid = 'uid';
  static final String dtID = 'dtID'; //dt - debt to
  static final String amount = 'amount';
}

class Debts
{
  final int? debtId;
  final int uid;
  final int dtID; //dt - debt to
  final int amount;

  const Debts({this.debtId,required this.uid,required this.dtID,required this.amount});

  Map<String, Object?> toJson() => {
    DebtsFields.debtId: debtId,
    DebtsFields.uid: uid,
    DebtsFields.dtID: dtID,
    DebtsFields.amount: amount
  };

  static Debts fromJson(Map<String, Object?> json) => Debts(
      debtId:  json[DebtsFields.debtId] as int?,
      uid: json[DebtsFields.uid] as int,
      dtID: json[DebtsFields.dtID] as int,
      amount: json[DebtsFields.amount] as int
  );

  Debts copy({
    int? debtId,
    int? uid,
    int? dtID,//dt - debt to
    int? amount
  })  =>
      Debts(
          debtId: debtId ?? this.debtId,
          uid: uid ?? this.uid,
          dtID: dtID ?? this.dtID,
          amount: amount ?? this.amount
      );
}