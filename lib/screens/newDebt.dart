import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monopoly_debt_tracker/database/monopoly_database.dart';
import 'package:monopoly_debt_tracker/models/debts.dart';
import 'package:monopoly_debt_tracker/models/users.dart';
import 'dart:core';

class NewDebt extends StatefulWidget {
  const NewDebt({Key? key}) : super(key: key);

  @override
  _NewDebtState createState() => _NewDebtState();
}

class _NewDebtState extends State<NewDebt> {
  bool isLoading = false;
  late List<Users> users;
  List<String> usersName = [];
  String valueChoice = "";
  int number = 0;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    MonopolyDatabase.instance.close();
    super.dispose();
  }

  Future getUsers() async{
    setState(() {
      isLoading = true;
    });
    this.users = await MonopolyDatabase.instance.readAllUsers();

    for(int x = 0; x < this.users.length;x++)
      {
        usersName.add(this.users[x].fName);
      }

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text("New Debt"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        color: Colors.blue,
        child: Column(
          children: <Widget>[
            Text("Choose Who You Owe"),
            Center(
              child: DropdownButton(
                  value: valueChoice,
                  onChanged: (newValue){
                    setState(() {
                        valueChoice = newValue.toString();
                    });
                  },
                  items: usersName.map((newName){
                    return DropdownMenuItem(
                      value: newName,
                        child: Text(newName)
                    );
                  }).toList()
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              initialValue: number.toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (newNum){
                setState(() {
                  number = int.parse(newNum);
                });
              },
            ),
            SizedBox(height: 20,),
            MaterialButton(onPressed: () async{
              setState(() {
                isLoading = true;
              });
              final result = await MonopolyDatabase.instance.readUserID(valueChoice!);
              int dtID = result.uid!;
              final newDebt = Debts(uid: id, dtID: dtID, amount: number);
              await MonopolyDatabase.instance.createDebt(newDebt);
              Navigator.pop(context);
            },
              color: Colors.lightBlueAccent,
              child: Text("Add"),)
          ],
        ),
      ),
    );
  }
}
