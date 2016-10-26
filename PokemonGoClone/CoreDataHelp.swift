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
  
  createPokemon(name: "Mew", imageName: "mew")
  createPokemon(name: "Miaouss", imageName: "meowth")
  createPokemon(name: "Abra", imageName: "abra")
  createPokemon(name: "Poustiflor", imageName: "bellsprout")
  createPokemon(name: "Bulbizarre", imageName: "bullbasaur")
  createPokemon(name: "Salamèche", imageName: "charmander")
  createPokemon(name: "Minidraco", imageName: "dratini")
  createPokemon(name: "Évoli", imageName: "eevee")
  createPokemon(name: "Rondoudou", imageName: "jigglypuff")
  createPokemon(name: "Férosinge", imageName: "mankey")
  createPokemon(name: "Piafabec", imageName: "pidgey")
  createPokemon(name: "Pikachu", imageName: "pikachu-2")
  createPokemon(name: "Psykokwak", imageName: "psyduck")
  createPokemon(name: "Rattata", imageName: "rattata")
  createPokemon(name: "Ronflex", imageName: "snorlax")
  createPokemon(name: "Carapuce", imageName: "squirtle")
  createPokemon(name: "Mimitoss", imageName: "venonat")
  createPokemon(name: "Aspicot", imageName: "weedle")
  createPokemon(name: "Nosferapti", imageName: "zubat")
  
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
