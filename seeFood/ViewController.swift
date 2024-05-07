//
//  ViewController.swift
//  seeFood
//
//  Created by Taha Saleh on 3/31/24.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate
{

    @IBOutlet weak var hotDogLabel: UILabel!
   
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if UIImagePickerController.isCameraDeviceAvailabe(.front, .rear)
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.mediaTypes = ["public.image"]
            }
        }
    }

    @IBAction func cameraTaped(_ sender: UIBarButtonItem) 
    {
        present(imagePicker,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else{return}
        imageView.image = image
        decodeImage(with: image)
        dismiss(animated: true)
    }
    
    func decodeImage(with image: UIImage)
    {
        guard let cgImage = CIImage(image: image) else
        {
            return
        }
        do
        {
            let inceptionModel = try Inceptionv3(configuration: .init()).model
            let visionModel = try VNCoreMLModel(for:inceptionModel)
            /* based on the image on https://developer.apple.com/documentation/coreml/,
             Vision,  Natural Language,  Speech , Sound Analysis frameworks are under your app. which means that your app
             will interact will theseframework and these framework will interact wil coreML moddel. */
            let request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                guard let results = request.results as? [VNClassificationObservation] else
                {
                    return
                }
                
                DispatchQueue.main.async {
                    if let firstItem = results.first
                    {
                        if firstItem.identifier.contains("hot dog")
                        {
                            self?.hotDogLabel.text = "it is a hot dog"
                            self?.hotDogLabel.backgroundColor = .green.withAlphaComponent(0.2)
                        }else
                        {
                            self?.hotDogLabel.text = "it is not a hot dog"
                            self?.hotDogLabel.backgroundColor = .red.withAlphaComponent(0.2)
                        }
                    }
                }
                
                
            }
            let handler = VNImageRequestHandler(cgImage: cgImage.cgImage!)
            
            try handler.perform([request])
        }catch
        {
            fatalError(error.localizedDescription)
        }
        
    }
}

extension UIImagePickerController
{
    static func isCameraDeviceAvailabe(_ cameras : CameraDevice...) ->Bool
    {
        return UIImagePickerController.isCameraDeviceAvailable(.front) && UIImagePickerController.isCameraDeviceAvailable(.rear)
    }
}
