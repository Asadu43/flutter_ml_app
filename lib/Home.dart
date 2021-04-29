import 'package:flutter/material.dart';
import 'package:flutter_ml/DetailScreen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> itemlist = ["Text Scanner", "Barcode Scanner", "Label Scanner", "Face Detection"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ML KIT APP"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: itemlist.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3.0,
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(),
                        settings: RouteSettings(arguments: itemlist[index])));
              },
              title: Text(itemlist[index]),
            ),
          );
        },
      ),
    );
  }
}
