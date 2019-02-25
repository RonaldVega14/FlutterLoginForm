import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login_form/models/user_list.dart';
import 'package:login_form/utils/network_utils.dart';
import 'package:http/http.dart' as http;
import 'package:login_form/models/user_model.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';

  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
      }
      
    }
    
  class _HomePageState extends State<HomePage> {

    Future<List<User>> _getUsers() async{

      var data = await http.get(NetworkUtils.endPoint);
      var jsonData = json.decode(data.body);
      //Este for sirve para llenar la lista de informacion.
        
        UserList userslist = UserList.fromJson(jsonData);
        print(userslist.users.length);

        return userslist.users;
    }



    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Users in Json API'),
        ),
        body: SafeArea(
          child: Container(
            child: FutureBuilder(
              future: _getUsers(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.data ==null) {
                  return Container(
                    child:Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else{
                  return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: Icon(Icons.email),
                      title: Text(snapshot.data[index].email),
                      subtitle: Text(snapshot.data[index].password)
                      );
                    }
                  );
                }
              },
            ),
          ),
        )
      );
    }
  }