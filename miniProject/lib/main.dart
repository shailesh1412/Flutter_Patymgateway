import 'package:flutter/material.dart';
import 'PaymentScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final generatedKeysRef = Firestore.instance.collection('generatedKeys');
final studentRef = Firestore.instance.collection('student');
DocumentSnapshot key = null;
String curKey="";
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Paytm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _keyController = TextEditingController();


  makeToast(msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  handleOnPressed(context) async {
    await generatedKeysRef
        .document(_keyController.text.trim())
        .get()
        .then((value) {
      if (value == null || value.data == null) {
        makeToast('Invalid key');
      } else {
        makeToast('Valid Key!');
        key = value;
        curKey=_keyController.text.trim();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PaymentScreen(
                  amount: '1000',
                )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make Payments"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _keyController,
              decoration: InputDecoration(
                  hintText: "Enter Secrect key",
                  border: UnderlineInputBorder()),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: () {
              handleOnPressed(context);
            },
            color: Colors.blue,
            child: Text(
              "Proceed to Checkout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
