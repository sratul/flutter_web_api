import 'package:flutter/material.dart';
import 'package:flutter_web_api/add_user.dart';
import 'package:flutter_web_api/api_handler.dart';
import 'package:flutter_web_api/edit_page.dart';
import 'package:flutter_web_api/find_user.dart';
import 'package:flutter_web_api/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiHandler apiHandler = ApiHandler();
  late List<User> data = [];

  void getData() async {
    data = await apiHandler.getUserData();

    setState(() {});
  }

  void deleteUser(int userId) async {
    await apiHandler.deleteUser(userId: userId);

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlutterApi"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: MaterialButton(
        color: Colors.teal,
        textColor: Colors.white,
        padding: EdgeInsets.all(10),
        onPressed: getData,
        child: Text("Refresh"),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 1,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => FindUser())),
              );
            },
            child: Icon(Icons.search),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 2,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUser()),
              );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPage(user: data[index]),
                    ),
                  );
                },
                leading: Text("${data[index].userId}"),
                title: Text(data[index].name),
                subtitle: Text(data[index].email),
                trailing: IconButton(
                  onPressed: () {
                    deleteUser(data[index].userId);
                  },
                  icon: Icon(Icons.delete_outline),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
