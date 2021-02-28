import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.socket.on('active-bands', _handleActiveBands);
    });
    super.initState();
  }

  _handleActiveBands(dynamic _bands) {
    this.bands = (_bands as List).map((e) => Band.fromMap(e)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Band Names', style: TextStyle(color: Colors.black)),
              Icon(Icons.ac_unit)
            ]),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(Icons.check_circle, color: Colors.blueAccent)
                  : Icon(Icons.offline_bolt, color: Colors.red))
        ],
      ),
      body: Column(children: [_chart(), _bandsList()]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  _chart() {
    Map<String, double> dataMap = {};
    bands.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });
    return PieChart(dataMap: dataMap);
  }

  _bandsList() {
    return Expanded(
        child: ListView.builder(
      itemCount: bands.length,
      itemBuilder: (BuildContext context, int i) => _bandTile(
        bands[i],
      ),
    ));
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
        key: Key(band.id),
        onDismissed: (_) =>
            socketService.socket.emit('delete-band', band.toJson()),
        direction: DismissDirection.endToStart,
        background: Container(
            padding: EdgeInsets.only(right: 10),
            color: Colors.red,
            child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ))),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Colors.pink[100],
          ),
          title: Text(band.name),
          trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
          onTap: () => socketService.socket.emit('vote-band', band.toJson()),
        ));
  }

  addNewBand() {
    final TextEditingController controller = TextEditingController();
    if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text('New band name'),
                content: CupertinoTextField(controller: controller),
                actions: [
                  CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () => addBandToList(controller.text),
                      child: Text('Add')),
                ],
              ));
    } else {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text('New band name:'),
                  content: TextField(
                    controller: controller,
                  ),
                  actions: [
                    MaterialButton(
                        onPressed: () => addBandToList(controller.text),
                        child: Text('Add'),
                        elevation: 5)
                  ]));
    }
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    if (name.trim().length > 0) {
      socketService.socket.emit('add-band', {"name": name});
    }
    Navigator.pop(context);
  }
}
