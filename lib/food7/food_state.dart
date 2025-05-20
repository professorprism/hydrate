// food_state.dart
// Barrett Koster 2025
// 
// v7
// food7 we are getting some traction with the recursion into
// Munch, but it is not going all the way through, yet.

import 'dart:convert';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'munch.dart';


class FoodState
{ 
  List<Munch> munchies;

  FoodState(this.munchies)
  { print("------- FoodState constructed ....");
    for ( Munch m in munchies )
    { print ("       ${m.what} ${m.when}");
    }
    print("");
  } // constructor

  // toMap()
  // turns the object into a map.
  // Note: the 'toEncodable' stuff is not working, so we are making
  // this map to be ONLY things that JSON encoder knows how to 
  // encode.  
  Map<String,dynamic> toMap() // 3
  { print("----- FoodState.toMap: starting ...");
    Map<String,dynamic> theMap = {};
    // theMap['munchies'] = munchies;
    List<Map<String,dynamic>> theList = [];
    for ( Munch m in munchies )
    {
      theList.add( m.toMap() ); // encode map version of the Munch
    } 
    theMap["munchies"] = theList;
    print(" +++ FoodState.toMap about to return $theMap");
    return theMap;
  }

  // factory FoodState.fromMap() .... like a contructor.
  // theMap we are using now is a JSON-readable map, so just strings,
  // ints, lists and more maps.  No Munch or other objects.
  // Flutter could handle maps of whatever, per say, but the 
  // encode/decode stuff does not know Munch, etc..
  factory FoodState.fromMap( Map<String,dynamic> theMap) // 3
  { print("----- FoodState.fromMap: starting .... ");
    List<Munch> munchies = []; // in a factory, we cannot use member 
    // variables. So we define muhchies here, then it becomes the member.

    // The decode of the map is a list of little 2-item maps.  We want
    // turn those little maps into Munch objects, but they are not that yet.
    print("===== about to referene theMap");
    dynamic mmaps = theMap['munchies']; // crashed when not 'dynamic'
      // and caused the Hydrate-load to fail but no error was given
    print("===== just referenced theMap");
    for ( Map<String,dynamic> mmap in mmaps )
    {
       String wut = mmap['what'] ?? "dk";
       String wen = mmap['when'] ?? "dk";
       print("     about to make Munch($wut,$wen)");
       Munch m = Munch( mmap['what']!, mmap['when']!);
       munchies.add(m);
    }
    print("------- FoodState.fromMap: returning made from $munchies");
    return FoodState(munchies);
  }
  

  // turns the object into JSON.  Does this by 
  // call toMap and then encode() ing the map.
  // Note the 'toEncodable' method.  If an item in the encoding is
  // not a standard one, it calls this function.
  // Our map is presently made of all standard things, so this
  // is not used that I know of.
  String toJson()
  { print("----- FoodState.toJson: starting ... ");
    // String s  =  json.encode(toMap());
    String s = jsonEncode
    ( toMap(),
      toEncodable: (Object? m) => m is Munch
        ? m.toMap() // .toJson() is wrong, has the extra layer of " and \\  
        : throw UnsupportedError("unknown JSON for $m"),
    );
    print("----- FoodState encoded as $s");
    return s;
  }

  /*  ... from an example I found
      final jsonText = jsonEncode({'cc': cc},
      toEncodable: (Object? value) => value is CustomClass
          ? CustomClass.toJson(value)
          : throw UnsupportedError('Cannot convert to JSON: $value'));
  */

  // I am not sure this EVER worked. I do not know that it is called.
  // turns Json back into an object.  
  factory FoodState.fromJson( String source) 
  { print("----- FoodState.fromJson starting from $source");
    Map<String,dynamic> step1 = json.decode(source); 
    print("FoodState.fromJson.step1=$step1");
    return FoodState.fromMap( step1 );
  }
   
}

class FoodCubit extends HydratedCubit<FoodState> // with HydratedMixin
{
  FoodCubit() : super( FoodState([ Munch("apple","99" /*"2025-01-02 10:43:17"*/ ),
                                   Munch("banana", "99" /*"2025-01-03 8:41:00"*/ ),
                                 ]) );

  void setFood(List<Munch> m ) { emit( FoodState(m) ); }

  void addFood( String f )
  { Munch m = Munch( f, "97" /* DateTime.now().toString()*/  );
    state.munchies.add(m);
    emit( FoodState(state.munchies) );
  }

  void reset() { emit( FoodState([]) ); }
  
  // fromJson()
  // converts the map form of FoodState into a FoodState object.
  // Should have been called fromMap, as the Hydrated stuff
  // will have already converted it from JSON to a map.
  // Note: the map is just the regular stuff that JSON encode/decode
  // knows how to handle.  There are no Munch objects.
  @override
  FoodState fromJson( Map<String,dynamic> map)
  { print("----- FoodCubit.fromJson: starting on $map");
    return FoodState.fromMap(map);
  }

  // This is called on state AFTER emit(state).  Every time there is a new
  // state, this function converts it to a Map and the Hydrated
  // stuff takes it from there.  
  @override
  Map<String,dynamic> toJson( FoodState state )
  { print("----- FoodCubit.toJson: starting ...");
    Map<String,dynamic> theMap = state.toMap();
    print("FoodCubit.toJson about to return $theMap");
    return theMap;
  }
  

}

