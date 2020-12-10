
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title:"All product list",
        theme:new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title:"All product list"),
    );

  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,this.title}) :super(key:key);
  final String title;
  @override
  _MyPageState createState() => new _MyPageState();

}
class _MyPageState extends State<MyHomePage> {
  Future<List<Item>> _getItem() async {
    var data = await http.get("https://thegreen.studio/ecommerce/default/item-json.php");
    var jsonData = json.decode(data.body);
    List<Item> items = [];
    for(var i in jsonData){
      Item item = Item(i["ItemCode"],i["Description"],i["Image"]);
      items.add(item);
    }
    print(items.length);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body:Container(
        padding:EdgeInsets.all(10),
        child:FutureBuilder(
            future: _getItem(),
            builder:(BuildContext context, AsyncSnapshot snapshot){

              if(snapshot.data == null){
                return Container(
                    child:Center(
                        child:Text("Loading...")
                    )
                );
              }else{
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount:snapshot.data.length,
                  itemBuilder:(BuildContext context, int index) {
                    final x = snapshot.data[index];
                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, new MaterialPageRoute(builder: (context)=>DetailPage(snapshot.data[index])));
                        },
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              'https://thegreen.studio/ecommerce/default/upload/' +x.Image,
                              width: 200.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                            ),
                            Text(x.Description),
                            Text("Price: RM:134"),
                          ],
                        ),
                      ),
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

class Item {
  final String ItemCode;
  final String Description;
  final String Image;
  Item(this.ItemCode, this.Description,this.Image);
}

class DetailPage extends StatelessWidget {
  final Item item;
  DetailPage(this.item);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(item.Description),
      ),


    );

  }

}