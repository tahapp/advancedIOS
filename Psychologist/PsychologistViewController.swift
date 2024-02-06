//
//  ViewController.swift
//  Psychologist
//
//  Created by ben hussain on 4/23/23.
//

import UIKit

final class PsychologistViewController: UIViewController
{
    var question = UILabel()
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "Psychologist"
        question.translatesAutoresizingMaskIntoConstraints  = false
        question.text = "What do you see in your dreams?"
        question.font = .systemFont(ofSize: 25)
        question.textColor = .black
        question.backgroundColor = .red
        question.adjustsFontSizeToFitWidth  = true
    
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        
        button1.setTitle("Dancing Tree", for: .normal)
        button2.setTitle("Golden Bear", for: .normal)
        button3.setTitle("Buckeye", for: .normal)
        
        button1.setTitleColor(.black, for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button3.setTitleColor(.black, for: .normal)
        
        button1.titleLabel?.font = .systemFont(ofSize: 35)
        button2.titleLabel?.font = .systemFont(ofSize: 35)
        button3.titleLabel?.font = .systemFont(ofSize: 35)
        
        button1.addTarget(self, action: #selector(segue1), for: .touchUpInside)
        button2.addTarget(self, action: #selector(segue2), for: .touchUpInside)
        button3.addTarget(self, action: #selector(segue3), for: .touchUpInside)

        
        view.addSubview(question)
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        NSLayoutConstraint.activate([
            question.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 20),
            question.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            question.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button1.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -100),
            
            
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 20),
            button2.leadingAnchor.constraint(equalTo: button1.leadingAnchor),
            
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
            button3.leadingAnchor.constraint(equalTo: button1.leadingAnchor),
        ])
    }
    @objc func segue1()
    {
        self.performSegue(withIdentifier: "happy", sender: self)
    }
    @objc func segue2()
    {
        self.performSegue(withIdentifier: "normal", sender: self)
    }
    @objc func segue3()
    {
        self.performSegue(withIdentifier: "sad", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationViewController = segue.destination as? UINavigationController ,
        let happinessViewController = navigationViewController.topViewController as? HappinessViewController else{return}
        switch segue.identifier
        {
        case "happy":
            happinessViewController.happiness = 80
        case "normal":
            happinessViewController.happiness = 40
        case "sad":
            happinessViewController.happiness = 5
        default:
            break
        }
    }
}

