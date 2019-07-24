import 'package:flutter/material.dart';
import 'Strings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(new GHFlutterApp());


class GHFlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: Strings.appTitle,
      home: new GHFlutter()
    );
  }
}

class GHFlutterState extends State<GHFlutter>{

  var _members = <Member>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);


  @override
  void initState() {
  super.initState();

  _loadData();
  }

  _loadData() async{
    String dataURL = "https://api.github.com/orgs/raywenderlich/members";
    http.Response response = await http.get(dataURL);
    setState(() {
      final membersJSON = jsonDecode(response.body);
      for(var memberJSON in membersJSON){
        final member = new Member(memberJSON["login"], memberJSON["avatar_url"]);
        _members.add(member);
      }
    });
  }

  Widget _buildRow(int i){
    return new Padding(
      padding: const EdgeInsets.all(16.0),
      child: new ListTile(
          title: new Text("${_members[i].login}", style: _biggerFont),
          leading: new CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: new NetworkImage(_members[i].avatarUrl),
      ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(Strings.appTitle),
      ),
      body: new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _members.length,
        itemBuilder: (BuildContext context, int position){
          if (position.isOdd) return new Divider();
          final index = position ~/ 2;
          return _buildRow(index);
        }
      )
    );
  }
}

class GHFlutter extends StatefulWidget{
  @override
  createState() => new GHFlutterState();

}

class Member{
  final String login;
  final String avatarUrl;

  Member(this.login, this.avatarUrl){
    if(login == null){
      throw new ArgumentError("login member cannot be null. Received: '$login'");
    }

    if(avatarUrl == null){
      throw new ArgumentError("avatarUrl of Member cannot be null.Received: '$avatarUrl'");
    }
  }
}

