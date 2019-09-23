import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutterjson',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'List Of Users'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  
  Future<List<User>> _getUsers() async{
    var data = await http.get("https://jsonplaceholder.typicode.com/users"); //json file format, not a real data user

    //convert data into a json object
    var jsonData = json.decode(data.body);

    //loop
    List<User> users = [];
    for (var u in jsonData){
      User user = User(u["id"], u["name"], u["username"], u["email"], /*u["address"],*/ u["phone"], u["website"]);

      users.add(user);
    }
    print(users.length);

    return users;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
            child: FutureBuilder(
              future: _getUsers(),
              builder: (BuildContext context, AsyncSnapshot snapshot){

                if(snapshot.data == null){
                  return Container(
                    child: Center(
                      child: Text("Loading...")
                    )
                  );
                } else{
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int id){
                      return ListTile(
                        title: Text(snapshot.data[id].name),
                        subtitle: Text(snapshot.data[id].email),
                        onTap: (){
                          Navigator.push(context,
                            new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[id]))
                          );
                        },
                      );
                    },
                ); 
                }
              },
            ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
            clipper: getClipper(),
          ),
          Positioned(
            width: 420.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                      image: new AssetImage("img/profile.png"),
                      fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(75.0)
                    ),
                    boxShadow:[BoxShadow(blurRadius: 7.0, color: Colors.black)]
                  )
                ),
                SizedBox(height: 90.0),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'MonteSerrat'
                  ),
                  ),
                SizedBox(height: 15.0),
                Text(
                  user.username,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'MonteSerrat'
                  ),
                  ),
                SizedBox(height: 15.0),
                Text(
                  user.phone,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.italic,
                  ),
                  ),
                SizedBox(height: 15.0),
                Text(
                  user.website,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'MonteSerrat'
                  ),
                  ),
                /*SizedBox(height: 15.0),
                Text(
                  user.address.street,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'MonteSerrat'
                  ),
                  )*/
              ],
            ),
          )
        ],
      )
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  //final String address; NESTED
  final String phone;
  final String website;
  //final String company; NESTED

  User (this.id, this.name, this.username, this.email, /*this.address,*/ this.phone, this.website);
}