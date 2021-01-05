
import 'package:ecommerce/main_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './main_drawer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
    //print(jsonData);
    List<Item> items = [];
    for(var i in jsonData){
      Item item = Item(i["ItemCode"],i["UserMememberNo"],i["Description"],i["Image"],i["Image1"],i["Image2"],i["Image3"],i["Image4"]);
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      drawer: MainDrawer(),
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
  final String UserMememberNo;
  final String Description;
  final String Image;
  final String Image1;
  final String Image2;
  final String Image3;
  final String Image4;

  Item(this.ItemCode, this.UserMememberNo, this.Description,this.Image,this.Image1,this.Image2,this.Image3,this.Image4);
}






class DetailPage extends StatefulWidget {
  final Item item;

  DetailPage(this.item);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.item.Description),
      ),
      body: Container(
        child:Container(
          child: Column(
            //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.item.Image,
                      width: 450.0,
                      height: 400.0,
                      fit: BoxFit.cover,
                    ),

                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Row(
                        children: <Widget>[
                          Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.item.Image1,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.item.Image2,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.item.Image3,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.item.Image4,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),



              Container(
                child: SizedBox(
                  child: Row(
                    children: <Widget>[
                      Text(widget.item.UserMememberNo,style: TextStyle(
                        fontSize:30,

                      ),),
                    ],
                  ),

                ),
              ),
              Container(
                child: SizedBox(
                  child: Row(
                    children: <Widget>[
                      Text("Price: RM12",style: TextStyle(
                        fontSize:30,
                      ),),
                    ],
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  child: Row(
                    children: <Widget>[
                      Text(widget.item.Description,style: TextStyle(
                        fontSize:20,
                      ),),
                    ],
                  ),

                ),
              ),

              Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                        height: 32,
                        child:OutlineButton(
                          onPressed: (){
                            setState(() {
                              if(_count <= 1)
                                {
                                  _count = 1;
                                }
                              _count--;
                            });

                          },
                          padding: EdgeInsets.zero,
                          child: Icon(Icons.remove),
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          //Icon(Icons.remove),
                        )
                    ),
                    SizedBox(
                        width: 40,
                        height: 32,
                        //padding:const EdgeInsets.symmetric(horizontal: kNoDefaultValue / 2),
                        child:Text("$_count", style: Theme.of(context).textTheme.headline6),
                    ),
                    SizedBox(
                        width: 40,
                        height: 32,
                        child:OutlineButton(
                          onPressed: (){
                            setState(() {
                              _count++;
                            });
                          },
                          padding: EdgeInsets.zero,
                          child: Icon(Icons.add),
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                          //Icon(Icons.Add),
                        )
                    ),
                  ],
                ),
              ),

              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                        )
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 350,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        onPressed: (){

                        },
                        color: Colors.blue,
                        child: Text("Buy Now".toUpperCase(),style: TextStyle(
                          fontSize:17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[

                  ],
                ),
              ),
            ],
          ),
        ),
      ),


    );

  }
}