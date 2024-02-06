//
//  extensions.swift
//  AutoLayout
//
//  Created by ben hussain on 7/28/23.
//

import UIKit


extension UIView
{
    func addSubviews(_ views: UIView...)
    {
        for v in  views
        {
            addSubview(v)
        }
    }
}
extension User
{
    var image: UIImage?
    {
        
        get
        {
            
            if let image = UIImage(named: login)
            {
                
                return image
            }else
            {
                
                return UIImage(named: "unknown")
            }
        }
       
        
    }
}

extension UIImage
{
    var ratio: CGFloat
    {
        return size.height != 0 ? size.width / size.height : 0
    }
}
