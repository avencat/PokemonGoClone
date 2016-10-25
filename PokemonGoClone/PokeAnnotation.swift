//
//  PokeAnnotation.swift
//  PokemonGoClone
//
//  Created by Axel Vencatareddy on 25/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var pokemon: Pokemon
  
  init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
    self.coordinate = coord
    self.pokemon = pokemon
  }
}
