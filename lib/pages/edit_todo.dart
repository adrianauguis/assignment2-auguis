import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditTodo extends StatefulWidget {
  final dynamic todo;

  const EditTodo({required this.todo, Key? key}) : super(key: key);

  @override
  State<EditTodo> createState() => _EditTodoState();
}

const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

class _EditTodoState extends State<EditTodo> {
  TextEditingController title = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var id = '';
  var check;

  @override
  void initState() {
    super.initState();
    title.text = widget.todo["title"];
    id = widget.todo["id"].toString();
    check = widget.todo["title"];
  }

  editUser() async {
    var newTitle = title.text;
      var url = Uri.parse('$baseUrl/$id');
      var bodyData = json.encode({
        'title': newTitle,
      });
      var response = await http.patch(url, body: bodyData);
      if (response.statusCode == 200) {
        print('\nSuccessfully edited ToDo id: $id!');
        var display = response.body;
        print(display);
      } else {
        return null;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(
          child: Text('Edit ToDo'),
        )),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(40.0),
            children: [
              TextFormField(
                controller: title,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter todo title';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (check != title.text){
                        await editUser();
                        Navigator.pop(context,check);
                      }else{
                        return null;
                      }
                    }else{
                      return null;
                    }
                  },
                  child: const Text('Done')),
            ],
          ),
        ));
  }
}
