import 'package:flutter/material.dart';

class Weather extends StatelessWidget {
int counter;
Weather(this.counter);
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text('Weather'),backgroundColor: Colors.orange,),
body: Center(
child: Column(
children: <Widget>[
Text('Counter=$counter', style: TextStyle(fontSize: 22),),
ElevatedButton(child: Text('Add'),color: Colors.blue,onPressed: (){++counter;},)
],),
),
);
}
}