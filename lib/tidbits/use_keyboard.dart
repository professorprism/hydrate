// use_keyboard.dart
// Barrett Koster
// Demo that shows how to listen to the keyboard.
// This is not getting the full keyboard but only
// the printables. Hmmm.

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

FocusNode fn = FocusNode();

// trivial state, holds the latest character (it is the CODE 
// for the character, might be more than one letter)
class CharState
{ String ch;
  CharState( this.ch );
}
class CharCubit extends Cubit<CharState>
{
  CharCubit() : super( CharState("zip") );
  void update( String s ) { emit( CharState(s) ); }
}

void main()
{ runApp( KeyDemo() ); }

// layer ... holds the BLoC stuff
class KeyDemo extends StatelessWidget
{
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "Keyboard demo",
      home: BlocProvider<CharCubit>
      ( create: (context) => CharCubit(),
        child: BlocBuilder<CharCubit,CharState>
        ( builder: (context,state) => KeyDemo1(), ),// Text("hi there"),
      ),
    );
  }
}

// page layout ... listen, show the character
class KeyDemo1 extends StatelessWidget
{
  Widget build( BuildContext context )
  {
    CharCubit cc = BlocProvider.of<CharCubit>(context);

    return Scaffold
    ( appBar: AppBar( title: Text("kb demo"), ),
      body: KeyboardListener
      ( focusNode: fn,
        autofocus: true,
        onKeyEvent: (event)
        { 
          cc.update( event.logicalKey.keyLabel  );
          // cc.update( event.character ?? "zip" );
          print("------------${event.character ?? "zip"} // ${event.logicalKey.keyLabel}");
        },
        child: Text(cc.state.ch, style:TextStyle(fontSize:50) ),
      ),
    );
  }
}