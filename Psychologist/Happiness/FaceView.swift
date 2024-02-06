//
//  FaceView.swift
//  Happiness
//
//  Created by ben hussain on 4/17/23.
//

import UIKit
@IBDesignable
final class FaceView: UIView
{
    
    weak var dataSource: FaceViewDataSource?
    
    var lineWidth: CGFloat = 1
    {
    
        didSet
        {
            setNeedsDisplay()
        }
    }
    var color:UIColor = UIColor.blue
    {
        
        didSet
        {
            setNeedsDisplay()
        }
    }
    var scale : CGFloat = 0.90{
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    var faceCenter: CGPoint
    {
        return convert(center, from: superview)
    }
    var faceRadius:CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    @objc  func scaleSize( _ gesture:UIPinchGestureRecognizer)
    {
        if gesture.state == .changed
        {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    private enum Eye
    {
        case left , right
    }
    private func pathForEye(_ eye : Eye) ->UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadisRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius/Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        
        switch eye {
        case .left:
            eyeCenter.x -= eyeHorizontalSeparation / 2
        case .right:
            eyeCenter.x += eyeHorizontalSeparation / 2
        }
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: (2 * .pi), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    private struct Scaling
    {
        static let FaceRadiusToEyeRadisRatio : CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio:CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio:CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio:CGFloat = 1
        static let FaceRadiusToMouthHeightRatio:CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio:CGFloat = 3
    }
    func pathForSmile(smilenessLevel:Double) ->UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat( max( min(smilenessLevel,1), -1 ) ) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        
        let end = CGPoint(x:start.x + mouthWidth,y:start.y)
        let cp1 = CGPoint(x:start.x + mouthWidth / 3, y : start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3,y:cp1.y)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    override func draw(_ rect: CGRect)
    {
        
         
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
      
        facePath.lineWidth = lineWidth
        
        color.set()
        
        facePath.stroke() 
        pathForEye(.left).stroke()
        pathForEye(.right).stroke()
        
        let smile = dataSource?.adjustSmilness(self) ?? 0.0
        let smilePath = pathForSmile(smilenessLevel: smile)
        smilePath.stroke()
        
    }

}
