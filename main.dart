import 'package:flutter/material.dart';
import 'Dart:async';
import 'Dart:convert';
import 'package:http/http.Dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'HTTP Post Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState(){
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String _respString = ''; // property consumed by Scaffold.body and updated by _postRequest()

  String _decodeMultiLevelJson(var aJson, List aList){
    // Receives a multi-level JSON and decodes it in the order defined
    // by aList. Returns its last level content.
    int _len = aList.length;
    int _index;
    var _parsedJson;
    var _result;

    for (_index = 0 ; _index < _len ; _index++){
      _parsedJson = json.decode(aJson);
      _result = _parsedJson['${aList[_index]}'];
      if (_result!=null) {
        aJson = json.encode(_result);
      }
    }
    return _result;
  } //_decodeMultiLevelJson

  Future<void> _postRequest (Map data, String url, dynamic headers) async {
    //encode Map to JSON
    var _body = json.encode(data);
    var _resp = await http.post(url,
        headers: headers,
        body: _body
    );
    setState(() {
      _respString =
          _decodeMultiLevelJson(_resp.body, ['response', 'result', 'greeting']);
      //print(_respString); use this to debug
    });
  }

  String _basicAuthorizationHeader(String username, String password) {
    // Builds a Basic authorization header
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  } // _basicAuthorizationHeader

  void _floatingActionButtonOnPressed() {
    final String _url ='https://us-south.functions.cloud.ibm.com/api/v1/namespaces/sergio%40lanlink.com.br_dev/actions/greetings?blocking=true';
    Map _data; // this is the data to be POSTed
    final _headers = {
      'Content-Type': 'application/json',
      'Authorization': _basicAuthorizationHeader(
          'place here the user id',
          'place here the password'
       // Authorization's sub-fields are obtained from the api_key provided by the API owner
       // The first sub-field is the user, the second is the password
      )
    }; // headers

    if(_respString=='1'){
          _data = {
            '_xpto': 'sergio'
          };
        }
      else{
        _data = {
          'xpto': 'sergio'
        };
      }
      _postRequest(_data, _url, _headers); // post it !
  } // _floatingActionButtonOnPressed()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Post response:',
            ),
            Text(
              '$_respString',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _floatingActionButtonOnPressed,
        tooltip: 'Post',
        child: Icon(Icons.cloud_circle),
      )
    );
  } //build
} //_myHomePageState

