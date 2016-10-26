//
//  ViewController.swift
//  PokemonGoClone
//
//  Created by Axel Vencatareddy on 14/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var mapView: MKMapView!
  
  @IBOutlet weak var pokedexButton: UIButton!
  
  var updateCount = 0
  
  var manager = CLLocationManager()
  
  var pokemons : [Pokemon] = []
  
  let tableView: UITableView = UITableView()
  
  var caughtPokemons: [Pokemon] = []
  var uncaughtPokemons: [Pokemon] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.frame = CGRect(x: 40, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width - 80, height: UIScreen.main.bounds.size.height - 40)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.layer.cornerRadius = 15

    self.view.addSubview(tableView)
    
    pokemons = getAllPokemon()
    
    manager.delegate = self
    
    if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
      manager.requestWhenInUseAuthorization()
    }
    
    self.view.bringSubview(toFront: pokedexButton)
  }


  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      setUp()
    }
  }
  
  func setUp() {
    mapView.delegate = self
    mapView.showsUserLocation = true
    manager.startUpdatingLocation()
    
    Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { (timer) in
      // Spawn a pokemon
      if let coord = self.manager.location?.coordinate {
        
        let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
        
        let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
        
        anno.coordinate = coord
        anno.coordinate.latitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
        anno.coordinate.longitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
        self.mapView.addAnnotation(anno)
      }
    }
  }
  
  // When a pokemon appear on the map, change its image to the pokemon's image
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
    
    if annotation is MKUserLocation {
      annoView.image = UIImage(named: "player")
      
      var frame = annoView.frame
      
      frame.size.height = 50
      frame.size.width = 50
      
      annoView.frame = frame
    } else {
      let pokemon = (annotation as! PokeAnnotation).pokemon
      
      annoView.image = UIImage(named: pokemon.imageName!)
      
      var frame = annoView.frame
      
      frame.size.height = 50
      frame.size.width = 50
      
      annoView.frame = frame
    }
    return annoView
  }
  
  
  // When you select a pokemon on the map
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    mapView.deselectAnnotation(view.annotation!, animated: true)
    
    if view.annotation! is MKUserLocation {
      return
    } else {
      let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
      mapView.setRegion(region, animated: true)
      
      Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
        if let coord = self.manager.location?.coordinate {
          if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
            let pokemon = (view.annotation as! PokeAnnotation).pokemon
            pokemon.caught = true
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            mapView.removeAnnotation(view.annotation!)
            
            let alertVC = UIAlertController(title: "CONGRATS".localized, message: "CATCH".localized + pokemon.name! + "CATCH2".localized, preferredStyle: .alert)
            let pokedexAction = UIAlertAction(title: "POKEDEX".localized, style: .default, handler: { (action) in
              self.pokedexTapped(self.pokedexButton)
            })
            let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
            alertVC.addAction(pokedexAction)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
          } else {
            let alertVC = UIAlertController(title: "OOPS".localized, message: "NOTCAUGHT".localized + (view.annotation as! PokeAnnotation).pokemon.name! + "NOTCAUGHT2".localized, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
          }
        }
      })
    }
  }
  
  // Show the user location at the beggining of the application
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if updateCount < 3 {
      if let coord = manager.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        
        mapView.setRegion(region, animated: false)
      }
      updateCount += 1
    } else {
      manager.stopUpdatingLocation()
    }
    
  }
  
  // When the center to user location's button has been tapped
  @IBAction func centerTapped(_ sender: AnyObject) {
    
    if let coord = manager.location?.coordinate {
      let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
      
      mapView.setRegion(region, animated: true)
    }
  }
  
  // When the user wants to display the pokedex
  @IBAction func pokedexTapped(_ sender: AnyObject) {
    caughtPokemons = getAllCaughtPokemons()
    uncaughtPokemons = getAllUncaughtPokemons()
    tableView.reloadData()
    if tableView.frame.origin.y != 40 {
      UIView.animate(withDuration: 0.7, animations: {
        self.tableView.frame.origin.y = 40
        self.pokedexButton.setImage(UIImage(named: "map"), for: .normal)
      })
    } else {
      UIView.animate(withDuration: 0.7, animations: {
        self.tableView.frame.origin.y = UIScreen.main.bounds.height
        self.pokedexButton.setImage(UIImage(named: "pokeball"), for: .normal)
      })
    }
  }
  
  // Functions to manage the tableView Pokedex
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "CAUGHT".localized
    } else {
      return "UNCAUGHT".localized
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return caughtPokemons.count
    } else {
      return uncaughtPokemons.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    
    let pokemon: Pokemon
    if indexPath.section == 0 {
      pokemon = caughtPokemons[indexPath.row]
    } else {
      pokemon = uncaughtPokemons[indexPath.row]
    }
    
    cell.textLabel?.text = pokemon.name
    cell.imageView?.image = UIImage(named: pokemon.imageName!)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if section == 0 {
      return nil
    } else {
      let footerView = UIView()
      return footerView
    }
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section != 0 {
      return 80
    } else {
      return 0
    }
  }
  
}
