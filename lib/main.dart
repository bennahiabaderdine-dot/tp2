import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP2 Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  List<String> _names = [];

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    final prefs = await SharedPreferences.getInstance();
    final String? namesJson = prefs.getString('names_list');
    if (namesJson != null) {
      setState(() {
        _names = List<String>.from(jsonDecode(namesJson));
      });
    }
  }

  Future<void> _saveNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('names_list', jsonEncode(_names));
  }

  void _addName() {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();

    if (nom.isNotEmpty && prenom.isNotEmpty) {
      setState(() {
        _names.add("$prenom $nom");
        _nomController.clear();
        _prenomController.clear();
      });
      _saveNames();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Noms'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addName,
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Liste des personnes :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _names.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(_names[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
