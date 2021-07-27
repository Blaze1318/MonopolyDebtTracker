import 'package:flutter/material.dart';
import 'package:monopoly_debt_tracker/database/monopoly_database.dart';
import 'package:monopoly_debt_tracker/models/debts.dart';
import 'package:monopoly_debt_tracker/models/users.dart';
import 'package:monopoly_debt_tracker/shared/load_screen.dart';

import 'newDebt.dart';

class Debts_Screen extends StatefulWidget {
  final int id;
  const Debts_Screen({Key? key, required this.id}) : super(key: key);

  @override
  _DebtsState createState() => _DebtsState();
}

class _DebtsState extends State<Debts_Screen> {
  late List<Debts> debts;
  late Users users;
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   refreshDebts(widget.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    MonopolyDatabase.instance.close();
    super.dispose();
  }

  Future refreshDebts(int id) async{
    setState(() {
      isLoading = true;
    });


      this.debts = await MonopolyDatabase.instance.getAllUserDebts(id);


      setState(() {
        isLoading = false;
      });

  }

  Future<String> getUser(int id) async
  {
    final user = await MonopolyDatabase.instance.readUser(id);
    return user.fName;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Load() : Scaffold(
      appBar: AppBar(
        title: Text("Debts"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        color: Colors.blue,
        child: ListView.builder(
            itemCount: debts.length,
            itemBuilder: (context,index){
              return Padding(
                  padding: EdgeInsets.all(16),
                child: Card(
                  elevation: 0.0,
                  child: Container(
                    child: ListTile(
                     title: Text(getUser(debts[index].dtID).toString()),
                      subtitle: Text(debts[index].amount.toString()),
                    ),
                  ),
                ),
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) => NewDebt(),settings: RouteSettings(
              arguments: widget.id
          ))).then((value) => setState(() => {
            refreshDebts(widget.id)
          }));
    },
        label: const Text("Add New Debt"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,),
    );
  }
}
