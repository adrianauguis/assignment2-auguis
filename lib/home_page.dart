import 'package:assignment_2_auguis/pages/form_page.dart';
import 'package:assignment_2_auguis/providers/db_provider.dart';
import 'package:assignment_2_auguis/providers/todo_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart' as sql;

import 'pages/edit_todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
// url na sa kuhaan ug data
const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

class _HomePageState extends State<HomePage> {
  //dynamic list sudlan sa response sa http.get
  List mapResponse = <dynamic>[];
  dynamic add;

  //http.get na function para maka request sa server
  getTodo() async {
    var url = Uri.parse(baseUrl);
    var response = await http.get(url);

    //if ang statusCode == sa 200 succesfull ang pag get sa data
    if (response.statusCode == 200) {
      setState(() {
        //jsonDecode pag convert sa body to list dynamic
        mapResponse = jsonDecode(response.body) as List<dynamic>;
      });
    } else {
      return null;
    }
  }

  //delete function para sa http.delete
  deleteTodo(var object) async {
    var url = Uri.parse('$baseUrl/${object["id"]}');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Successfully deleted ToDo: ${object["title"]} ID: ${object["id"]}');
      //kaning snackbar e-run ang program para makita nimo naay mo pop-up sa ubos
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
              'Successfully deleted ToDo: ${object["title"]} ID: ${object["id"]}')));
    } else {
      return null;
    }
  }

  //display deleted function display rani na as if na delete ang data sa server
  displayEdited(var object) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.greenAccent,
        content: Text(
            'Successfully edited ToDo: ${object["title"]} ID: ${object["id"]}')));
  }

  //display reated function display rani na as if na create ang data sa server
  displayCreated(var object) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
            'Successfully created ToDo: ${object["title"]} ID: ${object["id"]}')));
  }

  loadFromApi() async {
    var apiProvider = TodoApiProvider();
    add = await apiProvider.getAllTodos();
  }

  @override
  void initState() {
    //gi tawag natong get function sa initState kay para pag initialize sa app mo get ditso sa data sa server
    getTodo();
    loadFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('ToDo'),
        ),
        leading: const Icon(Icons.list_alt_outlined),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outlined))
        ],
      ),
      body: FutureBuilder(
          future: DBProvider.db.getAllTodos(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black12,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text(
                      "${index + 1}",
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    title: Text(
                        "Title: ${snapshot.data[index].title} ${snapshot.data[index].id} "),
                    subtitle: Text('Status: ${snapshot.data[index].completed}'),
                  );
                },
              );
            }
          },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TodoForm()));
          },
          child: const Icon(Icons.add)),
    );
  }
}
