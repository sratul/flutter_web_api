import 'package:flutter/material.dart';
import 'package:flutter_web_api/api_handler.dart';
import 'package:flutter_web_api/model.dart';

class FindUser extends StatefulWidget {
  const FindUser({super.key});

  @override
  State<FindUser> createState() => _FindUserState();
}

class _FindUserState extends State<FindUser> {
  ApiHandler apiHandler = ApiHandler();
  User user = User.empty();
  TextEditingController textEditingController = TextEditingController();

  void findUser(int userId) async {
    user = await apiHandler.getUserById(userId: userId);
    // refreshes widget tree
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find User"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: MaterialButton(
        color: Colors.teal,
        textColor: Colors.white,
        padding: EdgeInsets.all(10),
        onPressed: () {
          findUser(int.parse(textEditingController.text.trim()));
        },
        child: Text("Find"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(controller: textEditingController),
            SizedBox(height: 10),
            ListTile(
              leading: Text("${user.userId}"),
              title: Text(user.name),
              subtitle: Text(user.email),
            ),
          ],
        ),
      ),
    );
  }
}
