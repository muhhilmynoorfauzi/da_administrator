import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class DetailClaimed extends StatefulWidget {
  const DetailClaimed({super.key});

  @override
  State<DetailClaimed> createState() => _DetailClaimedState();
}

class _DetailClaimedState extends State<DetailClaimed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: const SizedBox(),
        leadingWidth: 0,
        titleSpacing: 0,
        title: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.navigate_before_rounded, color: Colors.black),
          label: Text('sss', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {},
            child: Text('Simpan', style: TextStyle(color: Colors.black, fontSize: h4)),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
