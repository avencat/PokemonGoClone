//
//  ViewController.swift
//  PokemonGoClone
//
//  Created by Axel Vencatareddy on 14/10/2016.
//  Copyright © 2016 Axel Vencatareddy. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  
  var updateCount = 0
  
  var manager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    manager.delegate = self
    
    if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
      manager.requestWhenInUseAuthorization()
    }
    
    mapView.showsUserLocation = true
    manager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if updateCount < 3 {
      if let coord = manager.location?.coordinate {
        let region = MKCoordinateRegionMakeWithDistance(coord, 400, 400)
        
        mapView.setRegion(region, animated: false)
      }
      updateCount += 1
    } else {
      manager.stopUpdatingLocation()
    }
    
  }
  
  @IBAction func centerTapped(_ sender: AnyObject) {
    
    if let coord = manager.location?.coordinate {
      let region = MKCoordinateRegionMakeWithDistance(coord, 400, 400)
      
      mapView.setRegion(region, animated: true)
    }
  }
  
}

