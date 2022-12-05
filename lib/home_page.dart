import 'package:assignment_2_auguis/pages/form_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'pages/edit_todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// Future <TodoModel> todoModel(){};
const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

class _HomePageState extends State<HomePage> {
  List mapResponse = <dynamic>[];

  getTodo() async {
    var url = Uri.parse(baseUrl);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        mapResponse = jsonDecode(response.body) as List<dynamic>;
      });
    } else {
      return null;
    }
  }

  deleteTodo(var object) async {
    var url = Uri.parse('$baseUrl/${object["id"]}');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Successfully deleted ToDo ${object["title"]} ID: ${object["id"]}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
              'Successfully deleted ToDo: ${object["title"]} ID: ${object["id"]}')));
    } else {
      return null;
    }
  }

  displayEdited(var object) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.greenAccent,
        content: Text(
            'Successfully edited ToDo: ${object["title"]} ID: ${object["id"]}')));
  }

  displayCreated(var object) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
            'Successfully created ToDo: ${object["title"]} ID: ${object["id"]}')));
  }

  @override
  void initState() {
    getTodo();
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
      body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: mapResponse.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CheckboxListTile(
                  title: Text('ToDo Title: ${mapResponse[index]['title']}'),
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: IconButton(
                      onPressed: () {
                        setState(() {
                          deleteTodo(mapResponse[index]);
                          mapResponse.removeAt(index);
                        });
                      },
                      icon: const Icon(Icons.delete_outline)),
                  value: mapResponse[index]['completed'],
                  selected: mapResponse[index]['completed'],
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
                  subtitle: ElevatedButton(
                      onPressed: () async {
                        var check = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditTodo(todo: mapResponse[index])));
                        if (check == null) {
                          displayEdited(mapResponse[index]);
                        }
                      },
                      child: const Text('Edit ToDo')),
                  onChanged: (bool? value) {
                    setState(() {
                      mapResponse[index]['completed'] = value!;
                    });
                  }),
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const TodoForm()));
          },
          child: const Icon(Icons.add)),
    );
  }
}
