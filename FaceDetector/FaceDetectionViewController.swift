//
//  ViewController.swift
//  FaceDetector
//
//  Created by Taha Saleh on 4/5/24.
//

import UIKit
import Vision
import PhotosUI
class FaceDetectionViewController: UIViewController,PHPickerViewControllerDelegate, 
                                    UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var faceView: FaceView!
    let detectionModel = FaceDetectionModel()
    let photoPicker : PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = PHPickerFilter.all(of: [.images])
        configuration.selectionLimit = 1
        let photoPicker = PHPickerViewController(configuration: configuration)
        return photoPicker
        
    }()
    let cameraPicker : UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = true
        imagePicker.cameraDevice = .front
        imagePicker.cameraFlashMode = .off
        return imagePicker
    }()
    var imageSize:CGSize
    {
        if faceView.image?.size == .zero
        {
            return .zero
        }else
        {
            return CGSize(width: faceView.image!.size.width, height: faceView.image!.size.height)
        }
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        photoPicker.delegate = self
        cameraPicker.delegate = self
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] authorization in
            switch authorization
            {
            case .authorized:
                DispatchQueue.main.async {
                    self?.choosePhotoMethod()
                }
            default:
                break
            }
        }
    }
  //MARK: Pickers delegates
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
    {
        if let itemProvider = results.first?.itemProvider
        {
            itemProvider.loadDataRepresentation(forTypeIdentifier: "public.jpeg") {[weak self] rawData, error in
                if let data = rawData
                {
                    if let image = UIImage(data: data)
                    {
                        DispatchQueue.main.async
                        {
                            self?.faceView.image = image.resize(to: self!.faceView.imageView.bounds.size)
                        }
                    }
                }
            }
        }
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
//        workingImage = image.resize(to: facesImageView.bounds.size)
//        facesImageView.image  = workingImage
        faceView.image = image.resize(to: faceView.imageView.bounds.size)
        dismiss(animated: true)
    }
    func choosePhotoMethod()
    {
        let ac = UIAlertController(title: "upload image", message: "choose an image to work with", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "photoLibrary", style: .default, handler: { [ self] action in
            
            self.present(self.photoPicker,animated: true)
        }))
        ac.addAction(UIAlertAction(title: "use camera", style: .default, handler: { [ self] action in
            self.present(cameraPicker,animated: true)
        }))
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        present(ac,animated: true)
    }
 
    //MARK: analyze Models
    func analyzeFace()
    {
        detectionModel.detectFaceRect(image:faceView.cgImage) { [weak self] faceObservations  in
            guard let self = self else{return}
            
            guard let observations = faceObservations, observations.count > 0 else
            {
                DispatchQueue.main.async {
                    self.faceView.text = "no face detected"
                }
                return
            }
            DispatchQueue.main.async {
                self.faceView.text = "\(observations.count) face detected"
            }
            
            if let face = observations.first
            {
                DispatchQueue.main.async {
                    
                    self.faceView.image = self.faceView.drawRectOnSelectedImage(around: face)
                    
                }
            }
        }
    }
    
    func analyzeFaceLandMarks()
    {
        detectionModel.detectFaceLandmarks(image:faceView.cgImage) { [weak self] observations in
            guard let self = self else{return}
            
            guard let observations = observations, observations.count > 0 else
            {
                fatalError("no landmark")
                
            }
            if let observation = observations.first
            {
                if let points = observation.landmarks?.leftEye?.pointsInImage(imageSize: self.imageSize){
                   
                    let format = UIGraphicsImageRendererFormat()
                    format.scale = 1
                    let renderer = UIGraphicsImageRenderer(size: self.imageSize, format: format)
                    let image = renderer.image { context in
                        self.faceView.image?.draw(at: .zero)
                        
                        
                        context.cgContext.setLineWidth(2)
                        context.cgContext.setStrokeColor(UIColor.red.cgColor)
                        context.cgContext.beginPath()
                        context.cgContext.move(to: points[0])
                        for n in 1..<points.count
                        {
                            context.cgContext.addLine(to: points[n])
                        }
                        context.cgContext.scaleBy(x: 1.25, y: 1.25)
                        context.cgContext.strokePath()
                        
                        context.cgContext.closePath()
                        
                    }
                    DispatchQueue.main.async{
                        self.faceView.image = image
                    }
                }
            }
        }
    }

    @IBAction func performAnalysisOnImage(_ sender: UIBarButtonItem) 
    {
        analyzeFace()
        //analyzeFaceLandMarks()
    }
}


func getAddress<T:AnyObject>(of object: T)
{
    let pointer = Int(bitPattern: Unmanaged.passUnretained(object).toOpaque())
    let address = String(format: "%p", pointer)
    print(address)
    
}
