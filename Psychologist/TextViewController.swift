//
//  TextViewController.swift
//  Psychologist
//
//  Created by ben hussain on 6/1/23.
//

import UIKit

final class TextViewController: UIViewController {

    var textView = UITextView()
    {
        didSet
        {
            textView.text = ""
        }
    }
    // this is the model, like faceview color, linewidth
    var text:String = ""
    {
        didSet
        {
            
            textView.text = text
            
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 40)
        
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
  
    override var preferredContentSize: CGSize
    {
        get
        {
            if presentingViewController != nil
            {
            
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
              
            }else
            {
                
                return super.preferredContentSize
            }
        }
        set
        {
            super.preferredContentSize = newValue
        }
    }
}
