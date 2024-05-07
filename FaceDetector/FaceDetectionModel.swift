//
//  Model.swift
//  FaceDetector
//
//  Created by Taha Saleh on 4/19/24.
//

import Vision

class FaceDetectionModel
{
    func detectFaceRect(image:CGImage?,completion: @escaping ([VNFaceObservation]?)->Void)
    {
        guard let cgImage = image else
        {
            return completion(nil)
        }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        
        let request = VNDetectFaceRectanglesRequest { baseRequest, error in
            guard error == nil else
            {
                return completion(nil)
            }
            if let outcome = baseRequest.results as? [VNFaceObservation]
            {
                
                completion(outcome)
            }else
            {
                completion([])
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            do
            {
                try handler.perform([request])
            }catch
            {
                completion(nil)
            }
        }
    }
    func detectFaceLandmarks(image:CGImage?,completion: @escaping ([VNFaceObservation]?)->Void)
    {
        guard let cgImage = image else
        {
            return
        }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNDetectFaceLandmarksRequest { faceRequest, error in
            guard  error == nil else
            {
                return completion(nil)
            }
            if let observations = faceRequest.results as?[VNFaceObservation]
            {
                completion(observations)
            }else
            {
                completion([])
            }
        }
        DispatchQueue.global(qos: .background).async {
            do
            {
                try handler.perform([request])
            }catch
            {
                completion(nil)
            }
        }
    }

}
