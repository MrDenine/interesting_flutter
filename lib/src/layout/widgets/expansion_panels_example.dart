import 'package:flutter/material.dart';

class ExpansionPanelsExample extends StatefulWidget {
  const ExpansionPanelsExample({super.key});

  @override
  State<ExpansionPanelsExample> createState() => _ExpansionPanelsExampleState();
}

class _ExpansionPanelsExampleState extends State<ExpansionPanelsExample> {
  final List<bool> _isExpanded = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded[index] = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text('Panel 1'),
                leading: Icon(Icons.star, color: Colors.orange),
              );
            },
            body: Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'This is the content of panel 1. It contains some interesting information about Flutter widgets.',
              ),
            ),
            isExpanded: _isExpanded[0],
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text('Panel 2'),
                leading: Icon(Icons.favorite, color: Colors.red),
              );
            },
            body: Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'This is the content of panel 2. Here you can add more detailed information.',
              ),
            ),
            isExpanded: _isExpanded[1],
          ),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return const ListTile(
                title: Text('Panel 3'),
                leading: Icon(Icons.settings, color: Colors.blue),
              );
            },
            body: Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'This is the content of panel 3. Expansion panels are great for organizing content.',
              ),
            ),
            isExpanded: _isExpanded[2],
          ),
        ],
      ),
    );
  }
}
