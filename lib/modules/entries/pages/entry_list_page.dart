import 'package:flutter/material.dart';

class EntryListPage extends StatefulWidget {
  const EntryListPage({super.key});

  @override
  State<EntryListPage> createState() => _EntryListPageState();
}

class _EntryListPageState extends State<EntryListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Entries'),
      ),
    );
  }
}
