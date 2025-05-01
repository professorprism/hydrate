// munch.dart
// Barrett Koster 2025
// This is for ONE item, something you ate
// and when you ate it, presumably.

// import "package:flutter/material.dart";

import 'dart:convert';

class Munch 
{
  String what;

  String when;
  // int when;
  // DateTime when;

  Munch( this.what, this.when );
  // Munch( this.what, String whenString )
  // : when = DateTime.parse(whenString);

  Map<String,dynamic> toMap()
  { Map<String,dynamic> theMap = {};
    theMap['what'] = what;
    theMap['when'] = when;
    return theMap;
  }

  factory Munch.fromMap( Map<String,dynamic> theMap )
  {
    String what = theMap['what'];
    String when = theMap['when'];
    return Munch(what,when);
  }


  // turns the object into JSON.  Does this by 
  // call toMap and then encode() ing the map.
  String toJson()
  { String s = json.encode(toMap());
    print("----- Munch encoded as $s");
    return s;
  }

  // turns Json back into an object.  
  factory Munch.fromJson( String source) 
  => Munch.fromMap( json.decode(source) );
  
}

