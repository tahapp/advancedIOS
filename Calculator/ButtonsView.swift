//
//  ButtonsView.swift
//  Calculator
//
//  Created by ben hussain on 11/29/23.
//

import UIKit

final class ButtonsView: UIView {
    private var firstTime : Bool = true
   
    var parentSize : CGSize?
    {
//        willSet
//        {
//            subviews.forEach({
//                $0.removeFromSuperview()
//            })
//            buttons.removeAll(keepingCapacity: true)
//        }
        //this wasd the issue, they were getting deleted so the target and action is deleted with them. 
        didSet
        {
            
            configure()
        }
    }
    var buttons = [UIButton]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
 
    func configure()
    {
        guard let size = parentSize else{return}
        let width: CGFloat = size.width/5
        let height:CGFloat = size.height/5
        let buttonsLabels = ["7","8","9","+","sin","4","5","6","-","cos","1","2","3","*","tan","⌫","→","0","√","/","save","restore","empty","empty","empty"]
        
        if firstTime
        {
            var index = 0
            for row in 0...4
            {
                for col in 0...4
                {
                    let button = UIButton(frame: .init(x: CGFloat(col) * width, y: CGFloat(row) * height, width: width, height: height))
                    button.setTitle(buttonsLabels[index], for: .normal)
                    button.titleLabel?.adjustsFontSizeToFitWidth = true // Adjust text size to fit button width
                    button.titleLabel?.minimumScaleFactor = 0.5 // Customize the minimum scale factor as needed
                    button.titleLabel?.lineBreakMode = .byClipping
                    button.layer.cornerRadius = 10
                    button.layer.borderWidth = 1
                    index += 1
                    button.setTitleColor(.black, for: .normal)
                    button.titleLabel?.font = .systemFont(ofSize: 30)
                    buttons.append(button)
                    addSubview(button)
                }
            }
            firstTime = false
        }
        else
        {
            
            
            //the mistake was for b in buttons loop by itself and nested by for row and for col loop
            var index = 0
            for row in 0...4
            {
                for col in 0...4
                {
                    buttons[index].frame = .init(x: CGFloat(col) * width, y: CGFloat(row) * height, width: width, height: height)
                    index += 1
                }
            }
        }
    }
}

struct ButtonSymbols
{
    static let sqaure = "√"
    static let backspace = "⌫"
    static let enter = "→"
}

