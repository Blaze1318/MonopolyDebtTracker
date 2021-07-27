import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly_debt_tracker/database/monopoly_database.dart';
import 'package:monopoly_debt_tracker/models/users.dart';
import 'package:monopoly_debt_tracker/screens/debts_screen.dart';
import 'package:monopoly_debt_tracker/shared/load_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Users> users;
  bool isLoading = false;
  String fName = "";
  String lName = "";
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshUsers();
  }

  Future refreshUsers() async{
    setState(() {
      isLoading = true;
    });

    this.users = await MonopolyDatabase.instance.readAllUsers();
    
    setState(() {
      isLoading = false;
    });
  }

  void showAlertDialog(BuildContext context)
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
        {
          return Dialog(
            child: Container(
              width: 125,
              height: 300,
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                  TextFormField(
                  decoration: InputDecoration(
                      hintText: 'First Name'
                  ),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10
                  ),
                    onChanged: (val){
                      setState(() => fName = val);
                    },),
                SizedBox(height: 8,),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Last Name'
                  ),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10
                  ), onChanged: (val){
                  setState(() => lName = val);
                },),
                      MaterialButton(onPressed: () async{
                        final newUser = Users(fName: fName, lName: lName);
                        setState(() {
                          isLoading = true;
                        });
                        await MonopolyDatabase.instance.createUser(newUser);
                        setState(() {
                          isLoading = false;
                        });
                        refreshUsers();
                        Navigator.pop(context);
                      },
                      color: Colors.lightBlueAccent,
                      child: Text("Add"),)
                    ],
                  ),
                )
              ),
            ),
          );
        }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    MonopolyDatabase.instance.close();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return isLoading? Load() : Scaffold(
      appBar: AppBar(
        title: Text("Monopoly Debt Tracker",style: TextStyle(
          color: Colors.white,
          fontSize: 20
        ),),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          color: Colors.blue,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
                itemCount: users.length,
                itemBuilder: (context,index){
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 0.0,
                    color: Colors.lightBlueAccent,
                    child: InkWell(
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 16,),
                            Text(users[index].fName,style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),),
                            SizedBox(height: 8,),
                            Text(users[index].lName,style: TextStyle(
                              color:Colors.white,
                              fontSize: 15
                            ),),
                          ],
                        ),
                      ),
                      onTap: () {
                        int id = users[index].uid!;
                        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => Debts_Screen(id: id),));
                      },
                    ),
                  ),
                );
                }
          ),
        ),),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
              showAlertDialog(context);
          },
          label: const Text("Add New Player"),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.lightBlueAccent,),
      );
  }
}
