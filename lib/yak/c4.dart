// Barrett Koster
// working from notes from Suragch

// client side of connection


import 'dart:io';
import 'dart:typed_data';

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ConnectionState
{
  Socket? theServer = null;

  ConnectionState( this.theServer );
}
class ConnectionCubit extends Cubit<ConnectionState>
{
  ConnectionCubit() : super( ConnectionState( null) )
  { connect(); }

  update( Socket s ) { emit( ConnectionState(s) ); }

  Future<void>  connect() async
  { await Future.delayed( const Duration(seconds:2) ); // adds drama
      // bind the socket server to an address and port
      // connect to the socket server
    final socket = await Socket.connect('localhost', 9203);
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
    update(socket);
  }
}


class SaidState
{
   String said;

   SaidState( this.said );
}

class SaidCubit extends Cubit<SaidState>
{
  SaidCubit() : super( SaidState("and so it begins ....\n" ) );

  // void update( String more ) { emit(SaidState( "${state.said}$more\n" ) ); } 
  void update( String s ) { emit( SaidState(s) ); }
}

void main()
{
  runApp( Client () );
}

class Client extends StatelessWidget
{ @override
  Widget build( BuildContext context )
  {
    return MaterialApp
    ( title: "client",
      home: BlocProvider<ConnectionCubit>
      ( create: (context) => ConnectionCubit(),
        child: BlocBuilder<ConnectionCubit,ConnectionState>
        ( builder: (context, state) => BlocProvider<SaidCubit>
          ( create: (context) => SaidCubit(),
            child: BlocBuilder<SaidCubit,SaidState>
            ( builder: (context,state) =>
              Client2(),
            ),
          ),
        ),
      ),
    );
  }
}

class Client2 extends StatelessWidget
{ final TextEditingController tec = TextEditingController();

  @override
  Widget build( BuildContext context )
  { ConnectionCubit cc = BlocProvider.of<ConnectionCubit>(context);
    ConnectionState cs = cc.state;
    SaidCubit sc = BlocProvider.of<SaidCubit>(context);

    if ( cs.theServer != null )
    { listen(context);
    } 

    return Scaffold
    ( appBar: AppBar( title: Text("client") ),
      body: Column
      ( children:
        [ // place to type and sent button
          SizedBox
          ( child: TextField(controller: tec) ),
          ElevatedButton
          ( onPressed: (){},
            child: Text("send to client"),
          ),
          cs.theServer!=null
          ? Text(sc.state.said)
          : Text("waiting for call to go through ..."),
        ],
      ),
    );
  }

  void listen( BuildContext bc )
  { ConnectionCubit cc = BlocProvider.of<ConnectionCubit>(bc);
    ConnectionState cs = cc.state;
    SaidCubit sc = BlocProvider.of<SaidCubit>(bc);

    cs.theServer!.listen
    ( (Uint8List data) async
      { final message = String.fromCharCodes(data);
        sc.update(message);
      },
          // handle errors
      onError: (error)
      { print(error);
        cs.theServer!.close();
      },
    );
  }
}

/*
void main() async 
{

  // connect to the socket server
  final socket = await Socket.connect('localhost', 9203);
  print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

  // listen for responses from the server
  socket.listen(

    // handle data from the server
    (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      print('Server: $serverResponse');
    },

    // handle errors
    onError: (error) {
      print(error);
      socket.destroy();
    },

    // handle server ending connection
    onDone: () {
      print('Server left.');
      socket.destroy();
    },
  );


  print("talk: ");
  String? sed = stdin.readLineSync();
  while (sed! != "quit")
  { print("trying to send: $sed");
    await sendMessage(socket,sed);
    print("talk: ");
    sed = stdin.readLineSync();
  }

  /* 
  // send some messages to the server
  await sendMessage(socket, 'Knock, knock.');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Banana');
  await sendMessage(socket, 'Orange');
  await sendMessage(socket, "Orange you glad I didn't say banana again?");
  */
}

Future<void> sendMessage(Socket socket, String message) async {
  print('Client: $message');
  socket.write(message);
  // await Future.delayed(Duration(seconds: 2));
}
*/