// s4.dart.  This is a GUI demo of socket connections.
// Barrett Koster
// working from notes from Suragch
// ... and then from my s3.dart


// server.listen() defines a function that gets
// called EVERY time a client calls the server.  We 
// can make a server that handles lots of clients, but
// we start with one.  

import 'dart:io';
import 'dart:typed_data';

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ConnectionState
{
  bool listening = false;
  Socket? theClient = null;

  ConnectionState( this.listening, this.theClient );
}
class ConnectionCubit extends Cubit<ConnectionState>
{
  ConnectionCubit() : super( ConnectionState(false, null) )
  { connect(); }

  update( bool b, Socket s ) { emit( ConnectionState(b,s) ); }

  Future<void>  connect() async
  { await Future.delayed( const Duration(seconds:2) ); // adds drama
      // bind the socket server to an address and port
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, 9203);
    print("server socket created?");
    // listen for clent connections to the server
    server.listen
    ( (client)
      { emit( ConnectionState(true,client) ); }
    );
    emit( ConnectionState(true,null) );
    print("server waiting for client");
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
  runApp( Server () );
}

class Server extends StatelessWidget
{ @override
  Widget build( BuildContext context )
  {
    return MaterialApp
    ( title: "server",
      home: BlocProvider<ConnectionCubit>
      ( create: (context) => ConnectionCubit(),
        child: BlocBuilder<ConnectionCubit,ConnectionState>
        ( builder: (context, state) => BlocProvider<SaidCubit>
          ( create: (context) => SaidCubit(),
            child: BlocBuilder<SaidCubit,SaidState>
            ( builder: (context,state) =>
              Server2(),
            ),
          ),
        ),
      ),
    );
  }
}

class Server2 extends StatelessWidget
{ final TextEditingController tec = TextEditingController();

  @override
  Widget build( BuildContext context )
  { ConnectionCubit cc = BlocProvider.of<ConnectionCubit>(context);
    ConnectionState cs = cc.state;
    SaidCubit sc = BlocProvider.of<SaidCubit>(context);

    if ( cs.theClient != null )
    { listen(context);
    } 

    return Scaffold
    ( appBar: AppBar( title: Text("server") ),
      body: Column
      ( children:
        [ // place to type and sent button
          SizedBox
          ( child: TextField(controller: tec) ),
          ElevatedButton
          ( onPressed: (){},
            child: Text("send to client"),
          ),
          cs.listening
          ? cs.theClient!=null
            ? Text(sc.state.said)
            : Text("waiting for client to call ...")
          : Text("server loading ... "),
        ],
      ),
    );
  }

  void listen( BuildContext bc )
  { ConnectionCubit cc = BlocProvider.of<ConnectionCubit>(bc);
    ConnectionState cs = cc.state;
    SaidCubit sc = BlocProvider.of<SaidCubit>(bc);

    cs.theClient!.listen
    ( (Uint8List data) async
      { final message = String.fromCharCodes(data);
        sc.update(message);
      },
          // handle errors
      onError: (error)
      { print(error);
        cs.theClient!.close();
      },
    );
  }
}

// For each client, we need to have a thread that listens
// for something from the client and does something about it.
// In the case where a server is just a means of communication
// between clients, those are all of the threads.
// In the case where the server also interacts with its
// user, it also needs its own thread (not attached to any client).

// server side.  Run this in a terminal.
// Than run the client.  Then type stuff at the prompt.
// Note that it takes a couple of cycles to catch up ... 
// the sync has not been worked out well.

void main2() async
{
  Socket? theClient;

  // bind the socket server to an address and port
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 9203);
  print("server socket created?");
  // listen for clent connections to the server
  server.listen((client) {
    handleConnection(client);
    theClient = client;
  });

  print("talk: ");
  String? sed = stdin.readLineSync();
  while (sed! != "quit")
  { 
    if ( theClient != null )
    { print("trying to send: $sed");
      await sendMessage(theClient!,sed);
    }
    else{ print("not ready");}
    print("talk: ");
    sed = stdin.readLineSync();
  }

  
}

void handleConnection(Socket client) {
  print('Connection from'
      ' ${client.remoteAddress.address}:${client.remotePort}');

  Socket theClient = client;
  // listen for events from the client
  client.listen(

    // handle data from the client
    (Uint8List data) async {
      // await Future.delayed(Duration(seconds: 1));
      final message = String.fromCharCodes(data);
      print("client: $message");
      if (message == 'Knock, knock.') {
        client.write('Who is there?');
      } else if (message.length < 10) {
        client.write('$message who?');
      } else {
        client.write('Very funny.');
        client.close();
      }
    },

    // handle errors
    onError: (error) {
      print(error);
      client.close();
    },

    // handle the client closing the connection
    onDone: () {
      print('Client left');
      client.close();
    },
  );
}

Future<void> sendMessage(Socket socket, String message) async {
  print('Client: $message');
  socket.write(message);
  // await Future.delayed(Duration(seconds: 2));
}