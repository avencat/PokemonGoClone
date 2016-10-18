//
//  PokedexViewController.swift
//  PokemonGoClone
//
//  Created by Axel Vencatareddy on 16/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  var pokemons: [Pokemon] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pokemons.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    
    cell.textLabel?.text = pokemons[indexPath.row].name
    
    return cell
  }
  
  @IBAction func mapTapped(_ sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }
  
}
