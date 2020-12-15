
import 'dart:ui';

import 'package:flutter/material.dart';
import './main.dart';
class MainDrawer extends StatelessWidget{
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