// munch.dart
// Barrett Koster 2025
// This is for ONE item, something you ate
// and when you ate it, presumably.

// import "package:flutter/material.dart";

import 'dart:convert';

class Munch 
{
  String what; // name of the food
  String when; // date+time stored as string to not hang on format,
               // for now
  // int when;
  // DateTime when;

  Munch( this.what, this.when );
  // Munch( this.what, String whenString )
  // : when = DateTime.parse(whenString);

  // returns a Map containing the information of this object
  Map<String,dynamic> toMap()
  { print("Munch.toMap: called on $what");
    Map<String,dynamic> theMap = {};
    theMap['what'] = what;
    theMap['when'] = when;
    return theMap;
  }

  // returns an object made from the Map
  factory Munch.fromMap( Map<String,dynamic> theMap )
  { print("Munch.fromMap called on ${theMap['what']}");
    String what = theMap['what'];
    String when = theMap['when'];
    return Munch(what,when);
  }

  /* This was just trying stuff.  probably not a good idea
  // do it as just to MAP
  Map<String,dynamic> toJson()
  { print("Munch.toJson called on $what");
    return toMap();
  }
  */

  
  // turns the object into JSON.  Does this by 
  // call toMap and then encode() ing the map.
  String toJson()
  { String s = json.encode(toMap());
    print("----- Munch encoded as $s");
    return s;
  }
  
  /* This was part of just trying stuff.  not good.
  // do it as just from MAP
  factory Munch.fromJson( Map<String,dynamic> map )
  { print("Munch.fromJson called on ${map['what']}");
    return Munch.fromMap(map);
  }
  */

  
  // turns Json back into an object.  
  factory Munch.fromJson( String source) 
  => Munch.fromMap( json.decode(source) );
  
}

