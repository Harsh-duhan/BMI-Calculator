import 'dart:ffi';
import 'dart:io';
import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:proj1/button.dart' hide Intropage;
// import 'package:proj1/introPage.dart';
// import 'package:proj1/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // dbhelp db1 = dbhelp.getInst();

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,
        textTheme: TextTheme(
        ),
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var weight = TextEditingController();

  var inches = TextEditingController();

  var feet = TextEditingController();

  var height = TextEditingController();

  // var formkey = GlobalKey<FormState>();
  var result="";
  var bgColor = Colors.indigo.shade200   ;

  @override
  Widget build(BuildContext context) {
    // RangeLabels labels = RangeLabels(values.start.toString(), values.end.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI App") ,
      ) ,
      body: Container(
        color: bgColor,
        child: Center(
          child: Container(

            width: 260,
            child: Column(
              children: [
                Text("Body Mass Index",style: TextStyle(fontSize: 23, color: Colors.indigoAccent),),
                SizedBox(
                  height: 23,
                ),
                TextField(
                  controller: weight,
                  decoration: InputDecoration(
                    hintText: "Enter Weight",
                    labelText: "Weight",

                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 23,
                ),
                TextField(
                  controller: feet,
                  decoration: InputDecoration(
                    hintText: "Enter Height in Feet",
                    labelText: "Height (Ft)",

                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 23,
                ),
                TextField(
                  controller: inches,
                  decoration: InputDecoration(
                    hintText: "Enter Height in Inches",
                    labelText: "Height (Inh)",

                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: (){
                      var wt = weight.text.toString();
                      var ft = feet.text.toString();
                      var inh = inches.text.toString();

                      if(wt!="" && ft!="" && inh!=""){
                        // print("");
                        var iwt = int.parse(wt);
                        var ift = int.parse(ft);
                        var inch = int.parse(inh);

                        var totalinch = (ift*12)+inch;
                        var totalcm = totalinch*2.54;
                        var totalm = totalcm/100;
                        var bmi = iwt/(pow(totalm,2));
                        var output = bmi.toStringAsFixed(2);

                        var msg ="";
                        if(bmi>25){
                          bgColor = Colors.orange.shade700;
                          msg = "Overweight";
                        }
                        else if(bmi<18){
                          bgColor = Colors.red.shade200;
                          msg = "Underweight";
                        }
                        else{
                          bgColor = Colors.green.shade200;
                          msg = "Normal";
                        }


                        setState((){
                          result = "       $msg \n Your BMI is $output ";
                        });



                      }
                      else{
                        setState((){
                          result= " please fill all the values";
                        });
                      }
                    },
                    child: Text("Calculate")
                ),
                SizedBox(
                  height: 30,
                ),
                Text(result, style: TextStyle(fontSize: 23, color: Colors.indigoAccent),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
