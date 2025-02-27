// use_keyboard.dart
// Barrett Koster

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

FocusNode fn = FocusNode();

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
        { cc.update( event.character ?? "zip" );
          print("------------${event.character}");
        },
        child: Text(cc.state.ch, style:TextStyle(fontSize:82) ),
      ),
    );
  }
}