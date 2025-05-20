// food_diary.dart 
// Barrett Koster
// 
// this is version 7, and we are trying to make the state
// recursive, or at least have a little depth (not just String:String).

import "dart:io";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'food_state.dart';
import 'munch.dart';


void main() async
{ await hydratePrep();
  runApp(const FoodDiary());
}

Future<void> hydratePrep() async
{ WidgetsFlutterBinding.ensureInitialized();
  Directory addx = await getApplicationDocumentsDirectory();
  String add = addx.path;
  HydratedBloc.storage = await HydratedStorage.build
  (  storageDirectory: HydratedStorageDirectory
    ( (await getApplicationDocumentsDirectory()).path,),
  );
  print("add=$add");
}

class FoodDiary extends StatelessWidget
{ static const String header = "Food Diary 7";

  const FoodDiary({super.key});

  @override
  Widget build(BuildContext context) 
  { return MaterialApp
    ( title: header,
      home: BlocProvider<FoodCubit>
      ( create: (context) => FoodCubit(),
        child: BlocBuilder<FoodCubit,FoodState>
        ( builder: (context,state)
          { // FDCubit fdc =  BlocProvider.of<FDCubit>(context);
            return  Core(title: header, /* fdc:fdc */ );
          },
        ),
      ),
    );
  }
}

class Core extends StatelessWidget 
{ final String title;
  // final FDCubit fdc;
  const Core({super.key, required this.title } );

  @override
  Widget build(BuildContext context) 
  { FoodCubit fc = BlocProvider.of<FoodCubit>(context);
    FoodState fs = fc.state;
    TextEditingController tec = TextEditingController();

    print("json=${fs.toJson()}"); // debugging

    return Scaffold
    ( appBar: AppBar(  title: Text(title),),
      body: Column
      ( children: 
        [ Container
          ( height:300, width:400,
            decoration: BoxDecoration( border:Border.all(width:1)),
            child: makeListView(context),
          ),
          SizedBox
          ( height:50, width:300,
            child: TextField(controller: tec ),
          ),
          ElevatedButton
          ( onPressed: (){ fc.addFood(tec.text); },
            child: Text("submit"),
          ),
          ResetButton(),
        ],
      ),
    );
  }     

  Widget makeListView( BuildContext context )
  { FoodCubit fc = BlocProvider.of<FoodCubit>(context);
    FoodState fs = fc.state;
    List<Munch> theList = fs.munchies;

    List<Widget> kids = [];
    for ( Munch m in theList )
    { // String t = DateTime.parse(m.when).hour.toString();
      String t = m.when;
      String label = "$t ${m.what}";
      kids.add
      ( ElevatedButton
        ( onPressed: (){},
          child:  Text( label ),
        )
      );
    }

    Wrap wr = Wrap
    ( children:kids,
    );
    ListView lv = ListView
    ( scrollDirection: Axis.vertical,
      // itemExtent: 30,
      children: [wr],
    );
    return lv;
  }
}

class ResetButton extends StatelessWidget
{ Widget build( BuildContext context )
  { FoodCubit fc = BlocProvider.of<FoodCubit>(context);
    return ElevatedButton
    ( onPressed: (){ fc.reset(); },
      child: Text("reset"),
    );
  }
}
