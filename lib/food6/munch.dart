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
  { print("----- Munch.toMap: starting for $what");
    Map<String,dynamic> theMap = {};
    theMap['what'] = what;
    theMap['when'] = when;
    return theMap;
  }

  factory Munch.fromMap( Map<String,dynamic> theMap )
  { print("----- Munch.fromMap: starting for ${theMap['what']}");
    String what = theMap['what'];
    String when = theMap['when'];
    return Munch(what,when);
  }

  // Following, I have 2 version (each) of toJson and fromJson.
  // The software works with both, which makes me think that 
  // NEITHER of them is getting called in this version.

  // do it as just to MAP
  Map<String,dynamic> toJson()
  { print("----- Munch.toJson: starting on $what");
    return toMap();
  }

  /*
  // turns the object into JSON.  Does this by 
  // call toMap and then encode() ing the map.
  String toJson()
  { String s = json.encode(toMap());
    print("----- Munch encoded as $s");
    return s;
  }
  */

  // do it as just from MAP
  factory Munch.fromJson( Map<String,dynamic> map )
  { print("----- Munch.fromJson: starting with ${map['what']}");
    return Munch.fromMap(map);
  }

  /*
  // turns Json back into an object.  
  factory Munch.fromJson( String source) 
  => Munch.fromMap( json.decode(source) );
  */
}

