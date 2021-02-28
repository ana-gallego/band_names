import 'package:band_names/services/socket-service.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
//socketService.on()
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
          child: Column(children: [
        Text('Server status ' + '${socketService.serverStatus}'),
        Center(
          child: Text('Hola!'),
        ),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket.emit('new-message',
              {"nombre": "FLutter", "mensaje": "Saludos Gorgonitas!"});
          print("hola");
        },
        child: Icon(Icons.ac_unit),
      ),
    );
  }
}
