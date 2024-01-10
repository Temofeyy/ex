import 'package:flutter/material.dart';

class ExampleSave extends StatefulWidget {
  const ExampleSave({super.key});

  @override
  State<ExampleSave> createState() => _ExampleSaveState();
}

class _ExampleSaveState extends State<ExampleSave> {
  var query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              color: Colors.teal,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16),
              child: Align(
                alignment: Alignment.topCenter,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    surfaceTintColor: Colors.white,
                    backgroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.search_rounded),
                  label: SizedBox(
                    width: double.infinity,
                    child: Text(query.isNotEmpty? query: 'Search'),
                  ),
                  onPressed: () async {
                    final controller = TextEditingController();
                    final res = await showModalBottomSheet<String>(
                      context: context,
                      builder: (_){
                        return Column(
                          children: [
                            TextField(
                              controller: controller,
                            ),
                            FilledButton(
                              onPressed: (){
                                Navigator.of(context).pop(controller.text);
                              },
                              child: Text('Search'),
                            ),
                          ],
                        );
                      },
                    );
                    query = res ?? '';
                    setState(() {});
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.add), label: 'add'),
          NavigationDestination(icon: Icon(Icons.add), label: 'add'),
          NavigationDestination(icon: Icon(Icons.add), label: 'add')
        ],
      ),
    );
  }
}
