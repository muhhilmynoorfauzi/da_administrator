import 'package:flutter/material.dart';

class AutoScrollListView extends StatefulWidget {
  const AutoScrollListView({super.key});

  @override
  _AutoScrollListViewState createState() => _AutoScrollListViewState();
}

class _AutoScrollListViewState extends State<AutoScrollListView> {
  final ScrollController _scrollController = ScrollController();
  bool _scrollingDown = true; // Flag untuk menentukan arah scroll

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _autoScroll());
  }

  void _autoScroll() async {
    while (true) {
      if (_scrollingDown) {
        // Scroll ke bagian paling bawah
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 5),
          curve: Curves.easeInOut,
        );
      } else {
        // Scroll ke bagian paling atas
        await _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 5),
          curve: Curves.easeInOut,
        );
      }
      // Ubah arah scroll
      _scrollingDown = !_scrollingDown;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auto Scroll Example"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 30, // Jumlah item di ListView
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';

class DataRoomPage extends StatelessWidget {
  const DataRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    var listNoRoom = ["SNSS01", "SNSS02", "SNSS03"];

    return Scaffold(
      appBar: AppBar(title: const Text("Data Room Page")),
      body: ListView.builder(
        itemCount: listNoRoom.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listNoRoom[index]),
            onTap: () {
              Navigator.pushNamed(context, '/${listNoRoom[index]}');
            },
          );
        },
      ),
    );
  }
}

class DetailRoomPage extends StatelessWidget {
  final String codeRoom;

  const DetailRoomPage({super.key, required this.codeRoom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Room: $codeRoom")),
      body: Center(
        child: Text("Room Code: $codeRoom"),
      ),
    );
  }
}
*/
