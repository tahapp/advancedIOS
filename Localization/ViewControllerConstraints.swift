//
//  ViewControllerConstraints.swift
//  Localization
//
//  Created by ben hussain on 11/25/23.
//

import Foundation
import UIKit

extension ViewController
{
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) 
    {
         super.traitCollectionDidChange(previousTraitCollection)
         pickConstraints(basedOn: previousTraitCollection)
    }
    
    func pickConstraints(basedOn traitCollection : UITraitCollection?)
    {
        if traitCollection?.verticalSizeClass == .regular && traitCollection?.horizontalSizeClass == .compact
        {
           
            NSLayoutConstraint.deactivate(HConstraints)
            NSLayoutConstraint.activate(VConsteraints)
        }else
        {
           
            NSLayoutConstraint.deactivate(VConsteraints)
            NSLayoutConstraint.activate(HConstraints)
        }
    }
    override func viewWillLayoutSubviews() {
        
        if !isActivated
        {
            
            NSLayoutConstraint.activate([
                
                userNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0),
                userNameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -horizontalSpacing),
                
                passwordField.topAnchor.constraint(equalTo: userNameField.bottomAnchor,constant: verticalSpacing),
                passwordField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant: -horizontalSpacing),
                
                /*1.since passwrd and username must align with their respoective field is better to use baseline*/
                //1.userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 0),
                userNameLabel.firstBaselineAnchor.constraint(equalTo: userNameField.firstBaselineAnchor),
                userNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: horizontalSpacing),
                
                
                //1.passwordLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,constant: 10),
                passwordLabel.firstBaselineAnchor.constraint(equalTo: passwordField.firstBaselineAnchor),
                passwordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: horizontalSpacing),
                
                /*2. make password and username the same width, this can be explained in (3)*/
                passwordLabel.widthAnchor.constraint(equalTo: userNameLabel.widthAnchor, multiplier: 1),
                
                
                /*3. horizontal spacing is aligning v12.leading to v2.trailing and vice versa with vertical spacing.
                 however doing this will make fields attached to the labels, and that's not what we want, we want to fields to extend from
                 the right all way close to the labels.
                 userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: userNameField.leadingAnchor)
                 "this will place the field at the edge and increase its size as the user types until it reaches its maximum size"
                 passwordLabel.trailingAnchor.constraint(equalTo: passwordField.leadingAnchor)
                 this will extend our field to its maximum size but it will leave no distance from its label, so solution is add some space
                 */
                
                userNameLabel.trailingAnchor.constraint(equalTo: userNameField.leadingAnchor,constant: -horizontalSpacing),
                passwordLabel.trailingAnchor.constraint(equalTo: passwordField.leadingAnchor,constant: -horizontalSpacing),
                
//                userNameField.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor,constant: horizontalSpacing),
//                passwordField.leadingAnchor.constraint(equalTo: passwordLabel.trailingAnchor,constant: horizontalSpacing),
//
//
               /* 4. i wanten centerd and some distance apart, i would use centerXAnchor with some constant. but we will use something
                better, we will create two UILayoutGuide and put them on each edge so the buttons can be pushed into the middle */
                //these just the vertical position only
                login.topAnchor.constraint(equalTo: passwordField.bottomAnchor,constant: verticalSpacing),
                login.firstBaselineAnchor.constraint(equalTo: changeSecurity.firstBaselineAnchor),
                /* this below solves the problem that the buttons were not gettin close to each other when flippin
                 it means always keep 50 of horizonal space. */
                login.leadingAnchor.constraint(equalTo: changeSecurity.trailingAnchor,constant: 50), // note x
               
                
                leftSpacing.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                leftSpacing.topAnchor.constraint(equalTo: changeSecurity.topAnchor),
                leftSpacing.bottomAnchor.constraint(equalTo: changeSecurity.bottomAnchor),
                leftSpacing.trailingAnchor.constraint(equalTo: changeSecurity.leadingAnchor),
                /* (3) this below means that leftspacin minimum width is 60 but you can increase to fit your need
                 this was connected to label width and when flipped, the note x (4) would enforce the distance to be
                 50, thus strecthing the leftspacing and the password with it. but this constriant separate the
                 password width from */
                leftSpacing.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
                
                rightSpacing.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                rightSpacing.topAnchor.constraint(equalTo: login.topAnchor),
                rightSpacing.bottomAnchor.constraint(equalTo: login.bottomAnchor),
                rightSpacing.leadingAnchor.constraint(equalTo: login.trailingAnchor),
                rightSpacing.widthAnchor.constraint(equalTo: leftSpacing.widthAnchor)
                
            ])
            
            if traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .compact
            {
               
                NSLayoutConstraint.deactivate(HConstraints)
                NSLayoutConstraint.activate(VConsteraints)
            }else
            {
               
                NSLayoutConstraint.deactivate(VConsteraints)
                NSLayoutConstraint.activate(HConstraints)
            }
        }
    }
    
    func initializeConstraints()
    {
        HConstraints = [
            
            
            imageView.topAnchor.constraint(greaterThanOrEqualTo: login.bottomAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
            
            UName.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
            UName.bottomAnchor.constraint(equalTo: imageView.centerYAnchor),
            UName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            UCompany.leadingAnchor.constraint(equalTo: UName.leadingAnchor),
            UCompany.topAnchor.constraint(equalTo: UName.bottomAnchor,constant: verticalSpacing),
            UCompany.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

        ]
        
        VConsteraints = [
         
            
            imageView.topAnchor.constraint(greaterThanOrEqualTo: login.bottomAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: UName.topAnchor,constant: 5),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            
            UName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            UName.bottomAnchor.constraint(equalTo: UCompany.topAnchor,constant: 5),
            UName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            UCompany.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            UCompany.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            UCompany.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

        ]
    }
}
