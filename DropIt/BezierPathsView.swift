//
//  BezierPathsView.swift
//  DropIt
//
//  Created by ben hussain on 9/21/23.
//

import UIKit
/* the barrier we can't see. so we have have to transfer it from being a generic view to a view that can draws itself.
 */
class BezierPathView: UIView
{
    private var bezierPaths = [NSString:UIBezierPath]()
    
    func setPath(path: UIBezierPath?, name:NSString)
    {
        //optional to be able to set it to nil and removes an path
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    // that's it just stroke it
    override func draw(_ rect: CGRect) {
        for(_,path) in bezierPaths
        {
            path.stroke()
        }
    }
}
