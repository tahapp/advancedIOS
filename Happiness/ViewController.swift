//
//  ViewController.swift
//  Happiness
//
//  Created by ben hussain on 4/17/23.
//

import UIKit

class ViewController: UIViewController,FaceViewDataSource
{
    var faceView  = FaceView()

    var happiness : Int = 50
    {
        didSet
        {
            
            happiness = max( min(happiness,100),-100)
                       
           
            updateUI()
        }
    }
    override func loadView() {
        view = faceView
        faceView.backgroundColor = .systemBackground
        faceView.dataSource = self
        let pinchGesture = UIPinchGestureRecognizer(target: faceView, action: #selector(faceView.scaleSize(_:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
    
        faceView.addGestureRecognizer(panGesture)
        faceView.addGestureRecognizer(pinchGesture)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(pinch(_:) ))
        
        faceView.addGestureRecognizer(tap)
    }
    func updateUI()
    {
        faceView.setNeedsDisplay()
    }
    func adjustSmilness(_ faceView: FaceView) -> Double? {
        
        return Double(happiness - 50) / 50
    }
    @objc func pinch(_ gesture: UIPinchGestureRecognizer)
    {
       
    }
    
    @objc func pan(_ gesture:UIPanGestureRecognizer)
    {
        switch gesture.state
        {
        case .ended:
            print("______________________")
            fallthrough
        case .changed:
            let translation = gesture.translation(in: faceView)
            let happinessChange = Int(translation.y)
            
            if happinessChange != 0
            {
                happiness += happinessChange
                gesture.setTranslation(.zero, in: faceView)
            }
        default:
            break
        }
    }
    
}


/*
 there are two ways to handle a gesture:
 1. either by the view. view.addGestureRecognizer(..), this is usually done by the controller
 2. provide a method that would handle the gesture
 */
