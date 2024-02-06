//
//  DaignosedHappinessViewController.swift
//  Psychologist
//
//  Created by ben hussain on 6/1/23.
//

import UIKit

final class DaignosedHappinessViewController: HappinessViewController, UIPopoverPresentationControllerDelegate
{
    
    
     var diagnoses = [Int]()
    private struct History // write this pattern in your notes
    {
        static var identifer = "daignostic"
        static var key = "DiagnosedHistoryViewController"
    }
    
    let userDefault = UserDefaults.standard
    
    var diagnosesHistory: [Int] // write this snippet in your notebook
    {
        get
        {
            return userDefault.object(forKey: History.key) as? [Int] ?? []
            
            
            
        }
        set
        {
            // newvalue = [newValue]
            userDefault.set(newValue, forKey: History.key)
            print(diagnosesHistory.count)
            //userDefault.removeObject(forKey: History.key)
           
        }
    }
    
    
    override var happiness: Int
    {
        didSet
        {
            
            //diagnoses += [happiness]
            // 6. because when we use segue, we always create a new MVC, so when we click any segue buttom from
            // psychologistVC Happines and Diagnosed VC are created new, so fro example,
            // we will be creating new DiagnosedVC for every time we press segue buttoms
            // that's why diagnoses.count will always be one because we destroy old one and ceate a new
            //one.
            //solution is to use UserDefaults with computed property and delete the array
            diagnosesHistory += [happiness]
        }
    }
    override func viewDidLoad() {
        
    }
    // 5.you don't do performsegue like in PsychologistVC because it's implemented in StoryBoard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else{
            
            return
            
        }
        switch identifier
        {
            
            case History.identifer:
            
                if let textVC = segue.destination as? TextViewController
                {
                    if let popover = textVC.popoverPresentationController
                    {
                        popover.delegate = self
                    }
                    textVC.text = "\(diagnosesHistory.map({String($0)}).joined(separator: ",")  )"
                    
                }
                
            default:
            
                break
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // this means in iphone context only, don't present modally rather present from the sender
        .none
    }
}
