//
//  CoreDataHelp.swift
//  PokemonGoClone
//
//  Created by Axel Vencatareddy on 16/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
  
  createPokemon(name: "MEW".localized, imageName: "mew")
  createPokemon(name: "MEOWTH".localized, imageName: "meowth")
  createPokemon(name: "ABRA".localized, imageName: "abra")
  createPokemon(name: "BELLSPROUT".localized, imageName: "bellsprout")
  createPokemon(name: "BULLBASAUR".localized, imageName: "bullbasaur")
  createPokemon(name: "CHARMANDER".localized, imageName: "charmander")
  createPokemon(name: "DRATINI".localized, imageName: "dratini")
  createPokemon(name: "EEVEE".localized, imageName: "eevee")
  createPokemon(name: "JIGGLYPUFF".localized, imageName: "jigglypuff")
  createPokemon(name: "MANKEY".localized, imageName: "mankey")
  createPokemon(name: "PIDGEY".localized, imageName: "pidgey")
  createPokemon(name: "PIKACHU".localized, imageName: "pikachu")
  createPokemon(name: "PSYDUCK".localized, imageName: "psyduck")
  createPokemon(name: "RATTATA".localized, imageName: "rattata")
  createPokemon(name: "SNORLAX".localized, imageName: "snorlax")
  createPokemon(name: "SQUIRTLE".localized, imageName: "squirtle")
  createPokemon(name: "VENONAT".localized, imageName: "venonat")
  createPokemon(name: "WEEDLE".localized, imageName: "weedle")
  createPokemon(name: "ZUBAT".localized, imageName: "zubat")
  
  (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createPokemon(name: String, imageName: String) {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  let pokemon = Pokemon(context: context)
  pokemon.name = name
  pokemon.imageName = imageName
}

func getAllPokemon() -> [Pokemon] {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  do {
    let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
    
    if pokemons.count == 0 {
      addAllPokemon()
      return getAllPokemon()
    }
    
    return pokemons
  } catch {}
  
  return []
}

func getAllCaughtPokemons() -> [Pokemon] {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
  
  fetchRequest.predicate = NSPredicate(format: "caught == %@", true as CVarArg)
  
  do {
    let pokemons = try context.fetch(fetchRequest)
    
    return pokemons
  } catch {}
  
  return []
}

func getAllUncaughtPokemons() -> [Pokemon] {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
  
  fetchRequest.predicate = NSPredicate(format: "caught == %@", false as CVarArg)
  
  do {
    let pokemons = try context.fetch(fetchRequest)
    
    return pokemons
  } catch {}
  
  return []
}

extension String {
  var localized: String {
    return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
  }
}
