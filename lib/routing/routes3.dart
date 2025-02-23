// routes3.dart
// Barrett Koster
// demo of Routing/Navigation
// this one does the routing with GENERATED routes.

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

class Router
{ CounterCubit cc = CounterCubit();
  Route genRoute( RouteSettings settings )
  { return settings.name=="/"
    ? MaterialPageRoute
      ( builder: (_) => BlocProvider.value
        ( value: cc, 
          child: Route1(),
        ),
      )
    : settings.name=="p2"
      ? MaterialPageRoute
        ( builder: (_) => BlocProvider.value
          ( value: cc, 
            child: Route2(),
          ),
        )
      : MaterialPageRoute
        ( builder: (_) => BlocProvider.value
          ( value: cc, 
            child: Route1(),
          ),
        )
    ;
  }
  dispose()
  { cc.close(); }
}

void main()
{ runApp( RoutesDemo() ); }

class RoutesDemo extends StatelessWidget
{ Router routy = Router();
  RoutesDemo({super.key});
  // final CounterCubit cc = CounterCubit();

  @override
  Widget build( BuildContext context )
  { String title = "Routes Demo";
    return BlocProvider<CounterCubit>
    ( create: (context) => CounterCubit(),
      child:  MaterialApp
      ( title: title,
        onGenerateRoute: routy.genRoute,
        // home: TopBloc()
      ),
    );
  }
}

class Route1 extends StatelessWidget
{ final String title = "Route1";

  @override
  Widget build( BuildContext context )
  { return BlocBuilder<CounterCubit,CounterState>
    ( builder: (context,state)
      { CounterCubit cc = BlocProvider.of<CounterCubit>(context);
        return  Scaffold
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
                { Navigator.of(context).pushNamed("p2"); },
                child: Text("go to page 2", style:ts),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Route2 extends StatelessWidget
{ final String title = "Route2";

  @override
  Widget build( BuildContext context )
  { return BlocBuilder<CounterCubit,CounterState>
    ( builder: (context,state)
      { CounterCubit cc = BlocProvider.of<CounterCubit>(context);
        return Scaffold
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
    );
  }
}


