//
//  ViewController.swift
//  Localization
//
//  Created by ben hussain on 11/25/23.
//

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
    
    lazy var dateLabel :  UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "11/25/2023 8:55 PM"
        
        return l
    }()
    
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
        
        userNameLabel.text = Translations.username
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        passwordLabel.text = Translations.password
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal) // solution to label extending.
        
        
        userNameField.placeholder = Translations.username
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.borderStyle = .line
        userNameField.autocapitalizationType = .none
        userNameField.autocorrectionType = .no
        
        
        passwordField.placeholder = Translations.password
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.borderStyle = .line
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        
        
        
        
        changeSecurity.setTitle(Translations.changeSecurity, for: .normal)
        changeSecurity.setTitleColor(.black, for: .normal)
        changeSecurity.translatesAutoresizingMaskIntoConstraints = false
        changeSecurity.addTarget(self, action: #selector(HashPassword), for: .touchUpInside)
        
        login.setTitle(Translations.login, for: .normal)
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
                         login,imageView, UName, UCompany,dateLabel)
        view.addLayoutGuide(leftSpacing)
        view.addLayoutGuide(rightSpacing)
        
        initializeConstraints()
        updateUI()
       
    }
  
    
    private  func updateUI()
    {
        passwordField.isSecureTextEntry = secure
        passwordLabel.text = secure ? Translations.securePassword : Translations.password
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
            let ac = UIAlertController(title: Translations.alertControllerTitle, message: Translations.alertControllerMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: Translations.alertActiontitle, style: .default))
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
   
   
}

// right to left and bottom to  top  is greater than
// left to right and top to bottom is less than



/*

 
 */
