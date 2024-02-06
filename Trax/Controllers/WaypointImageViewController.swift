//
//  WaypointImageViewController.swift
//  Trax
//
//  Created by ben hussain on 11/12/23.
//

import UIKit

class WaypointImageViewController: ImageViewController
{
    var wayPoint : WayPoint?{
        didSet
        {
            imageURL = wayPoint?.largeURL
            title = wayPoint?.name
            updateEmbededMap()
        }
    }
    let smvc = SimpleMapViewController()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addChild(smvc)
        view.addSubview(smvc.view)
        
        let mapView = smvc.mapView
        mapView.mapType = .hybrid
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(wayPoint!)
        mapView.showAnnotations(mapView.annotations, animated: true)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            smvc.view.widthAnchor.constraint(equalToConstant: 270),
            smvc.view.heightAnchor.constraint(equalToConstant: 200),
            smvc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            smvc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        smvc.didMove(toParent: self)
       
    }
 
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Constants.embededSegue
//        {
//            smvc = segue.destination as? SimpleMapViewController
//            updateEmbededMap()
//            
//        }
//    }
//    
    
    func updateEmbededMap()
    {
        
//        if let simpleMapVC = smvc
//        {
//            if let  mapView = simpleMapVC.mapView{
//                
//                print(mapView === simpleMapVC.mapView)
//                mapView.mapType = .hybrid
//                mapView.removeAnnotations(mapView.annotations)
//                mapView.addAnnotation(wayPoint!)
//                mapView.showAnnotations(mapView.annotations, animated: true)
//            }
//        }
        
    }
}
