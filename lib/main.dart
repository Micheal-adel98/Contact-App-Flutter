import 'package:flutter/material.dart';
import 'package:phone_book_system/form.dart';
import 'package:phone_book_system/search.dart';
void main() {
  runApp(MaterialApp(home: MyApp(),));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Book System"),
      ),
      body: Container(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          //mainAxisAlignment: MainAxisAlignment.center,
          //mainAxisSize: MainAxisSize.min,
          //verticalDirection: VerticalDirection.down,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>FormPage()));

                  },
                  child: Text("ADD"),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Search()));

                  },
                  child: Text("Search"),
                )
              ],
            ),


          ],
        ),
      ),
    );
  }
}
