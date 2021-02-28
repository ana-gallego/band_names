import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
export 'package:provider/provider.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  IO.Socket get socket => this._socket;

  set socket(IO.Socket socket) {
    _socket = socket;
  }

  ServerStatus get serverStatus => this._serverStatus;

  set serverStatus(ServerStatus serverStatus) {
    _serverStatus = serverStatus;
    notifyListeners();
  }

  SocketService() {
    this._initConfig();
  }

  _initConfig() {
    /// Dart client
    this._socket = IO.io('https://bands-skt-server.herokuapp.com/', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('connect_error', (_) => print(_));

    socket.on('new-message', (_) {
      print('Nuevo mensajeeeeeeeee $_');
    });
  }
}
