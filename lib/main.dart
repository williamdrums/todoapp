import 'dart:convert';

import 'package:apptodo/models/item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/cupertino.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = [];

  HomePage({Key? key}) : super(key: key) {
    items = [];
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();
//adicionando item a lista
  void add() {
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.items.add(Item(
        title: newTaskCtrl.text,
        done: false,
      ));
      newTaskCtrl.clear();
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  Future loadData() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      //transformando string em json
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  _HomePageState() {
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextFormField(
        keyboardType: TextInputType.text,
        controller: newTaskCtrl,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        // ignore: prefer_const_constructors
        decoration: InputDecoration(
          labelText: "Nova Tarefa",
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
        ),
      )),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];

//Dismissible efeito de arrastar item da tela
          return Dismissible(
              child: CheckboxListTile(
                title: Text(item.title),
                value: item.done,
                onChanged: (value) {
                  //altera o widget e atualiza a tela
                  setState(() {
                    item.done = value;
                    save();
                  });
                },
              ),
              key: Key(item.title),
              background: Container(
                color: Colors.red.withOpacity(0.9),
              ),
              onDismissed: (direction) {
                remove(index);
              });
        },
      ),

      //criando o botão add +
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
