import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

//CATEGORY VIEW CLASS
class CategoryList {
  final String ItemCode;
  final String ItemModel;
  final String Description;
  final String Image;
  final String Image1;
  final String Image2;
  final String Image3;
  final String Image4;
  final String UserMememberNo;
  CategoryList(this.ItemCode,this.ItemModel,this.Image,this.UserMememberNo, this.Description, this.Image1, this.Image2, this.Image3, this.Image4);

}

class ViewCategory extends StatefulWidget{
  final String Name;
  ViewCategory(this.Name);

  @override
  _ViewCategoryState createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {

  Future<List<CategoryList>> _getCategoryList() async {
  var data = await http.get("https://thegreen.studio/ecommerce/default/item-category-json.php?CategoryName="+widget.Name);
   var jsonData =json.decode(data.body);
   List<CategoryList> cList = [];
   for(var i in jsonData) {
     CategoryList cate = CategoryList(i["ItemCode"],i["ItemModel"],i["Image"],i["UserMememberNo"],i["Image1"],i["Image2"],i["Image3"],i["Image4"],i["Description"]);
     cList.add(cate);
   }
   return cList;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Name),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.add_shopping_cart), onPressed: (){
            Navigator.push(context, new MaterialPageRoute(builder: (context)=>ViewShoppingCart()));
          }),
          new IconButton(icon: Icon(Icons.login_rounded), onPressed: (){
            Navigator.push(context, new MaterialPageRoute(builder: (context)=>LoginPage()));
          }),
        ],
        
      ),
      body: Container(
        child: FutureBuilder(
          future: _getCategoryList(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            }else{
              return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  final x = snapshot.data[index];
                  return Card(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(builder: (context)=>DetailPage(snapshot.data[index])));
                      },
                      child: Column(
                        children: <Widget>[
                          Image.network("https://thegreen.studio/ecommerce/default/upload/"+x.Image,
                        width:200.0,
                        height:150.0,
                        fit:BoxFit.cover),
                          Text(x.UserMememberNo),
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
      )
    );
  }
}


//LOGIN PAGE CLASS
class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email, password;
  bool signin = true;


  @override
  void initState(){
    super.initState();
    email = new TextEditingController();
    password = new TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
       body: Container(
         child: Column(
           children: [
             Column(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 TextField(
                   controller: email,
                   decoration:  InputDecoration(prefixIcon: Icon(Icons.account_box)),
                 ),
                 TextField(
                   controller: password,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.lock)),
                 ),
                 MaterialButton(onPressed: (){
                   UserLogin();
                 },child:Text("Sign In"),
                 ),
                 MaterialButton(onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                 },child:Text("Sign Up"),
                 ),
               ],
             ),
           ],
         ),
       ),
      );
  }
//USER LOGIN METHOD
  void UserLogin() async{
    var url = "https://thegreen.studio/ecommerce/E-CommerceAPI/E-CommerceAPI/AI_API_SERVER/Api/Login_Registration/login.php";
    var response = await http.post(url,body:{
      "email":email.text,
      "password":password.text,
    });

    var data = json.decode(response.body);
    if(data == "Success"){
      await FlutterSession().set('GUID',email.text);
      print("login");
      Navigator.push(context, MaterialPageRoute(builder: (context)=> UserProfile()));
    }else{
      print("username incorrect");
    }
  }
}
//CLASS FOR USER SIGNUP
class SignUp extends StatefulWidget{
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController registration_email, registration_password;
  @override
  void initState(){
    super.initState();
    registration_email = new TextEditingController();
    registration_password = new TextEditingController();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextField(
                    controller: registration_email,
                    decoration:  InputDecoration(prefixIcon: Icon(Icons.account_box)),
                  ),
                  TextField(
                    controller: registration_password,
                    decoration: InputDecoration(prefixIcon: Icon(Icons.lock)),
                  ),
                  MaterialButton(onPressed: (){
                    UserRegistration();
                  },child:Text("Sign In"),
                  ),
                  MaterialButton(onPressed: (){
                    UserRegistration();
                  },child:Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void UserRegistration() async{

        if(registration_email.text == '' || registration_password.text == ''){
          Fluttertoast.showToast(
              msg: "Please fillup the email and password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }else{
          var url = "https://thegreen.studio/ecommerce/E-CommerceAPI/E-CommerceAPI/AI_API_SERVER/Api/Login_Registration/registration.php";
          var response = await http.post(url,body:{
            "email":registration_email.text,
            "password":registration_password.text,
          });

          var data = json.decode(response.body);
          if(data == "Success"){
           // await FlutterSession().set('GUID',registration_email.text);
            Fluttertoast.showToast(
                msg: "You successfully register",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }else{
            Fluttertoast.showToast(
                msg: "This email already registered",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        }

  }
}

class UserProfile extends StatefulWidget{
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("welcome to home page")),
      body: ListView(
        children: <Widget>[
          FutureBuilder(
            future: FlutterSession().get('GUID'),
              builder: (context,snapshot){
            return Text(snapshot.hasData ? snapshot.data: 'Loading....');
          })
        ],
      )


    );
  }
}



class DetailPage extends StatefulWidget{
  final CategoryList cList;
  DetailPage(this.cList);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _count = 1;
  //POST METHOD
  Dio dio = new Dio();
  Future postData() async {
    final String url = "https://thegreen.studio/ecommerce/E-CommerceAPI/E-CommerceAPI/AI_API_SERVER/Api/Cart/CreateCartAPI.php";
    var cList;
    dynamic data = {
      "ItemCode":widget.cList.ItemCode,
      "UserID":"U12",
      "Variation":"S,L,M",
      "Quantity":2,
      "GST": 0,
      "Price":3,
      "DeliveryCharge": 5
    };
    var response = await dio.post(url,data: data,options: Options(
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        }
    ));
    return response.data;
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.cList.Description),
      ),
      body: Container(
        child:Container(
          child: Column(
            //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.cList.Image,
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
                          Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.cList.Image1,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.cList.Image2,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.cList.Image3,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          Image.network("https://thegreen.studio/ecommerce/default/upload/"+widget.cList.Image4,
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
                      Text(widget.cList.UserMememberNo,style: TextStyle(
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
                      Text(widget.cList.Description,style: TextStyle(
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
                        onPressed: () async{
                          await postData().then((value){
                            print(value);
                          });
                        },
                        color: Colors.blue,
                        child: Text("BUY NOW".toUpperCase(),style: TextStyle(
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

//MODAL FOR SHOPPING CARD
class ShoppingCart {
  final String Description;
  final String UserMememberNo;
  final String Image;
  final String Variation;
  final String Quantity;
  final String Price;
  final String GUID;
  ShoppingCart(this.Description,this.UserMememberNo, this.Image, this.Variation, this.Quantity, this.Price,this.GUID);
}

class ViewShoppingCart extends StatefulWidget{
  @override
  _ViewShoppingCartState createState() => _ViewShoppingCartState();
}

class _ViewShoppingCartState extends State<ViewShoppingCart> {
  var sumOfPrice;
  @override
  void initState(){
    super.initState();
    this._getCartList();
  }
  Future<List<ShoppingCart>> _getCartList() async{
    var Total = [];
    var sum;
    var data = await http.get("https://thegreen.studio/ecommerce/E-CommerceAPI/E-CommerceAPI/AI_API_SERVER/Api/Cart/CartListAPI.php");
    var jsonData = json.decode(data.body);
    List<ShoppingCart> cartList = [];
    for(var i in jsonData["body"]){
      ShoppingCart sCart = ShoppingCart(i["Description"],i["UserMememberNo"],i["Image"],i["Variation"],i["Quantity"],i["Price"],i["GUID"]);
      cartList.add(sCart);
      Total.add(sCart.Price);
    }
    int t = 0;
    for(var a = 0; a < Total.length; a++){
     int price = int.parse(Total[a].toString());
     print(t+price);
     t = t + price;
    }
    sumOfPrice = t.toString();
    return cartList;
  }

  @override
  Widget build(BuildContext context) {

   return new Scaffold(
     appBar: new AppBar(
       title: new Text("Cart"),
     ),
     body: Container(
       child: FutureBuilder(
         future: _getCartList(),
         builder: (BuildContext context, AsyncSnapshot snapshot){

           if(snapshot.data == null){
             return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
             );
           } else{
             return Container(
               child: ListView.builder(
                   //padding: EdgeInsets.all(10),
                   itemCount: snapshot.data.length,
                   itemBuilder: (BuildContext context, int index){
                     final x = snapshot.data[index];
                     var _count = snapshot.data[index].Quantity;
                     return ListTile(
                      leading: Image.network("https://thegreen.studio/ecommerce/default/upload/"+snapshot.data[index].Image,
                        width: 100.0, height: 150.0,
                        fit: BoxFit.cover),
                      title:  Text(snapshot.data[index].Description),
                       subtitle: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: <Widget>[
                         Text(snapshot.data[index].Price),
                         Text(snapshot.data[index].Variation),
                         SizedBox(
                             width: 40,
                             height: 32,
                             child:OutlineButton(
                               onPressed: (){
                                 minusQuantity(snapshot.data[index].GUID,
                                     snapshot.data[index].Quantity, snapshot.data[index].Price);
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
                               shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                                 plusQuantity(snapshot.data[index].GUID,
                                     snapshot.data[index].Quantity,snapshot.data[index].Price);
                                 setState(() {
                                   _count++;
                                 });
                               },
                               padding: EdgeInsets.zero,
                               child: Icon(Icons.add),
                               shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                               //Icon(Icons.Add),
                             )
                         ),
                         OutlineButton(
                           onPressed: () {

                             var GUID =snapshot.data[index].GUID;
                             //print(snapshot.data[index].GUID);
                             RemoveItem(GUID);
                           },
                           child: Text('Remove'),
                         ),
                       ],
                       ),
                      );
                   }),
             );
           }
         },
       ),
     ),
     bottomNavigationBar: Container(
      child: Container(
        child: Row(
          children: <Widget>[
            Text(" SubTotal "),
            Text(":"),
            //Text(sumOfPrice),
            Text(sumOfPrice == null? '': sumOfPrice),
            Container(
              child: Row(
                children: [
                  OutlineButton(
                     onPressed: () {

                       addToOrder();
                     print('Received Order');
                     //Add to the order list

                     },
                     child: Text('CheckOut'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

       height: 174,
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
         boxShadow: [
           BoxShadow(
             offset: Offset(0,-15),
             blurRadius: 20,
             color: Color(0xFFDADADA).withOpacity(0.15),
           )
         ]
       ),
     ),
   );
  }

  void plusQuantity(GUID,Quantity,Price) async{
    int q = int.parse(Quantity.toString());
    int price = int.parse(Price.toString());
    int q1 = q + 1;
    int p = q1 * price;

    Dio dio = new Dio();
    Future updateQuantity() async{
      final String url = "https://thegreen.studio/ecommerce/E-CommerceAPI/E-CommerceAPI/AI_API_SERVER/Api/Cart/UpdateQuantityAPI.php";
      dynamic data = {
        "GUID":GUID,
        "Quantity":q1,
        "Price": p
      };
      var response = await dio.post(url,data: data,options: Options(
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          }
      ));
      return response.data;
    }
    await updateQuantity().then((value){
      print(value);
    });
  }

  void addToOrder() async{
    //GET DATA FORM REQUEST
    Future<List<ShoppingCart>> _getCartList() async{
      var data = await http.get("https://thegreen.studio/ecommerce/E-CommerceAPI/E-CommerceAPI/AI_API_SERVER/Api/Cart/CartListAPI.php");
      var jsonData = json.decode(data.body);
        for(var i in jsonData["body"]){
          ShoppingCart sCart = ShoppingCart(i["Description"],i["UserMememberNo"],i["Image"],i["Variation"],i["Quantity"],i["Price"],i["GUID"]);
          sendDataToOrderList(sCart);
        }
    }
    await _getCartList().then((value){
      print(value);
      initState();
    });

}
//PLUS QUANTITY
void minusQuantity(GUID, Quantity, Price) async{
  print(GUID);
  int q = int.parse(Quantity.toString());
  int price = int.parse(Price.toString());
  int q1 = q - 1;
  int p = q1 * price;

  Dio dio = new Dio();
  Future updateQuantity() async{
    final String url = "https://thegreen.studio/ecommerce/E-CommerceAPI/E-CommerceAPI/AI_API_SERVER/Api/Cart/UpdateQuantityAPI.php";
    dynamic data = {
      "GUID":GUID,
      "Quantity":q1,
      "Price":p
    };
    var response = await dio.post(url,data: data,options: Options(
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        }
    ));
    return response.data;
  }

  await updateQuantity().then((value){
    print(value);
    initState();
  });
}

//MINUS QUANTITY
void RemoveItem(GUID) async {
  print(GUID);
  Dio dio = new Dio();
  Future deleteItem() async {
    final String url = "https://thegreen.studio/ecommerce/E-CommerceAPI/E-CommerceAPI/AI_API_SERVER/Api/Cart/DeleteItemAPI.php";
    dynamic data = {
      "GUID": GUID
    };
    var response = await dio.post(url, data: data, options: Options(
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        }
    ));
    return response.data;
  }
  await deleteItem().then((value) {
    print(value);
  });
}
//ADD CART VALUE INOT ORDER LIST
  void sendDataToOrderList(sCart) async{
    Dio dio = new Dio();
    Future postData() async {
      final String url = "https://thegreen.studio/ecommerce/E-CommerceAPI/E-CommerceAPI/AI_API_SERVER/Api/Order/CreateOrderAPI.php";
      dynamic data = {
        "Name": sCart.Variation,
        "PhoneNo": "775617",
        "HouseNo": "11-07",
        "Address1": "address1",
        "Address2": "address2",
        "Address3": "address3",
        "Address4": "address4",
        "PostCode": "94300",
        "City": "test",
        "State":"Sarawak",
        "Variation": "S",
        "Variation1": "S",
        "Variation2": "L",
        "Variation3": "Yellow",
        "Variation4": "Red",
        "Price":"2",
        "DeliveryCost": "7",
        "Quantity":"2",
        "DeliveryDate":"12/12/2020",
        "OrderStatus":"Active"
      };
      var response = await dio.post(url,data: data,options: Options(
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          }
      ));
      return response.data;
    }
    await postData().then((value){
      print(value);
    });
  }
}








