import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'AddTask Screen.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();

  void addTask(String taskTitle) {
    if (taskTitle.isNotEmpty) {
      firestore.collection('Tasks').add({
        'title': taskTitle,
        'isChecked': false,
      });
      _controller.clear();
    }
  }

  void toggleTask(String taskId, bool currentState) {
    firestore.collection('Tasks').doc(taskId).update({
      'isChecked': !currentState,
    });
  }

  void confirmDelete(String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel button
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              firestore.collection('Tasks').doc(taskId).delete();
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {NewTaskScreen(addTask: addTask).show(context);},
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.list,
                      color: Colors.lightBlueAccent,
                      size: 50,
                    ),
                    radius: 35,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Todos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection('Tasks').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          '0 Tasks',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        );
                      } else
                        return Text(
                          ' ${snapshot.data!.docs.length} Tasks',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4,vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('Tasks').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());

                    var tasks = snapshot.data!.docs;
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        var task = tasks[index];
                        String taskId = task.id;
                        String title = task['title'];
                        bool isChecked = task['isChecked'];

                        return GestureDetector(
                          onLongPress: () {
                            confirmDelete(taskId);
                          },
                          child: ListTile(
                            title: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                decoration:
                                isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: Checkbox(
                              activeColor: Colors.lightBlueAccent,
                              value: isChecked,
                              onChanged:
                                  (newValue) => toggleTask(taskId, isChecked),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
