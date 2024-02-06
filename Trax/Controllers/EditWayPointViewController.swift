//
//  EditWayPointViewController.swift
//  Trax
//
//  Created by ben hussain on 11/6/23.
//

import UIKit

class EditWayPointViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    var wayPointToEdit: EditableWayPoint?
    {
        didSet
        {
            
            updateUI()
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    
    private var itfObserver: NSObjectProtocol?
    private var ntfObserver: NSObjectProtocol?
    /* we will use UIView to host a UIImageView because imageView has an intrinsic content size of the image
     so if i have a large image the image view will be large and adjusting the size will be hard. so when hosting
     a image view inside a UIView we can have a better control over the image size*/
    var imageView = UIImageView()
    
    @IBOutlet weak var containerView: UIView!
    {
        didSet
        {
            
            containerView.addSubview(imageView)
            containerView.layer.borderWidth = 1
            
         
        }
    }
    // MARK: - life cycles
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .clear
        nameTextField.delegate = self
        infoTextField.delegate = self
        
        nameTextField.becomeFirstResponder()
    
        updateUI()
        /* the methods that are called in property didSet must also be called in viewcontroller life cycle in
                    case they got called before.*/
       
        title = "edit wayPoints"
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(TaskDone))
        
     
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let center = NotificationCenter.default
        ntfObserver =  center.addObserver(forName: UITextField.textDidChangeNotification, object: nameTextField, queue: .main) { [weak self] notification in
            if let wayPoint = self?.wayPointToEdit
            {
                wayPoint.name = self?.nameTextField.text ?? "no text"
                
            }
        }
        
        itfObserver =  center.addObserver(forName: UITextField.textDidChangeNotification, object: infoTextField, queue: .main) { [weak self] notification in
            if let wayPoint = self?.wayPointToEdit
            {
                wayPoint.desc = self?.infoTextField.text ?? "no info"
            }
        }
    }
    
    // you must get rid of those observers, because even of the view is dismissed, they will still remain
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let center = NotificationCenter.default
        if let i = itfObserver , let n = ntfObserver
        {
            center.removeObserver(i)
            center.removeObserver(n)
        }
        
    }
    // MARK: - user defined
    @objc func TaskDone()
    {
        // that's how to make a connection between the presenter and the presented.
       
        presentingViewController?.dismiss(animated: true)
    }
    func updateUI()
    {
        
        nameTextField?.text = wayPointToEdit?.name
        infoTextField?.text = wayPointToEdit?.desc
        updateImage()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    
//    override func beginAppearanceTransition(_ isAppearing: Bool, animated: Bool) {
//        super.beginAppearanceTransition(isAppearing, animated: animated)
//      
//        
//    }
//    override func endAppearanceTransition() {
//      
//    }
    //search chatGPT for more detail
    
    
   
    
    // MARK: - image related
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            if let mediaKinds = UIImagePickerController.availableMediaTypes(for: .camera)
            {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [mediaKinds.first ?? "Public.image"]
                imagePicker.allowsEditing = true
                imagePicker.cameraDevice = .rear
                present(imagePicker,animated: true)
            }
        }
    }
    
    
    func updateImage()
    {
        
        if let url = wayPointToEdit?.largeURL
        {
            
            print("url = ",url.absoluteString)
            if url.absoluteString.hasPrefix("file://")
            {
               
                DispatchQueue.global(qos: .background).async {
                    do{
                         
                        let data = try Data(contentsOf: url) // it is recomeded for local url (file,images,videos)
                        let image = UIImage(data: data)
                            DispatchQueue.main.async { [weak self] in
                                self?.imageView.image = image
                                self?.makeRoomForImage()
                            }
                        
                    }catch
                    {
                        print(error.localizedDescription)
                        fatalError()
                    }
                }

            }
            else if url.absoluteString.hasPrefix("http://")
            {
                
                URLSession.shared.dataTask(with: .init(url: url)) { [weak self] data, response, error in // recomended for over the internet
                    if error != nil
                    {
                        print(error!)
                    }
                    if let data = data
                    {
                       
                        let image = UIImage(data: data)
                        DispatchQueue.main.async{
                            
                            self?.imageView.image = image
                            self?.makeRoomForImage()
                        }
                    }
                }.resume()
             }
               
          
        }
        
    }
    func makeRoomForImage()
    {
        //var extraHeight: CGFloat = 0
        guard let image = imageView.image else{return}
        if image.aspectRatio > 0
        {
            if let width = imageView.superview?.frame.size.width //view.size.width = 428
            {
                let height = width /  imageView.image!.aspectRatio //containerView.height =
                //extraHeight = height - imageView.frame.height
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
            else
            {
         //       print("called")
                //extraHeight = imageView.frame.height
                imageView.frame = CGRect.zero
            }
        }
       // print("extraHeight = ",extraHeight)
        preferredContentSize = .init(width: preferredContentSize.width, height: preferredContentSize.height)
    }
    
    func saveImageWayPoint()
    {
        let fm = FileManager()
        if let image = imageView.image
        {
            if let imageData = image.jpegData(compressionQuality: 1)
            {
                if let documentDiredctory = fm.urls(for: .documentDirectory, in: .userDomainMask).first
                {
                    let uniqueName = UUID().uuidString
                    let url = documentDiredctory.appendingPathComponent("\(uniqueName).jpeg")
                  
                    do
                    {
                        try imageData.write(to: url, options: .atomic)
                        wayPointToEdit?.links = [Link(href: url, type: "large")]
                    }catch
                    {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    }
    //MARK: - image picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        imageView.image = image
        makeRoomForImage()
        saveImageWayPoint()
        dismiss(animated: true)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
   
}


extension UIImage
{
    var aspectRatio:CGFloat
    {
        size.height != 0 || size.width == 0 ? size.width / size.height : 0
    }
}
