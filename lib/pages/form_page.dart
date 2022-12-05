import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/todo_model.dart';

class TodoForm extends StatefulWidget {
  const TodoForm({Key? key}) : super(key: key);

  @override
  State<TodoForm> createState() => _TodoFormState();
}

const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

Future<TodoModel?> submitData(String title, bool status) async {
  var url = Uri.parse(baseUrl);
  var bodyData = json.encode({'title': title, 'completed': status});
  var response = await http.post(url, body: bodyData);

  if (response.statusCode == 201) {
    print('Successfully added ToDo!');
    var display = response.body;
    print(display);
    String todoResponse = response.body;
    todoModelFromJson(todoResponse);
  } else {
    return null;
  }
}

class _TodoFormState extends State<TodoForm> {
  var formKey = GlobalKey<FormState>();
  TodoModel? todoModel;
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text('Add ToDo'),
      )),
      body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(40.0),
            children: [
              TextFormField(
                controller: title,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Todo Title',
                    hintText: 'e.g Exercise'),
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
                      TodoModel? data = await submitData(title.text, false);
                      setState(() {
                        todoModel = data;
                      });
                    } else {
                      return null;
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Submit'))
            ],
          )),
    );
  }
}
