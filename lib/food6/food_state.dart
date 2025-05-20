// food_state.dart
// Barrett Koster 2025
// 
// food5 did a flat map, even though our state could have
// recursive layers.  food6 should do those layers.

import 'dart:convert';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'munch.dart';


class FoodState
{ 
  List<Munch> munchies;

  FoodState(this.munchies) // constructor
  { print("------  FoodState constructor ....");
    for ( Munch m in munchies )
    { print("     ${m.what} ${m.when}");
    }
  }

  // turns the object into a map

  
  // This toMap() uses a little bit of depth.  
  // I am storing the munchies as just a list of foods = Strings (and we
  // are losing the 'when' field), but I leave the list as a
  // list in the map.  So the JSON en/de-code must know how
  // un pack and unpack the list of Strings.  
  Map<String,dynamic> toMap() // 2 
  { print("----- FoodState.toMap: starting ");
    Map<String,dynamic> theMap = {};
    List<String> foods = [];
    for ( Munch m in munchies )
    { String food = m.what;
      foods.add(food);
    }
    theMap['munchies'] = foods; // list of strings, so far

    return theMap;
  }
  /* So far this is doing the recursion but also getting confused about
     the nested encodings.  So we have 
----- Munch encoded as {"what":"apple","when":"2025-01-02 10:43:17"}
     which seems correct, but then 
 ----- FoodState encoded as {"munchies":["{\"what\":\"apple\",\"when\":\"2025-01-02 10:43:17\"}",
                                         "{\"what\":\"ban ....
     which takes the encoding as a string and then back-slashes all of the quotes inside.
     If you did it again, it would presumably back-slash all of the back-slashes too, leading
     to a recursive mess.  And while that mess is theoretically unpackable,
     you are not supposed to do it that way (JSON does not look like this).  
        But on the good side, the encode function IS recursing.  Maybe we can force 
     it to use toMap(), not toJson().  Try deleting the to/fromJson methods from
     Munch.  See if it uses the map (which may work right).   .. with v3 here.

     Nope.  If you comment out the toJson and fromJaon methods, the thing
     chokes.  So it needs those to do the recursion, but it is not doing
     them right.  I saw something about 'encodable' ... maybe I need that too.

    */
  

  // fromMap() ... turn the map back into an object
  
 

  // This one is trying to do hydrate with a list of strings.
  // It loses the dates, so we have to make dummy dates to 
  // re-make the Munch objects for FoodState.  But this one
  // WORKS.  
  factory FoodState.fromMap( Map<String,dynamic> theMap ) // 2
  { print("----- FoodState.fromMap: starting ... ");
    List<String> foods = theMap['munchies'];
    List<Munch> munchies = [];
    for ( String food in foods )
    { munchies.add( Munch(food, "98" ) ); }

    return FoodState( munchies );
  }


  // turns the object into JSON.  Does this by 
  // call toMap and then encode() ing the map.
  String toJson()
  { print("----- FoodState.toJson: starting ... ");
    String s  =  json.encode(toMap());
    print("----- FoodState encoded as $s");
    return s;
  }

  // I am not sure this EVER worked.
  // turns Json back into an objevct.  
  factory FoodState.fromJson( String source) 
  { print("----- FoodState.fromJson is making object from $source");
    return FoodState.fromMap( json.decode(source));
  }
   
}

class FoodCubit extends HydratedCubit<FoodState> // with HydratedMixin
{
  FoodCubit() : super( FoodState([ Munch("apple",/*99*/ "2025-01-02 10:43:17" ),
                                   Munch("banana", /*99*/"2025-01-03 8:41:00" ),
                                 ]) );

  void setFood(List<Munch> m ) { emit( FoodState(m) ); }

  void addFood( String f )
  { Munch m = Munch( f, /*99*/ DateTime.now().toString() );
    state.munchies.add(m);
    emit( FoodState(state.munchies) );
  }

  void reset() { emit( FoodState([]) ); }
  
  // converts the map form of FDState into an object.
  // Should have been called fromMap, as the Hydrated stuff
  // will have already converted it from JSON to a map.
  @override
  FoodState fromJson( Map<String,dynamic> map)
  { print("----- FoodCubit.fromJson: starting on $map" );
    return FoodState.fromMap(map);
  }

  // This is called on state AFTER emit(state).  Every time there is a new
  // state, this function converts it to a Map and the Hydrated
  // stuff takes it from there.  
  @override
  Map<String,dynamic> toJson( FoodState state )
  { print("----- FoodCubit.toJson: starting ... ");
    return state.toMap();
  }
  

}

