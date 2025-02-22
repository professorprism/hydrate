// Barrett Koster
// demo of Routing/Navigation

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

TextStyle ts = TextStyle(fontSize: 30);

class CounterState
{ int count;
  CounterState( this.count );
}
class CounterCubit extends Cubit<CounterState>
{
  CounterCubit() : super( CounterState(0) );

  void inc() { emit( CounterState(state.count+1) ); }
}

void main()
{ runApp( RoutesDemo() ); }

class RoutesDemo extends StatelessWidget
{
  RoutesDemo({super.key});

  @override
  Widget build( BuildContext context )
  { String title = "Routes Demo";
    return MaterialApp
    ( title: title,
      home: TopBloc()
    );
  }
}

class TopBloc extends StatelessWidget
{
  @override
  Widget build( BuildContext context )
  {
    return BlocProvider<CounterCubit>
    ( create: (context) => CounterCubit(),
      child: BlocBuilder<CounterCubit, CounterState>
      ( builder: (context,state) => Route1()
      ),
    );
  }
}

class Route1 extends StatelessWidget
{ final String title = "Route1";

  @override
  Widget build( BuildContext context )
  { CounterCubit cc = BlocProvider.of<CounterCubit>(context);
    return Scaffold
    ( appBar: AppBar( title: Text( title, style: ts) ),
      body: Column
      ( children: 
        [ Text("page 1", style:ts),
          Text("${cc.state.count}",style:ts),
          ElevatedButton
          ( onPressed: () { cc.inc(); },
            child: Text("add 1",style:ts),
          ),
          ElevatedButton
          ( onPressed: ()
            { Navigator.of(context).push
              ( MaterialPageRoute
                ( builder: (context) => Route2( cc:cc)
                ),
              );
            },
            child: Text("go to page 2", style:ts),
          ),
        ],
      ),
    );
  }
}

class Route2 extends StatelessWidget
{ final String title = "Route2";
  final   CounterCubit cc;
  Route2({ required this.cc, super.key});

  @override
  Widget build( BuildContext context )
  { 
    return BlocProvider<CounterCubit>.value // use existing CounterCubit
    ( value: cc,
      child: BlocBuilder<CounterCubit, CounterState>
      ( builder: (context,state)
        { return Scaffold
          ( appBar: AppBar( title: Text( title, style: ts) ),
            body: Column
            ( children: 
              [ Text("page 2", style:ts),
                Text("${cc.state.count}",style:ts),
                ElevatedButton
                ( onPressed: (){ cc.inc(); },
                  child: Text("add 1", style:ts),
                ),
                ElevatedButton
                ( onPressed: (){ Navigator.of(context).pop(); },
                  child: Text("go back",style:ts),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
