//
//  FaceView.swift
//  FaceDetector
//
//  Created by Taha Saleh on 4/19/24.
//

import UIKit
import AVFoundation
import Vision
@dynamicMemberLookup
class FaceView: UIView
{
    var text:String
    {
        get
        {
            return label.text ?? "no text found"
        }
        set
        {
            label.text = newValue
        }
    }
    var image:UIImage?
    {
        didSet
        {
            imageView.image = image
        }
    }
   // var cgImage : CGImage?
    private let label : UILabel =
    {
        let l = UILabel()
        l.text = "no Result yet"
        
        l.font = .systemFont(ofSize: 18)
        return l
        
    }()
     let imageView:UIImageView  = {
        let pictureView = UIImageView()
        pictureView.layer.borderWidth = 1
        
        return pictureView
    }()
    
    override init(frame: CGRect) 
    {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 20),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    required init?(coder: NSCoder) 
    {
        super.init(coder: coder)
        label.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 500),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 20),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    subscript(dynamicMember keyPath:KeyPath<UIImage,CGImage?>)->CGImage?
    {
        return self.image![keyPath: keyPath]
    }
    func drawRectOnSelectedImage(around face:VNFaceObservation)->UIImage?
    {
        guard self.image != nil else
        {
            return nil
        }
        let picuteFaceLocation = VNImageRectForNormalizedRect(face.boundingBox, Int(imageView.bounds.width ), Int(imageView.bounds.height ))
       let picuteFaceLocation2 = CGRect(x: picuteFaceLocation.minX, y: picuteFaceLocation.midY, width: picuteFaceLocation.width, height: picuteFaceLocation.height)
        
        
        let x : NSMutableAttributedString = NSMutableAttributedString(string: "😀")
        x.addAttribute(.font, value: UIFont.systemFont(ofSize: picuteFaceLocation.width), range: NSRange(location: 0, length: x.length))
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: image!.size, format: format)
        return renderer.image { context in
            image!.draw(at: .zero)
           
            //x.draw(in: .init(origin: .zero, size: .init(width: 50, height: 50)))
            context.cgContext.setStrokeColor(UIColor.red.cgColor)
            context.cgContext.setLineWidth(2)
            
            x.draw(in: picuteFaceLocation2)
            context.cgContext.stroke(picuteFaceLocation2)
        }
         
    }
   
}

extension UIImage
{
    func resize(to newSize:CGSize) ->UIImage
    {
        
        let newRect = AVMakeRect(aspectRatio: self.size, insideRect: .init(origin: .zero, size: newSize))
        let imageFormat = UIGraphicsImageRendererFormat()
        imageFormat.scale = 1
        let imageContext = UIGraphicsImageRenderer(size: newRect.size, format: imageFormat)
        let newImage = imageContext.image { context in
            //context.currentImage.draw(in: .init(origin: .zero, size: newRect.size)) this is a mistake
            // the newImage will draw its texture and content from an instance of uiimage (self in case of extension,
            // or self.workingImage if the method is defined in Viewcontroller
            self.draw(in: .init(origin: .zero, size: newRect.size))
        }
        return newImage
    }
}
