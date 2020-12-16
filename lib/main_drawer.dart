
import 'dart:ui';
import 'package:flutter/material.dart';
import './main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MainDrawer extends StatefulWidget{

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {

  Future<List<Categories>> _getCategory() async {
    var data = await http.get("https://thegreen.studio/ecommerce/default/category-json.php");
    var jsonData = json.decode(data.body);
    //print(jsonData["body"]);
    List<Categories> categoriesList = [];
    for(var c in jsonData)
      {
          Categories a = Categories(c["Name"]);
          categoriesList.add(a);
      }
    print(categoriesList.length);
    return categoriesList;
  }

  @override
  Widget build(BuildContext context) {
      return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding:EdgeInsets.all(20),
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 180,
                      margin: EdgeInsets.only(
                        top:30,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://thegreen.studio/profile-image/profile.jpg'
                          ), fit:BoxFit.fill
                        )
                      ),

                    ),
                    Text("Riyal",style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),),
                    Text("gmriyal@gmail.com",style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),)
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile",style: TextStyle(
              fontSize:18,
              ),),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category",style: TextStyle(
                fontSize:18,
              ),),
              onTap: (){

              },
            ),


            Container(
              child: Expanded(
                child: FutureBuilder(
                  future: _getCategory(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.data == null){
                      return Container(
                        child: Text("Loading..."),
                      );
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          //final x = snapshot.data[index];
                          return ListTile(
                            title: Text(snapshot.data[index].Name),
                            onTap: (){
                              Navigator.push(context, new MaterialPageRoute(builder: (context) => ViewCategory(snapshot.data[index].Name)));
                          },

                          );
                        },
                      );
                    }
                  },
                ),
              ),

            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings",style: TextStyle(
                fontSize:18,
              ),),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout",style: TextStyle(
                fontSize:18,
              ),),
            ),
          ],
        ),
      );
  }

}


//CATEGORY CLASS
class Categories{
  final String Name;
  Categories(this.Name);
}

//VIEW FULL CATEGORY LIST CLASS
class ViewCategory extends StatelessWidget {
  final String Name;

  ViewCategory(this.Name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Name),
      ),
    );
  }
}
//CATEGORY VIEW CLASS
class CategoryList {
  final String ItemModel;
  CategoryList(this.ItemModel);
}



