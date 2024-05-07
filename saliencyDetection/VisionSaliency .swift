//
//  VisionSaliency .swift
//  saliencyDetection
//
//  Created by Taha Saleh on 4/28/24.
//

import Vision
import CoreVideo
import CoreImage
import CoreFoundation

enum SaliencyType
{
    case attention, object
}
func processSaliency(type:SaliencyType,on pixelBuffer: CVPixelBuffer,orientation:CGImagePropertyOrientation)-> VNSaliencyImageObservation?
{
    let request = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: orientation,options: [:])
    return processSalientRequestOnHandler(type, on: request)
}

func processSalientRequestOnHandler(_ type:SaliencyType, on requestHandler:VNImageRequestHandler) -> VNSaliencyImageObservation?
{
    let request:VNRequest
    switch type
    {
    case .attention:
        request = VNGenerateAttentionBasedSaliencyImageRequest()
    case .object:
        request = VNGenerateObjectnessBasedSaliencyImageRequest()
    }
    try? requestHandler.perform([request])
    return request.results?.first as? VNSaliencyImageObservation
}
func createHeatMap(from observation:VNSaliencyImageObservation) ->CGImage?
{
    let pixelBuffer = observation.pixelBuffer
    let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
    let vector = CIVector(x: 0, y: 0, z: 1, w: 0)
    let salientImage = ciImage.applyingFilter("CIColorInvert")
    return CIContext().createCGImage(salientImage, from: salientImage.extent)
}
