//
//  CoreDataHelp.swift
//  PokemonGoClone
//
//  Created by Axel Vencatareddy on 16/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import CoreData

func createPokemon() {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  let pokemon = Pokemon(context: context)
}
