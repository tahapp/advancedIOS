//
//  ViewController.swift
//  Cassini
//
//  Created by Taha Saleh on 8/29/23.
//

import UIKit

class ViewController: UIViewController
{

    let Cassini = UIButton()
    let Earth = UIButton()
    let Saturn = UIButton()
    
    private struct Identifiers
    {
        static let Cassini = "Cassini"
        static let Earth = "Earth"
        static let Saturn = "Saturn"
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Cassini.translatesAutoresizingMaskIntoConstraints = false
        Earth.translatesAutoresizingMaskIntoConstraints = false
        Saturn.translatesAutoresizingMaskIntoConstraints = false
        
        Cassini.setTitle("Cassini", for: .normal)
        Earth.setTitle("Earth", for: .normal)
        Saturn.setTitle("Saturn", for: .normal)
        
        Cassini.titleLabel?.font = .systemFont(ofSize: 30)
        Earth.titleLabel?.font = .systemFont(ofSize: 30)
        Saturn.titleLabel?.font = .systemFont(ofSize: 30)
        
        Cassini.setTitleColor(.black, for: .normal)
        Earth.setTitleColor(.black, for: .normal)
        Saturn.setTitleColor(.black, for: .normal)
        
        Cassini.layer.borderWidth = 1
        Earth.layer.borderWidth = 1
        Saturn.layer.borderWidth = 1
        
        Cassini.addTarget(self, action: #selector(segue1), for: .touchUpInside)
        Earth.addTarget(self, action: #selector(segue2), for: .touchUpInside)
        Saturn.addTarget(self, action: #selector(segue2), for: .touchUpInside)
        
        view.addSubview(Cassini)
        view.addSubview(Earth)
        view.addSubview(Saturn)
        
        NSLayoutConstraint.activate([
            
            Earth.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            Earth.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            Earth.widthAnchor.constraint(equalTo: Cassini.widthAnchor),
            
            Cassini.bottomAnchor.constraint(equalTo: Earth.topAnchor,constant: -10),
            Cassini.leadingAnchor.constraint(equalTo: Earth.leadingAnchor),
            Cassini.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            
            Saturn.topAnchor.constraint(equalTo: Earth.bottomAnchor,constant: 10),
            Saturn.leadingAnchor.constraint(equalTo: Earth.leadingAnchor),
            Saturn.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            Saturn.widthAnchor.constraint(equalTo: Cassini.widthAnchor),
        ])
    }
    @objc func segue1()
    {
        performSegue(withIdentifier: Identifiers.Cassini, sender: self)
    }
    @objc func segue2()
    {
        performSegue(withIdentifier: Identifiers.Earth, sender: self)
    }
    @objc func segue3()
    {
        performSegue(withIdentifier: Identifiers.Saturn, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageViewController = segue.destination as? ImageViewController else{
            print("failed 1")
            return
        }
//        guard let imageViewController = navController.topViewController as? ImageViewController else {
//            print("failed2")
//            return
//
//        }
        
        switch segue.identifier
        {
        case Identifiers.Cassini:
            imageViewController.imageURL = DemoURL.Cassini
        case Identifiers.Earth:
            imageViewController.imageURL = DemoURL.Earth
        case Identifiers.Saturn:
            imageViewController.imageURL = DemoURL.Saturn
        default:
            break
        }
    }
}

