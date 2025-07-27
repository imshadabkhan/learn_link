import 'package:flutter/material.dart';

class GuardianDashboard extends StatefulWidget {
  @override
  _GuardianDashboardState createState() => _GuardianDashboardState();
}

class _GuardianDashboardState extends State<GuardianDashboard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  String studentName = '';
  String studentAge = '';
  List<Map<String, String>> studentHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void registerStudent() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        studentHistory.add({
          'name': studentName,
          'age': studentAge,
          'label': 'Not Labeled',
        });
        studentName = '';
        studentAge = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Student registered successfully')));
    }
  }

  void labelStudent(int index, String label) {
    setState(() {
      studentHistory[index]['label'] = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Guardian Dashboard"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Register Student"),
            Tab(text: "Student History"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Student Name'),
                    onSaved: (value) => studentName = value ?? '',
                    validator: (value) => value!.isEmpty ? 'Enter name' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Student Age'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => studentAge = value ?? '',
                    validator: (value) => value!.isEmpty ? 'Enter age' : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: registerStudent,
                    child: Text("Register Student"),
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            itemCount: studentHistory.length,
            itemBuilder: (context, index) {
              final student = studentHistory[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(student['name']!),
                  subtitle: Text("Age: ${student['age']} | Label: ${student['label']}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (label) => labelStudent(index, label),
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'Dyslexic', child: Text("Mark as Dyslexic")),
                      PopupMenuItem(value: 'Not Dyslexic', child: Text("Mark as Not Dyslexic")),
                    ],
                    icon: Icon(Icons.label),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
