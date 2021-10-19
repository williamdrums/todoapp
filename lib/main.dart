import 'package:apptodo/models/item.dart';
import 'package:flutter/material.dart';
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

  HomePage() {
    items = [];
    items.add(Item(title: "Item 1", done: false));
    items.add(Item(title: "Item 2", done: true));
    items.add(Item(title: "Item 3", done: false));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//adicionando item a lista
  void add() {
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      widget.items.add(Item(
        title: newTaskCtrl.text,
        done: false,
      ));
      newTaskCtrl.clear();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  var newTaskCtrl = TextEditingController();
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
