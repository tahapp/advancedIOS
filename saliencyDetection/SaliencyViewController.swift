//
//  ViewController.swift
//  saliencyDetection
//
//  Created by Taha Saleh on 4/28/24.
//

import UIKit
import AVFoundation
import Vision
import CoreImage.CIFilterBuiltins
class SaliencyViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate
{
    let imageMetadata:(String,String) = (name:"penguin",suffix:"png")
    var session:AVCaptureSession?
    var videoLayer:AVCaptureVideoPreviewLayer?
    let salientObjectLayer = CAShapeLayer()
    let salientMaskLayer = CALayer()
    
    var observation:VNSaliencyImageObservation?
    {
        didSet
        {
            DispatchQueue.main.async
            {[weak self] in
                self?.updateLayerContent()
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupCaptureSession()
        
        guard let newSession = session else
        {
            return
        }
        let layer = AVCaptureVideoPreviewLayer(session: newSession)
        layer.frame = view.layer.bounds
        layer.videoGravity = .resizeAspectFill
        layer.addSublayer(salientMaskLayer)
        salientObjectLayer.strokeColor = UIColor.orange.cgColor
        salientObjectLayer.fillColor = nil
        layer.addSublayer(salientObjectLayer)
        videoLayer = layer
        salientMaskLayer.opacity = 0.50
        view.layer.addSublayer(videoLayer!)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: .userInteractive).async {
            self.session?.startRunning()
        }
        view.setNeedsLayout()
        
    }
    override func viewDidLayoutSubviews() {
        self.updateLayerGeometry()
        super.viewDidLayoutSubviews()
    }
    
    func updateLayerGeometry()
    {
        if let baseLayer = videoLayer
        {
            print(baseLayer.contentsRect)
            print(baseLayer.visibleRect)
            let outputRect = CGRect(x: 0, y: 0, width: 1, height: 1)
            let videoRect = baseLayer.layerRectConverted(fromMetadataOutputRect: outputRect)
            salientMaskLayer.frame = videoRect
            salientObjectLayer.frame = videoRect
            
        }
    }
    deinit
    {
        print("finished")
        session?.stopRunning()
        videoLayer?.removeFromSuperlayer()
    }
    func setupCaptureSession()
    {
        //retreive the device to take a photo with
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)else{
            fatalError("error getting capture device")
        }
        // i think this is the camera live input
        guard let input = try? AVCaptureDeviceInput(device: device)else
        {
            fatalError("error getting capture input")
        }
        session = AVCaptureSession()
        session?.addInput(input) //this will store the data inout fro the camera
        
        let outPut = AVCaptureVideoDataOutput()
        outPut.alwaysDiscardsLateVideoFrames = true
        outPut.setSampleBufferDelegate(self, queue: .global(qos: .userInteractive))
        session?.addOutput(outPut) // this is the output of the image
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else
        {
            fatalError()
        }
        
        processingPixleBuffer(pixelBuffer)
    }
    
    func updateLayerContent()
    {
        if let newObservation = observation
        {
            DispatchQueue.global(qos: .userInteractive).async {
                let mask = createHeatMap(from: newObservation)
                DispatchQueue.main.async {
                    self.salientMaskLayer.contents = mask
                }
            }
           
        }
    }
    
    func processingPixleBuffer(_ buffer:CVPixelBuffer)
    {
        observation = processSaliency(type: .object, on: buffer, orientation: .right)
    }
}

