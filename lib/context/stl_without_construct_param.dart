import 'dart:math';

import 'package:flutter/material.dart';

class ExampleStateful extends StatefulWidget {
  const ExampleStateful({super.key});

  @override
  State<ExampleStateful> createState() => _ExampleStatefulState();

  static List<User> of(BuildContext context) => context.findAncestorStateOfType<_ExampleStatefulState>()!.users;
}

class _ExampleStatefulState extends State<ExampleStateful> {
  List<User> _users = [];
  List<User> get users => List.of(_users);

  void addUser(){
    final copy = List.of(_users);
    _users.add((copy..shuffle()).elementAt(2));
    setState(() {});
  }

  @override
  void initState() {
    _users = _testData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Stateless widget without params in constructor'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Users:'),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: addUser,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            Flexible(
              child: _UserList(),
            )
          ],
        ),
      ),
    );
  }
 
}

class _UserList extends StatelessWidget {
  const _UserList({super.key});


  @override
  Widget build(BuildContext context) {
    final users = ExampleStateful.of(context);
    return ListView.builder(
      itemCount: users.length,
      shrinkWrap: true,
      itemBuilder: (_, index){
        final current = users[index];
        return ListTile(
          tileColor: randomColor(),
          title: Text('${current.name} (${current.age}y.o.)'),
          subtitle: Text('${current.moneyPerMonth}\$ /month'),
        );
      },
    );
  }
}



class User{
  String name;
  int age;
  double moneyPerMonth;

  User(this.name, this.age, this.moneyPerMonth);
}

final _testData = [
  User('Igor', 24, 2000),
  User('Seva', 20, 1000),
  User('Sofa', 17, 0),
  User('Lanos', 80, -1),
  User('Danil', 19, 4000),
  User('Frank', 56, -100),
];

Color randomColor(){
  final rand = Random();
  final color = Color.fromARGB(
    255,
    rand.nextInt(255),
    rand.nextInt(255),
    rand.nextInt(255),
  );
  return color;
}
