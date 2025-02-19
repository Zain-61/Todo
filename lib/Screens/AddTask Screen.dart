import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTaskScreen  {

  final TextEditingController _controller = TextEditingController();
  final Function(String) addTask; // Callback to add task

  NewTaskScreen({required this.addTask});
  void show(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder:
            (context) => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                enableSuggestions: false, autocorrect: false,
                controller: _controller,
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.lightBlueAccent,
                      width: 4,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.lightBlueAccent,
                  ),
                  minimumSize: MaterialStateProperty.all(
                    Size.fromHeight(50),
                  ),
                ),
                onPressed: () {
                  addTask(_controller.text);
                  Navigator.pop(context);
                },
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

