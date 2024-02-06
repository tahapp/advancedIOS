//
//  SimpleMapViewController.swift
//  Trax
//
//  Created by ben hussain on 11/12/23.
//

import UIKit
import MapKit

class SimpleMapViewController: UIViewController
{
    
    let mapView = MKMapView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        mapView.fourWayConstraints()
    }

    
}
