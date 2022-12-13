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
// url na sa kuhaan ug data
const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

class _HomePageState extends State<HomePage> {
  //dynamic list sudlan sa response sa http.get
  List mapResponse = <dynamic>[];

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

  @override
  void initState() {
    //gi tawag natong get function sa initState kay para pag initialize sa app mo get ditso sa data sa server
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

              //checkbox list tile akong gigamit kay para convenient ra ug bagay sa todo
              child: CheckboxListTile(
                  title: Text('ToDo Title: ${mapResponse[index]['title']}'),
                  controlAffinity: ListTileControlAffinity.leading,
                  secondary: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              deleteTodo(mapResponse[index]);
                              mapResponse.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete_outline)),
                      IconButton(
                        onPressed: () async {
                          var check = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditTodo(todo: mapResponse[index])));
                          if (check != null) {
                            displayEdited(mapResponse[index]);
                          }else{
                            print('Nothing changed');
                          }
                        },
                        icon: const Icon(Icons.edit),
                      )
                    ],
                  ),
                  value: mapResponse[index]['completed'],
                  selected: mapResponse[index]['completed'],
                  activeColor: Colors.blue,
                  checkColor: Colors.white,
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
