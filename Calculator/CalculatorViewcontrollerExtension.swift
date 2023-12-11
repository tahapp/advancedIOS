//
//  CalculatorViewcontrollerExtension.swift
//  Calculator
//
//  Created by ben hussain on 11/29/23.
//

import UIKit

extension CalculatorViewController
{
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50),
            displayLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            displayLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            displayLabel.heightAnchor.constraint(equalToConstant: 100),
            
            buttonsContainer.topAnchor.constraint(lessThanOrEqualTo: displayLabel.bottomAnchor,constant: 5),
            buttonsContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            buttonsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            
        ])
    } 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //print(autoLayoutButtonsContainerSize)
        //this is new i learned. here where the size is measured not in will
        buttonsContainer.parentSize = autoLayoutButtonsContainerSize
        if firstTime
        {
            setTargets()
            firstTime = false
        }
    }
    
    func setTargets()
    {
        
//        buttonsContainer.buttons.forEach { button in

        for button in buttonsContainer.buttons
        {
                
            
            if let title = button.currentTitle
            {
                
                if ["1","2","3","4","5","6","7","8","9","0"].contains(title)
                {
                   
                    button.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
                }
                else if ["+","-","*","/","sin","cos","tan","√"].contains(title)
                {
                    
                    button.addTarget(self, action: #selector(operation(_:)), for: .touchUpInside)
                }
                else if title == ButtonSymbols.enter
                {
                    
                    button.addTarget(self, action: #selector(enter(_:)), for: .touchUpInside)
                }
                else if title == ButtonSymbols.backspace
                {
                    
                    button.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
                }else if title == "restore"
                {
                    button.addTarget(self, action: #selector(restore), for: .touchUpInside)
                }else if title == "save"
                {
                    button.addTarget(self, action: #selector(save), for: .touchUpInside)
                }else
                {
                    continue
                }
            }
            
        }
        
    }
}
