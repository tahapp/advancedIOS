//
//  ViewController.swift
//  AutoLayout
//
//  Created by ben hussain on 7/4/23.
//

import UIKit

class ViewController: UIViewController
{
    let verticalSpacing :CGFloat = 10
    let horizontalSpacing:CGFloat = 5
    
    let userNameLabel = UILabel()
    let passwordLabel = UILabel()
    
    let userNameField = UITextField()
    let passwordField = UITextField()
    
    let changeSecurity = UIButton()
    let login = UIButton()
    
    let leftSpacing = UILayoutGuide()
    let rightSpacing = UILayoutGuide()
    
  
    let imageView = UIImageView()
    var secure = false
    {
        didSet
        {
            updateUI()
        }
    }
    let isActivated = false
    var logginUser : User? // this is the model
    {
        didSet
        {
            updateUI()
        }
    }
    let UName = UILabel()
    let UCompany = UILabel()
    
    var aspectRatioConstraint: NSLayoutConstraint?
    {
        willSet
        {
            if let oldConstraint = aspectRatioConstraint
            {
                view.removeConstraint(oldConstraint)
            }
        }
        didSet
        {
            if let newConstraint = aspectRatioConstraint
            {
                //newConstraint.priority = .defaultLow // this was the solution to the fact that the image was pushing everything upweard.
                view.addConstraint(newConstraint)
            }

        }
    }

    var image : UIImage?
    {
        get{
            return imageView.image
        }set{

            imageView.image = newValue
         
                if let newImage = newValue{
                    aspectRatioConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView,
                                                               attribute: .height, multiplier: newImage.ratio, constant: 0)
                    

                }else{
                    aspectRatioConstraint = nil
                }

        }
    }
    
    var HConstraints =  [NSLayoutConstraint]()
    var VConsteraints = [NSLayoutConstraint]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userNameLabel.text = "username"
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        passwordLabel.text = "password"
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal) // solution to label extending.
        
        
        userNameField.placeholder = "username"
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.borderStyle = .line
        userNameField.autocapitalizationType = .none
        userNameField.autocorrectionType = .no
        
        
        passwordField.placeholder = "password"
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.borderStyle = .line
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        
        
        
        
        changeSecurity.setTitle("change security", for: .normal)
        changeSecurity.setTitleColor(.black, for: .normal)
        changeSecurity.translatesAutoresizingMaskIntoConstraints = false
        changeSecurity.addTarget(self, action: #selector(HashPassword), for: .touchUpInside)
        
        login.setTitle("login", for: .normal)
        login.setTitleColor(.black, for: .normal)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.addTarget(self, action: #selector(userLogin), for: .touchUpInside)
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical) // step 3 be able to squish
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical) // be able to stretch
        imageView.contentMode = .scaleAspectFit
        
        
        
        UName.translatesAutoresizingMaskIntoConstraints = false
        UName.setContentCompressionResistancePriority(.required, for: .horizontal) // because of the constrinats step 2
        UCompany.translatesAutoresizingMaskIntoConstraints = false
        UCompany.setContentCompressionResistancePriority(.required, for: .horizontal) // step 1
        
      
        view.addSubviews(userNameLabel,passwordLabel,userNameField,passwordField,changeSecurity,
                         login,imageView, UName, UCompany)
        view.addLayoutGuide(leftSpacing)
        view.addLayoutGuide(rightSpacing)
        
        initializeConstraints()
        updateUI()
       
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        pickConstraints(basedOn: previousTraitCollection)
    }
    private  func updateUI()
    {
        passwordField.isSecureTextEntry = secure
        passwordLabel.text = secure ? "secure password" : "Password"
        UName.text = logginUser?.name
        UCompany.text = logginUser?.company
        image = logginUser?.image
       /* even though secure will gets this called at the begining , none of this code will show any
          results because they will return nil, another way is using if-else.
        */
        
    }
    @objc func HashPassword()
    {
        secure.toggle()
        //passwordLabel.sizeToFit()
        
        
    }
    @objc func userLogin()
    {
        logginUser = User.login(login: userNameField.text ?? "", password: passwordField.text ?? "")
        if logginUser == nil
        {
            let ac = UIAlertController(title: "not found", message: "user name could not be found ", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac,animated: true)
        }
        view.endEditing(true) // new
        //resignFirstResponder needs delegate.
    }
    override var additionalSafeAreaInsets: UIEdgeInsets
    {
        set
        {
            super.additionalSafeAreaInsets = newValue
        }
        get{
            return .init(top: 10, left: 0, bottom: 0, right: 0)
        }
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

// right to left and bottom to  top  is greater than
// left to right and top to bottom is less than

