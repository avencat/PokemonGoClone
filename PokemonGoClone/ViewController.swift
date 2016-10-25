//
//  ViewController.swift
//  PokemonGoClone
//
//  Created by Axel Vencatareddy on 14/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  
  var updateCount = 0
  
  var manager = CLLocationManager()
  
  var pokemons : [Pokemon] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pokemons = getAllPokemon()
    
    manager.delegate = self
    
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
      mapView.delegate = self
      mapView.showsUserLocation = true
      manager.startUpdatingLocation()
      
      Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
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
    } else {
      manager.requestWhenInUseAuthorization()
    }
  }
  
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
  
  @IBAction func centerTapped(_ sender: AnyObject) {
    
    if let coord = manager.location?.coordinate {
      let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
      
      mapView.setRegion(region, animated: true)
    }
  }
  
}

