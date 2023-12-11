//
//  ViewController.swift
//  Calculator9
//
//  Created by ben hussain on 11/29/23.
//

import UIKit

final class CalculatorViewController: UIViewController
{
    static var test = 0
    var displayLabel = UILabel()
    var buttonsContainer = ButtonsView(frame: .zero)
    //var buttonsView = ButtonsView(frame: .zero)
    var autoLayoutButtonsContainerSize:CGSize
    {
        return buttonsContainer.frame.size
    }
    var displayValue: Double?
    {
        get
        {
            let formatter = NumberFormatter()
           
            if let value = formatter.number(from: displayLabel.text!)?.doubleValue
            {
                return value
            }
            else
            {
                return nil
            }
        }
        set
        {
            let formatter2 = NumberFormatter()
            formatter2.usesSignificantDigits = true
            formatter2.maximumFractionDigits = 3
            let rounded = formatter2.string(for: newValue)
            displayLabel.text = rounded
        
        }
    }
    
    var firstTime = true
    var userDidType = false
    var isResultReady = false
    var brain = CalculatorBrain()
    
    var savedProgram: CalculatorBrain.propertyList?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.text = "0"
        displayLabel.layer.borderWidth = 1
        displayLabel.numberOfLines = 0
        displayLabel.autoresizingMask = .flexibleHeight
        displayLabel.textAlignment = .right
        displayLabel.font = .systemFont(ofSize: 70)
        displayLabel.adjustsFontSizeToFitWidth = true
        
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.layer.borderWidth = 1
      
        view.addSubview(displayLabel)
        view.addSubview(buttonsContainer)
        //buttonsContainer.addSubview(buttonsView)
        
    }
    @objc func save()
    {
        
        savedProgram = brain.program
    }
    @objc func restore()
    {
        
        if savedProgram != nil
        {
            
            brain.program = savedProgram!
            displayValue = brain.accumulator
        }
        
    }
    @objc func numberPressed(_ button: UIButton)
    {
        
        if let digit = button.currentTitle
        {
            if userDidType
            {
                displayLabel.text! += digit
                
                //operands.append(displayValue) this would display one digit we can't type 45 , 23.
            }else
            {
                displayLabel.text = digit
               // operands.append(displayValue) this would display one digit we can't type 45 , 23.
                userDidType = true
            }
            
        }else
        {
            displayValue = 0.00
        }
        
        
    }
    @objc func enter(_ button: UIButton)
    {
        operation(button)
    }
    @objc func goBack(_ button:UIButton)
    {
        
        if displayLabel.text != nil
        {
            if !displayLabel.text!.isEmpty
            {
                if !isResultReady
                {
                    displayLabel.text!.removeLast()
                }
                else
                {
                    
                    displayLabel.text?.removeAll(keepingCapacity: true)
                }
            }
        }
    }
    @objc func operation(_ button:UIButton)
    {
        if let operation = button.currentTitle
        {
            
            if userDidType
            {
               
                if let value = displayValue
                {
                    brain.appendDigit(value)
                }
                
//                displayLabel.text! += operation
//             because operators can not coverted to doubles in displayValue
            }
            
            displayLabel.text = operation //optional
            userDidType = false
            brain.performOperation(operation)
            displayValue = brain.accumulator
            isResultReady = true
            
        }
    }
    func expensive()
    {
        
    }
}
