// Barrett Koster
// working from notes from Suragch

// server side.  Run this in a terminal.
// Than run the client.  Then type stuff at the prompt.
// Note that it takes a couple of cycles to catch up ... 
// the sync has not been worked out well.

// How.  You open the socket.  This can take time, but
// you wait for it.  Fine.
// The .listen also takes time, until a client calls in,
// and we do NOT wait for that.  But the server-send
// below does not send anything if there is no client.  

// For each client, we need to have a thread that listens
// for something from the client and does something about it.
// In the case where a server is just a means of communication
// between clients, those are all of the threads.
// In the case where the server also interacts with its
// user, it also needs its own thread (not attached to any client).

// Reading from the client is, in this version at least, tied
// in a cycle of writing from the server.  You 
// can code them to run independently, but the async
// of this works ok on a Mac terminal but not on a PC.  
// The PC simply will not print the client's message 
// until after the server read completes.  So we need a 
// Flutter i.e., windows version.


import 'dart:io';
import 'dart:typed_data';


void main() async
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