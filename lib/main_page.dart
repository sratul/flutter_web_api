import 'package:flutter/material.dart';
import 'package:flutter_web_api/api_handler.dart';
import 'package:flutter_web_api/model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ApiHandler apiHandler = ApiHandler();
  late List<User> data =[];

  void getData() async{
    data = await apiHandler.getUserData();
    setState(() {
      
    });
  }

  @override
  void initState() {
    getData();
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("FlutterApi"),
    centerTitle: true,
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,),
    bottomNavigationBar: MaterialButton(color: Colors.teal,textColor: Colors.white, padding: EdgeInsets.all(10),onPressed: getData,child: Text("Refresh"),),
    body: Column(
      children: [
        ListView.builder(shrinkWrap: true,itemCount:data.length ,itemBuilder: (BuildContext context, int index){
          return ListTile(
            leading: Text("${data[index].userId}"),
            title: Text(data[index].name),
            subtitle: Text(data[index].email),
          );
        },)
      ],
    ),);
  }
}